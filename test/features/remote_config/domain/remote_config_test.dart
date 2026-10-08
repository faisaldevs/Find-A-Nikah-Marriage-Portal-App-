import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compareVersions', () {
    test('numeric, not lexical', () {
      expect(RemoteConfig.compareVersions('1.2.10', '1.2.9'), 1);
      expect(RemoteConfig.compareVersions('1.2.9', '1.2.10'), -1);
      expect(RemoteConfig.compareVersions('2.0.0', '2.0.0'), 0);
    });

    test('missing parts are 0; build and pre-release ignored', () {
      expect(RemoteConfig.compareVersions('1.2', '1.2.0'), 0);
      expect(RemoteConfig.compareVersions('1.2.3+45', '1.2.3'), 0);
      expect(RemoteConfig.compareVersions('1.2.3-beta', '1.2.3'), 0);
    });
  });

  test('requiresUpdate only below the floor', () {
    const config = RemoteConfig(minimumSupportedVersion: '1.4.0');
    expect(config.requiresUpdate('1.3.9'), isTrue);
    expect(config.requiresUpdate('1.4.0'), isFalse);
    expect(config.requiresUpdate('2.0.0'), isFalse);
    expect(const RemoteConfig().requiresUpdate('0.0.1'), isFalse);
  });

  test('flags fall back to their defaults', () {
    const empty = RemoteConfig();
    expect(empty.isEnabled(FeatureFlag.faceVerification), isTrue);
    expect(empty.isEnabled(FeatureFlag.realtime), isFalse);

    const remote = RemoteConfig(
      flags: {'faceVerification': false, 'realtime': true},
    );
    expect(remote.isEnabled(FeatureFlag.faceVerification), isFalse);
    expect(remote.isEnabled(FeatureFlag.realtime), isTrue);
  });
}
