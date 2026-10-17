import 'dart:io';

import 'package:find_a_nikah/core/error/app_exception.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Shrinks a photo before upload: long edge capped at [_maxDimension],
/// EXIF stripped (removes GPS), one lower-quality retry if still over
/// [_maxBytes]. Shared by onboarding profile photos and face-verification
/// captures — lives in `core/` because features never import each other.
///
/// Throws [DeviceException] when the native compressor fails.
class ImageCompressor {
  const ImageCompressor();

  static const _maxDimension = 1080;
  static const int _maxBytes = 1536 * 1024; // 1.5MB
  static const _quality = 80;
  static const _retryQuality = 60;

  /// Compresses the image at [sourcePath] to a new temp file named
  /// [outputName] (e.g. `'step1.jpg'`) and returns its path.
  Future<String> compress(
    String sourcePath, {
    required String outputName,
  }) async {
    try {
      final targetPath = '${Directory.systemTemp.path}/$outputName';
      var file = await _compressTo(sourcePath, targetPath, _quality);
      if (await file.length() > _maxBytes) {
        file = await _compressTo(sourcePath, targetPath, _retryQuality);
      }
      return file.path;
    } on DeviceException {
      rethrow;
    } on Object catch (e) {
      throw DeviceException('image compress: ${e.runtimeType}');
    }
  }

  Future<File> _compressTo(
    String sourcePath,
    String targetPath,
    int quality,
  ) async {
    // minHeight and keepExif: false are the plugin's own defaults — left
    // unset rather than redundantly passed.
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: quality,
      minWidth: _maxDimension,
    );
    if (result == null) {
      throw const DeviceException('image compress: null result');
    }
    return File(result.path);
  }
}
