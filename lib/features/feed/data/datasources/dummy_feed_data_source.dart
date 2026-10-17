import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';

/// Dev-flavor stand-in for the Feed API, with the copy taken straight from
/// the Figma Feed flow. In-memory, so a new post shows up until restart.
/// Portraits come from an online avatar service (needs internet), same as
/// the other dummy sources.
class DummyFeedDataSource {
  DummyFeedDataSource({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  static const _allThingsMarriage = 'All things marriage';
  static const _random = 'Random';
  static const _funAndLaughs = 'Fun & Laughs';
  static const _converts = 'Converts / Reverts';

  static const _me = FeedAuthor(
    name: 'Tabassum',
    handle: 'tabassum',
    photoUrl: 'https://i.pravatar.cc/200?img=49',
    countryCode: 'bd',
  );
  static const _mamun = FeedAuthor(
    name: 'Mamunur Roshid',
    handle: 'Mamun75228',
    photoUrl: 'https://i.pravatar.cc/200?img=12',
    countryCode: 'bd',
  );
  static const _alexander = FeedAuthor(
    name: 'Alexander',
    handle: 'AlexanderTheLate',
    photoUrl: 'https://i.pravatar.cc/200?img=14',
    countryCode: 'bd',
  );
  static const _khalil = FeedAuthor(
    name: 'Khalil',
    handle: 'Khalil1083',
    photoUrl: 'https://i.pravatar.cc/200?img=53',
  );
  static const _ali = FeedAuthor(
    name: 'Ali',
    handle: '404NF',
    photoUrl: 'https://i.pravatar.cc/200?img=60',
  );

  final List<FeedPost> _posts = [
    const FeedPost(
      id: 'p1',
      author: FeedAuthor(
        name: 'Ayat nurr',
        handle: 'ayat_an_nurr',
        photoUrl: 'https://i.pravatar.cc/200?img=47',
        countryCode: 'bd',
      ),
      topic: _allThingsMarriage,
      postedAgo: '9h ago',
      body:
          'Unpopular opinion: A person can be religious, educated, '
          'financially stable, and still be a terrible spouse. So what '
          'quality do you think actually predicts whether someone will be '
          'a good husband or wife in the long run?',
      likeCount: 3,
      commentCount: 6,
      viewCount: 412,
    ),
    const FeedPost(
      id: 'p2',
      author: FeedAuthor(
        name: 'Amina Khan',
        handle: 'amina_khan',
        photoUrl: 'https://i.pravatar.cc/200?img=45',
        countryCode: 'tr',
      ),
      topic: _allThingsMarriage,
      postedAgo: '1 days ago',
      body:
          'A peaceful marriage grows through kindness, patience, and '
          'listening to each other. Small acts of care make a big '
          'difference.',
      likeCount: 41,
      commentCount: 10,
      viewCount: 1000,
    ),
    const FeedPost(
      id: 'p3',
      author: FeedAuthor(
        name: 'Nur Aisyah',
        handle: 'nur_aisyah',
        photoUrl: 'https://i.pravatar.cc/200?img=44',
        countryCode: 'my',
      ),
      topic: _random,
      postedAgo: '2 days ago',
      body:
          'A strong marriage starts with honest conversations. Share your '
          'hopes, listen with an open heart, and grow together one day at '
          'a time.',
      likeCount: 127,
      commentCount: 3,
      viewCount: 4000,
    ),
    const FeedPost(
      id: 'p4',
      author: _me,
      topic: _funAndLaughs,
      postedAgo: '5h ago',
      body:
          'Marriage is finding someone who knows exactly how you like your '
          'tea, then debating whose turn it is to make it. Small moments, '
          'big laughs. Every single day.',
      likeCount: 12,
      commentCount: 24,
      viewCount: 1700,
    ),
    _mamunPosts.first.copyWith(topComment: null),
  ];

  static const _mamunPosts = [
    FeedPost(
      id: 'm1',
      author: _mamun,
      topic: _allThingsMarriage,
      postedAgo: '1d ago',
      body:
          'A strong marriage grows through kindness, honest conversations, '
          'and shared effort. What small habit helps you feel connected?',
      likeCount: 1,
      commentCount: 6,
      viewCount: 591,
      topComment: FeedComment(
        id: 'mc1',
        author: _alexander,
        postedAgo: '1d ago',
        body:
            'A daily check-in helps us listen to each other, even when life '
            'gets busy.',
        replyCount: 5,
      ),
    ),
    FeedPost(
      id: 'm2',
      author: _mamun,
      topic: _converts,
      postedAgo: '1d ago',
      body:
          "If you're new to Islam, what helped you feel welcome in the "
          'community? Share a kind word or practical tip for someone '
          'starting their journey.',
      likeCount: 4,
      commentCount: 2,
      viewCount: 230,
    ),
  ];

  static const _comments = [
    FeedComment(
      id: 'c1',
      author: _khalil,
      postedAgo: '4h ago',
      edited: true,
      body: 'Tea always wins.',
      likeCount: 1,
      replies: [
        FeedComment(
          id: 'c1r1',
          author: _me,
          postedAgo: '4h ago',
          isPostAuthor: true,
          mention: 'Khalil1083',
          body: 'Agreed!',
        ),
      ],
    ),
    FeedComment(
      id: 'c2',
      author: _ali,
      postedAgo: '5h ago',
      body:
          'The tea debate never ends.\n'
          'Who handles the dishes after all that?\n'
          "That's the real test.",
      replies: [
        FeedComment(
          id: 'c2r1',
          author: _me,
          postedAgo: '5h ago',
          isPostAuthor: true,
          mention: '404NF',
          body: 'We take turns. The tea maker gets a break from washing up!',
        ),
      ],
    ),
    FeedComment(
      id: 'c3',
      author: _ali,
      postedAgo: '4h ago',
      mention: 'Tabassum',
      body:
          'Fair deal!\n'
          'Teamwork keeps the peace.\n'
          '\n'
          'Now you just need to agree on snacks.',
    ),
  ];

  Future<T> _later<T>(T value) async {
    await Future<void>.delayed(latency);
    return value;
  }

  Future<FeedAuthor> fetchMe() => _later(_me);

  Future<List<FeedTopic>> fetchTopics() => _later([
    const FeedTopic(id: 'random', name: _random),
    FeedTopic(
      id: 'all-things-marriage',
      name: _allThingsMarriage,
      imageUrl: Assets.images.feedTopicAllThingsMarriage,
    ),
    const FeedTopic(id: 'fun-and-laughs', name: _funAndLaughs),
    const FeedTopic(id: 'converts-reverts', name: _converts),
  ]);

  /// Newest first, so "New" and "For you" share an order until a real
  /// ranking exists.
  Future<List<FeedPost>> fetchPosts(FeedFilter filter) =>
      _later(switch (filter) {
        FeedForYou() || FeedNewest() => List.of(_posts),
        FeedTopicFilter(:final topic) =>
          _posts.where((p) => p.topic == topic.name).toList(),
      });

  Future<List<FeedComment>> fetchComments(String postId, CommentSort sort) =>
      _later(switch (sort) {
        CommentSort.mostPopular => _comments,
        CommentSort.mostRecent => _comments.reversed.toList(),
      });

  Future<FeedProfile> fetchProfile(String handle) {
    final known = [
      for (final p in _posts) p.author,
      for (final c in _comments) ...[
        c.author,
        for (final r in c.replies) r.author,
      ],
      _mamun,
      _alexander,
    ];
    final author = known.firstWhere(
      (a) => a.handle == handle,
      orElse: () => FeedAuthor(name: handle, handle: handle, photoUrl: ''),
    );
    return _later(
      FeedProfile(
        author: author,
        countryName: 'Bangladesh',
        joined: 'Oct 2026',
        followers: 6,
        following: 4,
      ),
    );
  }

  Future<List<FeedPost>> fetchProfilePosts(String handle) => _later(
    handle == _mamun.handle
        ? _mamunPosts
        : _posts.where((p) => p.author.handle == handle).toList(),
  );

  Future<FeedPost> createPost({
    required FeedTopic topic,
    required String body,
    required bool anonymous,
  }) async {
    final post = FeedPost(
      id: 'new-${DateTime.now().microsecondsSinceEpoch}',
      author: anonymous
          ? const FeedAuthor(
              name: 'Anonymous',
              handle: 'anonymous',
              photoUrl: '',
            )
          : _me,
      topic: topic.name,
      postedAgo: 'just now',
      body: body,
    );
    _posts.insert(0, post);
    return _later(post);
  }
}
