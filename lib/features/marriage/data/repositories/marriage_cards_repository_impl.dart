import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/data/datasources/marriage_cards_remote_data_source.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_dto.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_mapper.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';

/// Marriage feed on the real API: one `GET /v1/profiles/cards`, then each
/// card's full profile (`GET /v1/profiles/{userId}`, in parallel) for the
/// sections the card leaves out. A failed detail call keeps the card with
/// what it has rather than dropping it.
class MarriageCardsRepositoryImpl implements MarriageRepository {
  /// [_imageBaseUrl]: server root that `/public/upload/...` paths hang off.
  const MarriageCardsRepositoryImpl(
    this._remote,
    this._guard,
    this._imageBaseUrl,
  );

  final MarriageCardsRemoteDataSource _remote;
  final Guard _guard;
  final String _imageBaseUrl;

  /// The API has no paging parameter (page/offset/skip are ignored), so the
  /// whole deck is fetched in one go and `nextCursor` is
  /// always null — the bloc then loops at the end.
  // TODO(api): page properly once the backend supports it (or once swipes
  // remove seen cards from the deck, refetch on `hasMore`).
  static const deckSize = 20;

  @override
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  }) => _guard(() async {
    final cards = (await _remote.fetchCards(filtersToQuery(filters))).data;
    final details = await Future.wait<ProfileDetailDto?>(
      cards.cards.map(_detailOrNull),
    );
    return (
      items: [
        for (final (i, card) in cards.cards.indexed)
          card.toEntity(imageBaseUrl: _imageBaseUrl, detail: details[i]),
      ],
      nextCursor: null,
    );
  });

  @override
  Future<Either<Failure, SwipeOutcome>> swipe(
    SwipeAction action, {
    String? targetUserId,
  }) => _guard(() async {
    final res = await _remote.swipe(
      SwipeRequestDto(action: action.name, targetUserId: targetUserId).toJson(),
    );
    return (isMatch: res.data?.isMatch ?? false);
  });

  Future<ProfileDetailDto?> _detailOrNull(ProfileCardDto card) async {
    try {
      return (await _remote.fetchProfile(card.userId)).data.profile;
    } on Object {
      return null;
    }
  }

  /// Confirmed against the API: `limit`, `minAge`/`maxAge`, and `country`
  /// as a country *name*. Distance and ethnicity filters aren't applied
  /// server-side yet (no location stored; `ethnicity` param unconfirmed),
  /// so they're not sent.
  static Map<String, dynamic> filtersToQuery(DiscoveryFilters f) {
    final countryCode = switch (f.locationMode) {
      LocationFilterMode.country => f.countryCode,
      LocationFilterMode.distance when f.limitToHomeCountry => kHomeCountryCode,
      _ => null,
    };
    return {
      'limit': deckSize,
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
