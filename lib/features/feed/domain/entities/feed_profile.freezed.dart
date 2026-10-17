// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedProfile {

 FeedAuthor get author; String get countryName;/// Display-ready ("Oct 2026").
 String get joined; int get followers; int get following;
/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedProfileCopyWith<FeedProfile> get copyWith => _$FeedProfileCopyWithImpl<FeedProfile>(this as FeedProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedProfile&&(identical(other.author, author) || other.author == author)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.joined, joined) || other.joined == joined)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.following, following) || other.following == following));
}


@override
int get hashCode => Object.hash(runtimeType,author,countryName,joined,followers,following);

@override
String toString() {
  return 'FeedProfile(author: $author, countryName: $countryName, joined: $joined, followers: $followers, following: $following)';
}


}

/// @nodoc
abstract mixin class $FeedProfileCopyWith<$Res>  {
  factory $FeedProfileCopyWith(FeedProfile value, $Res Function(FeedProfile) _then) = _$FeedProfileCopyWithImpl;
@useResult
$Res call({
 FeedAuthor author, String countryName, String joined, int followers, int following
});


$FeedAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$FeedProfileCopyWithImpl<$Res>
    implements $FeedProfileCopyWith<$Res> {
  _$FeedProfileCopyWithImpl(this._self, this._then);

  final FeedProfile _self;
  final $Res Function(FeedProfile) _then;

/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? author = null,Object? countryName = null,Object? joined = null,Object? followers = null,Object? following = null,}) {
  return _then(_self.copyWith(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,joined: null == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as String,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res> get author {
  
  return $FeedAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedProfile].
extension FeedProfilePatterns on FeedProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedProfile value)  $default,){
final _that = this;
switch (_that) {
case _FeedProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedProfile value)?  $default,){
final _that = this;
switch (_that) {
case _FeedProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeedAuthor author,  String countryName,  String joined,  int followers,  int following)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedProfile() when $default != null:
return $default(_that.author,_that.countryName,_that.joined,_that.followers,_that.following);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeedAuthor author,  String countryName,  String joined,  int followers,  int following)  $default,) {final _that = this;
switch (_that) {
case _FeedProfile():
return $default(_that.author,_that.countryName,_that.joined,_that.followers,_that.following);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeedAuthor author,  String countryName,  String joined,  int followers,  int following)?  $default,) {final _that = this;
switch (_that) {
case _FeedProfile() when $default != null:
return $default(_that.author,_that.countryName,_that.joined,_that.followers,_that.following);case _:
  return null;

}
}

}

/// @nodoc


class _FeedProfile implements FeedProfile {
  const _FeedProfile({required this.author, required this.countryName, required this.joined, this.followers = 0, this.following = 0});
  

@override final  FeedAuthor author;
@override final  String countryName;
/// Display-ready ("Oct 2026").
@override final  String joined;
@override@JsonKey() final  int followers;
@override@JsonKey() final  int following;

/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedProfileCopyWith<_FeedProfile> get copyWith => __$FeedProfileCopyWithImpl<_FeedProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedProfile&&(identical(other.author, author) || other.author == author)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.joined, joined) || other.joined == joined)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.following, following) || other.following == following));
}


@override
int get hashCode => Object.hash(runtimeType,author,countryName,joined,followers,following);

@override
String toString() {
  return 'FeedProfile(author: $author, countryName: $countryName, joined: $joined, followers: $followers, following: $following)';
}


}

/// @nodoc
abstract mixin class _$FeedProfileCopyWith<$Res> implements $FeedProfileCopyWith<$Res> {
  factory _$FeedProfileCopyWith(_FeedProfile value, $Res Function(_FeedProfile) _then) = __$FeedProfileCopyWithImpl;
@override @useResult
$Res call({
 FeedAuthor author, String countryName, String joined, int followers, int following
});


@override $FeedAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$FeedProfileCopyWithImpl<$Res>
    implements _$FeedProfileCopyWith<$Res> {
  __$FeedProfileCopyWithImpl(this._self, this._then);

  final _FeedProfile _self;
  final $Res Function(_FeedProfile) _then;

/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? author = null,Object? countryName = null,Object? joined = null,Object? followers = null,Object? following = null,}) {
  return _then(_FeedProfile(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,joined: null == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as String,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of FeedProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res> get author {
  
  return $FeedAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
