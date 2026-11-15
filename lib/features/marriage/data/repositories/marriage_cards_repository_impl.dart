import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/data/datasources/marriage_cards_remote_data_source.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_dto.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_mapper.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';

/// Marriage feed on the real API: `GET /v1/profiles/cards`, cursor-paged.
/// Each card already carries every profile section (intentions, languages,
/// verification flags, …), so there is no per-card `GET /profiles/{userId}`
/// any more (it was 1 + N requests per deck; the lazy-loading stop-gap that
/// followed is gone too).
class MarriageCardsRepositoryImpl implements MarriageRepository {
  /// [_imageBaseUrl]: server root that `/public/upload/...` paths hang off.
  MarriageCardsRepositoryImpl(
    this._remote,
    this._guard,
    this._imageBaseUrl,
  );

  final MarriageCardsRemoteDataSource _remote;
  final Guard _guard;
  final String _imageBaseUrl;

  static const deckSize = 20;

  @override
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  }) => _guard(() async {
    final data = (await _remote.fetchCards(
      filtersToQuery(filters, cursor: cursor),
    )).data;
    return (
      items: [
        for (final card in data.cards)
          card.toEntity(imageBaseUrl: _imageBaseUrl),
      ],
      // The last page has no cursor (or `hasMore: false`).
      nextCursor: data.hasMore ? data.nextCursor : null,
    );
  });

  @override
  Future<Either<Failure, SwipeOutcome>> swipe(
    SwipeAction action, {
    String? targetUserId,
    String? text,
  }) => _guard(() async {
    final res = await _remote.swipe(
      SwipeRequestDto(
        action: action.name,
        targetUserId: targetUserId,
        text: text,
      ).toJson(),
    );
    final d = res.data;
    return SwipeOutcome(
      isMatch: d?.isMatch ?? false,
      matchedName: d?.matchedUser?.fullName,
      matchedPhotoUrl: switch (d?.matchedUser?.photoUrl) {
        final String url when url.isNotEmpty => resolveImageUrl(
          _imageBaseUrl,
          url,
        ),
        _ => null,
      },
      conversationId: d?.conversationId,
      rewoundUserId: d?.rewoundUserId,
    );
  });

  @override
  Future<Either<Failure, Unit>> favourite(String userId) => _guard(() async {
    await _remote.addFavourite(userId);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> block(String userId) => _guard(() async {
    await _remote.block(userId);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> report(
    String userId, {
    required String reason,
    String? description,
  }) => _guard(() async {
    await _remote.report({
      'reportedUserId': userId,
      'reason': reason,
      'description': ?description,
    });
    return unit;
  });

  /// `limit`, `cursor`, `minAge`/`maxAge`, `country` (a country *name*) and
  /// `maxDistanceMiles` (the server converts it). The ethnicity filter is
  /// not sent yet: the backend example uses names like "Bengali" while the
  /// app stores country codes — waiting on the real value set.
  static Map<String, dynamic> filtersToQuery(
    DiscoveryFilters f, {
    String? cursor,
  }) {
    final countryCode = switch (f.locationMode) {
      LocationFilterMode.country => f.countryCode,
      LocationFilterMode.distance when f.limitToHomeCountry => kHomeCountryCode,
      _ => null,
    };
    return {
      'limit': deckSize,
      'cursor': ?cursor,
      if (f.locationMode == LocationFilterMode.distance && !f.isEverywhere)
        'maxDistanceMiles': f.distanceMiles.round(),
      if (!f.isAnyAge) ...{'minAge': f.minAge, 'maxAge': f.maxAge},
      if (countryCode != null) 'country': _countryName(countryCode),
    };
  }

  static String _countryName(String code) => allCountries
      .firstWhere(
        (c) => c.code == code,
        orElse: () => Country(code, code, ''),
      )
      .name;
}
