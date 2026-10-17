import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';

/// Plan + balances shown on the Membership tab.
@freezed
abstract class Membership with _$Membership {
  const factory Membership({
    required String planName,
    required String planDescription,
    required int likes,
    required int compliments,
    required int likesInFilters,
    required String monthlyPrice,
  }) = _Membership;
}
