import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('id-based Feed routes', () {
    test('paths carry the id', () {
      expect(RoutePaths.feedPostPath('abc'), '/feed/post/abc');
      expect(RoutePaths.feedProfilePath('u1'), '/feed/profile/u1');
      expect(RoutePaths.feedProfileSearchPath('u1'), '/feed/profile/u1/search');
    });

    test('a signed-in member may open them (not bounced to Marriage)', () {
      expect(RoutePaths.isAppLocation('/feed/post/abc'), isTrue);
      expect(RoutePaths.isAppLocation('/feed/profile/u1'), isTrue);
      expect(RoutePaths.isAppLocation('/feed/profile/u1/search'), isTrue);
      expect(RoutePaths.isAppLocation(RoutePaths.feedCompose), isTrue);
      expect(RoutePaths.isAppLocation(RoutePaths.feed), isTrue);
    });

    test('other paths are still not app locations', () {
      expect(RoutePaths.isAppLocation('/feed-something'), isFalse);
      expect(RoutePaths.isAppLocation('/login'), isFalse);
    });
  });
}
