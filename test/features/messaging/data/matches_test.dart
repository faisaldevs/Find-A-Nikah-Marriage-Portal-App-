import 'package:find_a_nikah/features/messaging/data/data.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:find_a_nikah/features/messaging/data/mappers/messaging_mappers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

/// One row as `GET /v1/matches/my-matches` returned it (2026-11-02),
/// trimmed to the fields that matter plus a few ignored ones.
Map<String, dynamic> _row({
  String id = '6ad0bb4de5da1aac928553e6',
  String name = 'QA Tester',
}) => {
  '_id': 'm-$id',
  'matchId': 'm-$id',
  'users': <Object>[],
  'status': 'active',
  'matchedAt': '2026-11-02T05:42:15.683Z',
  'partner': {
    '_id': id,
    'fullName': name,
    'isVerified': true,
    'lastActiveAt': '2026-10-29T05:23:38.897Z',
    'gender': 'male',
  },
  'profile': {
    'userId': id,
    'fullName': name,
    'photoUrl': '/public/upload/a.jpg',
    'images': ['/public/upload/a.jpg', '/public/upload/b.jpg'],
    'age': 22,
  },
  'conversationId': 'conv-$id',
  'conversation': {'_id': 'conv-$id', 'lastMessagePreview': null},
  'canMessage': true,
  'isMatch': true,
  'isFriend': true,
};

Map<String, dynamic> _response(
  List<Map<String, dynamic>> rows, {
  int page = 1,
  bool hasNext = false,
}) => {
  'statusCode': 200,
  'data': {
    'matches': rows,
    'pagination': {
      'currentPage': page,
      'limit': 50,
      'totalPages': hasNext ? page + 1 : page,
      'totalCount': rows.length,
      'hasNext': hasNext,
      'hasPrev': page > 1,
    },
    'totalCount': rows.length,
  },
  'message': 'Your matches',
  'success': true,
};

class _FakeMatchesRemote implements MatchesRemoteDataSource {
  _FakeMatchesRemote(this.pages);

  /// Page number → raw response.
  final Map<int, Map<String, dynamic>> pages;
  final requested = <int>[];

  @override
  Future<MyMatchesResponseDto> fetchMyMatches({
    required int page,
    required int limit,
  }) async {
    requested.add(page);
    return MyMatchesResponseDto.fromJson(pages[page]!);
  }

  @override
  Future<MyMatchesResponseDto> fetchUnmatched({
    String status = 'unmatched',
    required int page,
    required int limit,
  }) async => MyMatchesResponseDto.fromJson(pages[1]!);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MatchDto → peer', () {
    test('partner id + name, absolute photo, lastActiveAt as last seen', () {
      final peer = MatchDto.fromJson(
        _row(),
      ).toPeerDto(imageBaseUrl: 'https://api.test')!;
      expect(peer.id, '6ad0bb4de5da1aac928553e6');
      expect(peer.name, 'QA Tester');
      expect(peer.photoUrl, 'https://api.test/public/upload/a.jpg');
      expect(peer.isOnline, isFalse);
      expect(peer.lastSeenAt, DateTime.utc(2026, 10, 29, 5, 23, 38, 897));
    });

    test('falls back to the first image, then to no photo', () {
      final noPrimary = _row()
        ..['profile'] = {
          'images': ['/public/upload/b.jpg'],
        };
      expect(
        MatchDto.fromJson(noPrimary).toPeerDto(imageBaseUrl: 'x')!.photoUrl,
        'x/public/upload/b.jpg',
      );
      final none = _row()..['profile'] = null;
      expect(
        MatchDto.fromJson(none).toPeerDto(imageBaseUrl: 'x')!.photoUrl,
        '',
      );
    });

    test('a row with no partner id is dropped', () {
      final row = _row()
        ..['partner'] = null
        ..['profile'] = null;
      expect(MatchDto.fromJson(row).toPeerDto(imageBaseUrl: 'x'), isNull);
    });
  });

  group('DummyMessagingRepositoryImpl matches', () {
    late DummyMessagingDataSource dummy;

    setUp(() => dummy = DummyMessagingDataSource(latency: Duration.zero));
    tearDown(() => dummy.dispose());

    DummyMessagingRepositoryImpl repoWith(_FakeMatchesRemote remote) =>
        DummyMessagingRepositoryImpl(
          dummy,
          remote,
          testGuard(),
          'https://api.test',
        );

    test('lists the API matches, not the fixture ones', () async {
      final repo = repoWith(
        _FakeMatchesRemote({
          1: _response([_row(), _row(id: 'u2', name: 'Second')]),
        }),
      );
      final matches = await repo.watchMatches().first;
      expect([for (final m in matches) m.name], ['QA Tester', 'Second']);
    });

    test('reads every page until hasNext is false', () async {
      final remote = _FakeMatchesRemote({
        1: _response([_row()], hasNext: true),
        2: _response([_row(id: 'u2', name: 'Second')], page: 2),
      });
      final matches = await repoWith(remote).watchMatches().first;
      expect(remote.requested, [1, 2]);
      expect(matches, hasLength(2));
    });

    test('a picked match takes its slot and leaves the panel', () async {
      final repo = repoWith(
        _FakeMatchesRemote({
          1: _response([_row(), _row(id: 'u2', name: 'Second')]),
        }),
      );
      final emissions = repo.watchMatches();
      // Subscribing fetches the matches the pick reads its peer from.
      final first = await emissions.first;
      expect(first, hasLength(2));

      final opened = await repo.openConversation('u2', slot: 4);
      final conversation = opened.getOrElse((f) => throw StateError('$f'));
      expect(conversation.slot, 4);
      expect(conversation.peer.name, 'Second');
      expect(
        conversation.peer.photoUrl,
        'https://api.test/public/upload/a.jpg',
      );

      final after = await repo.watchMatches().first;
      expect([for (final m in after) m.id], ['6ad0bb4de5da1aac928553e6']);
    });
  });
}
