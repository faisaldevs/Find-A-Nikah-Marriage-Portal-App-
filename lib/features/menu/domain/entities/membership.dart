import 'package:equatable/equatable.dart';

/// Plan + balances shown on the Membership tab.
class Membership extends Equatable {
  const Membership({
    required this.planName,
    required this.planDescription,
    required this.likes,
    required this.compliments,
    required this.likesInFilters,
    required this.monthlyPrice,
  });

  final String planName;
  final String planDescription;
  final int likes;
  final int compliments;
  final int likesInFilters;
  final String monthlyPrice;

  Membership copyWith({
    String? planName,
    String? planDescription,
    int? likes,
    int? compliments,
    int? likesInFilters,
    String? monthlyPrice,
  }) {
    return Membership(
      planName: planName ?? this.planName,
      planDescription: planDescription ?? this.planDescription,
      likes: likes ?? this.likes,
      compliments: compliments ?? this.compliments,
      likesInFilters: likesInFilters ?? this.likesInFilters,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    );
  }

  @override
  List<Object?> get props => [
    planName,
    planDescription,
    likes,
    compliments,
    likesInFilters,
    monthlyPrice,
  ];
}
