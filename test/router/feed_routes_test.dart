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
      expect(RoutePaths.isAppLocation('/feed/u/u1'), isTrue);
      expect(RoutePaths.isAppLocation(RoutePaths.feedCompose), isTrue);
      expect(RoutePaths.isAppLocation(RoutePaths.feed), isTrue);
    });

    test('other paths are still not app locations', () {
      expect(RoutePaths.isAppLocation('/feed-something'), isFalse);
      expect(RoutePaths.isAppLocation('/login'), isFalse);
    });
  });

  group('shared links and own profile', () {
    test('feed links are recognised so a cold start can keep them', () {
      expect(RoutePaths.isFeedLink('/feed/post/abc'), isTrue);
      expect(RoutePaths.isFeedLink('/feed/u/u1'), isTrue);
      expect(RoutePaths.isFeedLink('/feed/profile/u1'), isTrue);
      expect(RoutePaths.isFeedLink('/feed/profile/u1/search'), isFalse);
      expect(RoutePaths.isFeedLink('/feed'), isFalse);
      expect(RoutePaths.isFeedLink('/login'), isFalse);
    });

    test('the own-profile route is an app location', () {
      expect(RoutePaths.isAppLocation(RoutePaths.feedMe), isTrue);
    });
  });
}
