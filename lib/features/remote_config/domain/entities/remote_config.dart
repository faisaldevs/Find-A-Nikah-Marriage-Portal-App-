import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';

/// Remote kill switches. Every risky feature sits behind one so it can be
/// turned off without a release. [defaultValue] applies when the config
/// can't be fetched or doesn't mention the flag.
enum FeatureFlag {
  /// Selfie verification step after "Add your photos".
  faceVerification(defaultValue: true),

  /// Guided 3-pose liveness capture instead of the single-selfie flow, on
  /// "Start verification". Off by default: the backend endpoints it calls
  /// (`/profile/face-verification*`) aren't confirmed yet — see
  /// `FaceVerificationRemoteDataSource`'s `TODO(api)` notes.
  livenessEnabled(defaultValue: false);

  const FeatureFlag({required this.defaultValue});

  final bool defaultValue;
}

/// What `GET /config` returns: kill switches and the minimum supported app
/// version (decisions register #17: own endpoint).
@freezed
abstract class RemoteConfig with _$RemoteConfig {
  const factory RemoteConfig({
    /// Builds below this are blocked by the force-update screen. Null = no
    /// floor.
    String? minimumSupportedVersion,
    @Default(<String, bool>{}) Map<String, bool> flags,
  }) = _RemoteConfig;

  const RemoteConfig._();

  bool isEnabled(FeatureFlag flag) => flags[flag.name] ?? flag.defaultValue;

  /// True when [currentVersion] is below [minimumSupportedVersion].
  bool requiresUpdate(String currentVersion) {
    final minimum = minimumSupportedVersion;
    if (minimum == null) return false;
    return compareVersions(currentVersion, minimum) < 0;
  }

  /// Compares dotted numeric versions (`1.2.10` > `1.2.9`). Build metadata
  /// (`+12`) and pre-release tags (`-beta`) are ignored; missing parts
  /// count as 0.
  static int compareVersions(String a, String b) {
    List<int> parts(String v) => v
        .split(RegExp('[+-]'))
        .first
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
    final x = parts(a);
    final y = parts(b);
    for (var i = 0; i < (x.length > y.length ? x.length : y.length); i++) {
      final diff = (i < x.length ? x[i] : 0) - (i < y.length ? y[i] : 0);
      if (diff != 0) return diff.sign;
    }
    return 0;
  }
}
