// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_history_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExploreHistoryFeed {

 List<ExploreProfile> get liked; List<ExploreProfile> get favourited; List<ExploreProfile> get passed; List<ExploreProfile> get complimented;
/// Create a copy of ExploreHistoryFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreHistoryFeedCopyWith<ExploreHistoryFeed> get copyWith => _$ExploreHistoryFeedCopyWithImpl<ExploreHistoryFeed>(this as ExploreHistoryFeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreHistoryFeed&&const DeepCollectionEquality().equals(other.liked, liked)&&const DeepCollectionEquality().equals(other.favourited, favourited)&&const DeepCollectionEquality().equals(other.passed, passed)&&const DeepCollectionEquality().equals(other.complimented, complimented));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(liked),const DeepCollectionEquality().hash(favourited),const DeepCollectionEquality().hash(passed),const DeepCollectionEquality().hash(complimented));

@override
String toString() {
  return 'ExploreHistoryFeed(liked: $liked, favourited: $favourited, passed: $passed, complimented: $complimented)';
}


}

/// @nodoc
abstract mixin class $ExploreHistoryFeedCopyWith<$Res>  {
  factory $ExploreHistoryFeedCopyWith(ExploreHistoryFeed value, $Res Function(ExploreHistoryFeed) _then) = _$ExploreHistoryFeedCopyWithImpl;
@useResult
$Res call({
 List<ExploreProfile> liked, List<ExploreProfile> favourited, List<ExploreProfile> passed, List<ExploreProfile> complimented
});




}
/// @nodoc
class _$ExploreHistoryFeedCopyWithImpl<$Res>
    implements $ExploreHistoryFeedCopyWith<$Res> {
  _$ExploreHistoryFeedCopyWithImpl(this._self, this._then);

  final ExploreHistoryFeed _self;
  final $Res Function(ExploreHistoryFeed) _then;

/// Create a copy of ExploreHistoryFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? liked = null,Object? favourited = null,Object? passed = null,Object? complimented = null,}) {
  return _then(_self.copyWith(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,favourited: null == favourited ? _self.favourited : favourited // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,complimented: null == complimented ? _self.complimented : complimented // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExploreHistoryFeed].
extension ExploreHistoryFeedPatterns on ExploreHistoryFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreHistoryFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreHistoryFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreHistoryFeed value)  $default,){
final _that = this;
switch (_that) {
case _ExploreHistoryFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreHistoryFeed value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreHistoryFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ExploreProfile> liked,  List<ExploreProfile> favourited,  List<ExploreProfile> passed,  List<ExploreProfile> complimented)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreHistoryFeed() when $default != null:
return $default(_that.liked,_that.favourited,_that.passed,_that.complimented);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ExploreProfile> liked,  List<ExploreProfile> favourited,  List<ExploreProfile> passed,  List<ExploreProfile> complimented)  $default,) {final _that = this;
switch (_that) {
case _ExploreHistoryFeed():
return $default(_that.liked,_that.favourited,_that.passed,_that.complimented);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ExploreProfile> liked,  List<ExploreProfile> favourited,  List<ExploreProfile> passed,  List<ExploreProfile> complimented)?  $default,) {final _that = this;
switch (_that) {
case _ExploreHistoryFeed() when $default != null:
return $default(_that.liked,_that.favourited,_that.passed,_that.complimented);case _:
  return null;

}
}

}

/// @nodoc


class _ExploreHistoryFeed implements ExploreHistoryFeed {
  const _ExploreHistoryFeed({final  List<ExploreProfile> liked = const <ExploreProfile>[], final  List<ExploreProfile> favourited = const <ExploreProfile>[], final  List<ExploreProfile> passed = const <ExploreProfile>[], final  List<ExploreProfile> complimented = const <ExploreProfile>[]}): _liked = liked,_favourited = favourited,_passed = passed,_complimented = complimented;
  

 final  List<ExploreProfile> _liked;
@override@JsonKey() List<ExploreProfile> get liked {
  if (_liked is EqualUnmodifiableListView) return _liked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_liked);
}

 final  List<ExploreProfile> _favourited;
@override@JsonKey() List<ExploreProfile> get favourited {
  if (_favourited is EqualUnmodifiableListView) return _favourited;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favourited);
}

 final  List<ExploreProfile> _passed;
@override@JsonKey() List<ExploreProfile> get passed {
  if (_passed is EqualUnmodifiableListView) return _passed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_passed);
}

 final  List<ExploreProfile> _complimented;
@override@JsonKey() List<ExploreProfile> get complimented {
  if (_complimented is EqualUnmodifiableListView) return _complimented;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_complimented);
}


/// Create a copy of ExploreHistoryFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreHistoryFeedCopyWith<_ExploreHistoryFeed> get copyWith => __$ExploreHistoryFeedCopyWithImpl<_ExploreHistoryFeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreHistoryFeed&&const DeepCollectionEquality().equals(other._liked, _liked)&&const DeepCollectionEquality().equals(other._favourited, _favourited)&&const DeepCollectionEquality().equals(other._passed, _passed)&&const DeepCollectionEquality().equals(other._complimented, _complimented));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_liked),const DeepCollectionEquality().hash(_favourited),const DeepCollectionEquality().hash(_passed),const DeepCollectionEquality().hash(_complimented));

@override
String toString() {
  return 'ExploreHistoryFeed(liked: $liked, favourited: $favourited, passed: $passed, complimented: $complimented)';
}


}

/// @nodoc
abstract mixin class _$ExploreHistoryFeedCopyWith<$Res> implements $ExploreHistoryFeedCopyWith<$Res> {
  factory _$ExploreHistoryFeedCopyWith(_ExploreHistoryFeed value, $Res Function(_ExploreHistoryFeed) _then) = __$ExploreHistoryFeedCopyWithImpl;
@override @useResult
$Res call({
 List<ExploreProfile> liked, List<ExploreProfile> favourited, List<ExploreProfile> passed, List<ExploreProfile> complimented
});




}
/// @nodoc
class __$ExploreHistoryFeedCopyWithImpl<$Res>
    implements _$ExploreHistoryFeedCopyWith<$Res> {
  __$ExploreHistoryFeedCopyWithImpl(this._self, this._then);

  final _ExploreHistoryFeed _self;
  final $Res Function(_ExploreHistoryFeed) _then;

/// Create a copy of ExploreHistoryFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? liked = null,Object? favourited = null,Object? passed = null,Object? complimented = null,}) {
  return _then(_ExploreHistoryFeed(
liked: null == liked ? _self._liked : liked // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,favourited: null == favourited ? _self._favourited : favourited // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,passed: null == passed ? _self._passed : passed // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,complimented: null == complimented ? _self._complimented : complimented // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,
  ));
}


}

// dart format on
