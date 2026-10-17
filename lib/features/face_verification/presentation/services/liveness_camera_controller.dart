import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Live front-camera feed + per-frame face analysis for
/// `LivenessCapturePage`. Owned by the page's `State` (camera lifecycle is
/// a widget-tree concern, like `CameraPreview` itself), not injected into
/// `FaceVerificationBloc` — the bloc only ever sees the domain-safe
/// [FaceSnapshot]s this emits and the still-image paths [captureStill]
/// returns, never a `package:camera` type, so the architecture boundary
/// between presentation and data stays intact (the bloc's still-photo
/// pose check already goes through `FaceVerificationRepository.checkSelfie`
/// instead).
///
/// [snapshots] is throttled to one in-flight analysis at a time — frames
/// arrive faster than ML Kit can score them.
class LivenessCameraController {
  CameraController? _cameraController;
  FaceDetector? _detector;
  StreamController<FaceSnapshot>? _snapshotsController;
  bool _busy = false;
  bool _streaming = false;

  /// In-flight [dispose] — [initialize] waits for it so a quick
  /// background → resume can't open the new camera while the old one is
  /// still tearing down (and have its snapshot stream closed under it).
  Future<void>? _disposing;

  CameraController? get cameraController => _cameraController;

  Stream<FaceSnapshot> get snapshots =>
      (_snapshotsController ??= StreamController<FaceSnapshot>.broadcast())
          .stream;

  /// Opens the front camera and starts the analysis stream. Safe to call
  /// again after [dispose] (app backgrounded then resumed).
  Future<void> initialize() async {
    await _disposing;
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        front,
        // high (≈1280×720): medium (720×480) stills were too small for the
        // backend's face detector ("no face detected").
        // ResolutionPreset.medium,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      _cameraController = controller;
      // performanceMode: fast is ML Kit's own default — live frames need
      // it light-weight, unlike SelfieFaceDetector's accurate-mode gate
      // on a single still.
      _detector = FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: true,
          minFaceSize: 0.15,
        ),
      );
      await controller.startImageStream(_onFrame);
      _streaming = true;
    } on Object catch (e) {
      throw DeviceException('camera init: ${e.runtimeType}');
    }
  }

  void _onFrame(CameraImage image) {
    if (_busy) return;
    _busy = true;
    unawaited(
      _analyze(image)
          .then((snapshot) {
            if (snapshot != null) {
              _snapshotsController?.add(snapshot);
            }
          })
          .catchError((_) {})
          .whenComplete(() => _busy = false),
    );
  }

  Future<FaceSnapshot?> _analyze(CameraImage image) async {
    final controller = _cameraController;
    final detector = _detector;
    if (controller == null || detector == null) return null;
    final inputImage = _toInputImage(image, controller);
    if (inputImage == null) return null;

    final faces = await detector.processImage(inputImage);
    if (faces.length != 1) {
      return FaceSnapshot(faceCount: faces.length);
    }

    final face = faces.single;
    final box = face.boundingBox;
    // ML Kit reports the box in the *upright* (rotated) frame, but
    // CameraImage dimensions are the raw sensor buffer's — usually
    // landscape. Swap them for a 90°/270° rotation, or the face looks
    // off-centre and too small even when it's dead centre.
    final sideways = switch (inputImage.metadata?.rotation) {
      InputImageRotation.rotation90deg ||
      InputImageRotation.rotation270deg => true,
      _ => false,
    };
    final width = (sideways ? image.height : image.width).toDouble();
    final height = (sideways ? image.width : image.height).toDouble();
    final dx = (box.left + box.width / 2) - width / 2;
    final dy = (box.top + box.height / 2) - height / 2;

    return FaceSnapshot(
      faceCount: 1,
      yaw: face.headEulerAngleY,
      pitch: face.headEulerAngleX,
      roll: face.headEulerAngleZ,
      leftEyeOpenProbability: face.leftEyeOpenProbability,
      rightEyeOpenProbability: face.rightEyeOpenProbability,
      boxWidthRatio: box.width / width,
      boxCenterOffsetRatio: Offset(dx, dy).distance / width,
    );
  }

  /// `TODO(device)`: rotation is derived from the sensor orientation only
  /// — verify against device orientation on a real Android *and* a real
  /// iPhone (spec §12), the same hardware pass `LivenessConfig.yawSign`
  /// needs.
  InputImage? _toInputImage(CameraImage image, CameraController controller) {
    final rotation =
        InputImageRotationValue.fromRawValue(
          controller.description.sensorOrientation,
        ) ??
        InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(
      image.format.raw as int,
    );
    if (format == null) return null;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Pauses the stream, takes a still, resumes the stream. Returns the
  /// captured file's path.
  Future<String> captureStill() async {
    final controller = _cameraController;
    if (controller == null) {
      throw const DeviceException('camera not initialized');
    }
    try {
      if (_streaming) {
        await controller.stopImageStream();
        _streaming = false;
      }
      final file = await controller.takePicture();
      return file.path;
    } on Object catch (e) {
      throw DeviceException('camera capture: ${e.runtimeType}');
    } finally {
      if (!_streaming && controller.value.isInitialized) {
        await controller.startImageStream(_onFrame);
        _streaming = true;
      }
    }
  }

  /// Pauses the stream once, takes [count] full-quality photos back to
  /// back, resumes the stream. Returns the files in capture order.
  Future<List<String>> captureBurst(int count) async {
    final controller = _cameraController;
    if (controller == null) {
      throw const DeviceException('camera not initialized');
    }
    // Lock exposure/focus while the live preview is correctly exposed:
    // stopping the stream can reset auto-exposure on Android, and the first
    // still then came out blown-out white (backend: "no face detected").
    var locked = false;
    try {
      try {
        await controller.setExposureMode(ExposureMode.locked);
        await controller.setFocusMode(FocusMode.locked);
        locked = true;
      } on Object {
        // Not supported on every device — capture anyway.
      }
      if (_streaming) {
        await controller.stopImageStream();
        _streaming = false;
      }
      final paths = <String>[];
      for (var i = 0; i < count; i++) {
        paths.add((await controller.takePicture()).path);
      }
      return paths;
    } on Object catch (e) {
      throw DeviceException('camera burst: ${e.runtimeType}');
    } finally {
      if (locked && controller.value.isInitialized) {
        try {
          await controller.setExposureMode(ExposureMode.auto);
          await controller.setFocusMode(FocusMode.auto);
        } on Object {
          // Best effort.
        }
      }
      if (!_streaming && controller.value.isInitialized) {
        await controller.startImageStream(_onFrame);
        _streaming = true;
      }
    }
  }

  Future<void> dispose() {
    final disposing = _dispose();
    _disposing = disposing;
    return disposing;
  }

  Future<void> _dispose() async {
    final controller = _cameraController;
    _cameraController = null;
    // Detach synchronously so an `initialize()` racing this teardown gets
    // a fresh stream instead of the one about to be closed.
    final snapshots = _snapshotsController;
    _snapshotsController = null;
    if (_streaming && controller != null) {
      await controller.stopImageStream();
      _streaming = false;
    }
    await controller?.dispose();
    final detector = _detector;
    _detector = null;
    await detector?.close();
    // Closed controllers can't be reused — the next `initialize()` (app
    // resumed) starts a fresh stream via `??=`.
    await snapshots?.close();
  }
}
