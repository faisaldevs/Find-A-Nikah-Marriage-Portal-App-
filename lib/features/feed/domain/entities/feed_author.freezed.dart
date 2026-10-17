// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedAuthor {

 String get name;/// Without the leading "@". Doubles as the author's id.
 String get handle; String get photoUrl;/// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
/// photo. Null or unknown codes show no badge.
 String? get countryCode;
/// Create a copy of FeedAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<FeedAuthor> get copyWith => _$FeedAuthorCopyWithImpl<FeedAuthor>(this as FeedAuthor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}


@override
int get hashCode => Object.hash(runtimeType,name,handle,photoUrl,countryCode);

@override
String toString() {
  return 'FeedAuthor(name: $name, handle: $handle, photoUrl: $photoUrl, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $FeedAuthorCopyWith<$Res>  {
  factory $FeedAuthorCopyWith(FeedAuthor value, $Res Function(FeedAuthor) _then) = _$FeedAuthorCopyWithImpl;
@useResult
$Res call({
 String name, String handle, String photoUrl, String? countryCode
});




}
/// @nodoc
class _$FeedAuthorCopyWithImpl<$Res>
    implements $FeedAuthorCopyWith<$Res> {
  _$FeedAuthorCopyWithImpl(this._self, this._then);

  final FeedAuthor _self;
  final $Res Function(FeedAuthor) _then;

/// Create a copy of FeedAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? handle = null,Object? photoUrl = null,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedAuthor].
extension FeedAuthorPatterns on FeedAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedAuthor value)  $default,){
final _that = this;
switch (_that) {
case _FeedAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _FeedAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String handle,  String photoUrl,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedAuthor() when $default != null:
return $default(_that.name,_that.handle,_that.photoUrl,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String handle,  String photoUrl,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _FeedAuthor():
return $default(_that.name,_that.handle,_that.photoUrl,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String handle,  String photoUrl,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _FeedAuthor() when $default != null:
return $default(_that.name,_that.handle,_that.photoUrl,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc


class _FeedAuthor implements FeedAuthor {
  const _FeedAuthor({required this.name, required this.handle, required this.photoUrl, this.countryCode});
  

@override final  String name;
/// Without the leading "@". Doubles as the author's id.
@override final  String handle;
@override final  String photoUrl;
/// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
/// photo. Null or unknown codes show no badge.
@override final  String? countryCode;

/// Create a copy of FeedAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedAuthorCopyWith<_FeedAuthor> get copyWith => __$FeedAuthorCopyWithImpl<_FeedAuthor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}


@override
int get hashCode => Object.hash(runtimeType,name,handle,photoUrl,countryCode);

@override
String toString() {
  return 'FeedAuthor(name: $name, handle: $handle, photoUrl: $photoUrl, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$FeedAuthorCopyWith<$Res> implements $FeedAuthorCopyWith<$Res> {
  factory _$FeedAuthorCopyWith(_FeedAuthor value, $Res Function(_FeedAuthor) _then) = __$FeedAuthorCopyWithImpl;
@override @useResult
$Res call({
 String name, String handle, String photoUrl, String? countryCode
});




}
/// @nodoc
class __$FeedAuthorCopyWithImpl<$Res>
    implements _$FeedAuthorCopyWith<$Res> {
  __$FeedAuthorCopyWithImpl(this._self, this._then);

  final _FeedAuthor _self;
  final $Res Function(_FeedAuthor) _then;

/// Create a copy of FeedAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? handle = null,Object? photoUrl = null,Object? countryCode = freezed,}) {
  return _then(_FeedAuthor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
