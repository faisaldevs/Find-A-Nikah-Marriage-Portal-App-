// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marriage_feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarriageFeedState {

 MarriageFeedStatus get status; List<MarriageProfile> get profiles; int get index; DiscoveryFilters get filters; String? get nextCursor; bool get loadingMore; Failure? get failure;/// userId → what was sent for it, so undo knows whether the profile
/// it would go back to was passed (undoable) or liked (not).
 Map<String, SwipeAction> get swiped; MarriageFeedNotice? get notice;/// With [MarriageFeedNotice.actionFailed].
 Failure? get actionFailure;/// Name of the profile behind [MarriageFeedNotice.matched].
 String? get matchedName;
/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarriageFeedStateCopyWith<MarriageFeedState> get copyWith => _$MarriageFeedStateCopyWithImpl<MarriageFeedState>(this as MarriageFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarriageFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.profiles, profiles)&&(identical(other.index, index) || other.index == index)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other.swiped, swiped)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure)&&(identical(other.matchedName, matchedName) || other.matchedName == matchedName));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(profiles),index,filters,nextCursor,loadingMore,failure,const DeepCollectionEquality().hash(swiped),notice,actionFailure,matchedName);

@override
String toString() {
  return 'MarriageFeedState(status: $status, profiles: $profiles, index: $index, filters: $filters, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure, swiped: $swiped, notice: $notice, actionFailure: $actionFailure, matchedName: $matchedName)';
}


}

/// @nodoc
abstract mixin class $MarriageFeedStateCopyWith<$Res>  {
  factory $MarriageFeedStateCopyWith(MarriageFeedState value, $Res Function(MarriageFeedState) _then) = _$MarriageFeedStateCopyWithImpl;
@useResult
$Res call({
 MarriageFeedStatus status, List<MarriageProfile> profiles, int index, DiscoveryFilters filters, String? nextCursor, bool loadingMore, Failure? failure, Map<String, SwipeAction> swiped, MarriageFeedNotice? notice, Failure? actionFailure, String? matchedName
});


$DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$MarriageFeedStateCopyWithImpl<$Res>
    implements $MarriageFeedStateCopyWith<$Res> {
  _$MarriageFeedStateCopyWithImpl(this._self, this._then);

  final MarriageFeedState _self;
  final $Res Function(MarriageFeedState) _then;

/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profiles = null,Object? index = null,Object? filters = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,Object? swiped = null,Object? notice = freezed,Object? actionFailure = freezed,Object? matchedName = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MarriageFeedStatus,profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<MarriageProfile>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,swiped: null == swiped ? _self.swiped : swiped // ignore: cast_nullable_to_non_nullable
as Map<String, SwipeAction>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MarriageFeedNotice?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,matchedName: freezed == matchedName ? _self.matchedName : matchedName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [MarriageFeedState].
extension MarriageFeedStatePatterns on MarriageFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarriageFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarriageFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarriageFeedState value)  $default,){
final _that = this;
switch (_that) {
case _MarriageFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarriageFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _MarriageFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MarriageFeedStatus status,  List<MarriageProfile> profiles,  int index,  DiscoveryFilters filters,  String? nextCursor,  bool loadingMore,  Failure? failure,  Map<String, SwipeAction> swiped,  MarriageFeedNotice? notice,  Failure? actionFailure,  String? matchedName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarriageFeedState() when $default != null:
return $default(_that.status,_that.profiles,_that.index,_that.filters,_that.nextCursor,_that.loadingMore,_that.failure,_that.swiped,_that.notice,_that.actionFailure,_that.matchedName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MarriageFeedStatus status,  List<MarriageProfile> profiles,  int index,  DiscoveryFilters filters,  String? nextCursor,  bool loadingMore,  Failure? failure,  Map<String, SwipeAction> swiped,  MarriageFeedNotice? notice,  Failure? actionFailure,  String? matchedName)  $default,) {final _that = this;
switch (_that) {
case _MarriageFeedState():
return $default(_that.status,_that.profiles,_that.index,_that.filters,_that.nextCursor,_that.loadingMore,_that.failure,_that.swiped,_that.notice,_that.actionFailure,_that.matchedName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MarriageFeedStatus status,  List<MarriageProfile> profiles,  int index,  DiscoveryFilters filters,  String? nextCursor,  bool loadingMore,  Failure? failure,  Map<String, SwipeAction> swiped,  MarriageFeedNotice? notice,  Failure? actionFailure,  String? matchedName)?  $default,) {final _that = this;
switch (_that) {
case _MarriageFeedState() when $default != null:
return $default(_that.status,_that.profiles,_that.index,_that.filters,_that.nextCursor,_that.loadingMore,_that.failure,_that.swiped,_that.notice,_that.actionFailure,_that.matchedName);case _:
  return null;

}
}

}

/// @nodoc


class _MarriageFeedState extends MarriageFeedState {
  const _MarriageFeedState({this.status = MarriageFeedStatus.initial, final  List<MarriageProfile> profiles = const <MarriageProfile>[], this.index = 0, this.filters = const DiscoveryFilters(), this.nextCursor, this.loadingMore = false, this.failure, final  Map<String, SwipeAction> swiped = const <String, SwipeAction>{}, this.notice, this.actionFailure, this.matchedName}): _profiles = profiles,_swiped = swiped,super._();
  

@override@JsonKey() final  MarriageFeedStatus status;
 final  List<MarriageProfile> _profiles;
@override@JsonKey() List<MarriageProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override@JsonKey() final  int index;
@override@JsonKey() final  DiscoveryFilters filters;
@override final  String? nextCursor;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;
/// userId → what was sent for it, so undo knows whether the profile
/// it would go back to was passed (undoable) or liked (not).
 final  Map<String, SwipeAction> _swiped;
/// userId → what was sent for it, so undo knows whether the profile
/// it would go back to was passed (undoable) or liked (not).
@override@JsonKey() Map<String, SwipeAction> get swiped {
  if (_swiped is EqualUnmodifiableMapView) return _swiped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_swiped);
}

@override final  MarriageFeedNotice? notice;
/// With [MarriageFeedNotice.actionFailed].
@override final  Failure? actionFailure;
/// Name of the profile behind [MarriageFeedNotice.matched].
@override final  String? matchedName;

/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarriageFeedStateCopyWith<_MarriageFeedState> get copyWith => __$MarriageFeedStateCopyWithImpl<_MarriageFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarriageFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._profiles, _profiles)&&(identical(other.index, index) || other.index == index)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other._swiped, _swiped)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure)&&(identical(other.matchedName, matchedName) || other.matchedName == matchedName));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_profiles),index,filters,nextCursor,loadingMore,failure,const DeepCollectionEquality().hash(_swiped),notice,actionFailure,matchedName);

@override
String toString() {
  return 'MarriageFeedState(status: $status, profiles: $profiles, index: $index, filters: $filters, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure, swiped: $swiped, notice: $notice, actionFailure: $actionFailure, matchedName: $matchedName)';
}


}

/// @nodoc
abstract mixin class _$MarriageFeedStateCopyWith<$Res> implements $MarriageFeedStateCopyWith<$Res> {
  factory _$MarriageFeedStateCopyWith(_MarriageFeedState value, $Res Function(_MarriageFeedState) _then) = __$MarriageFeedStateCopyWithImpl;
@override @useResult
$Res call({
 MarriageFeedStatus status, List<MarriageProfile> profiles, int index, DiscoveryFilters filters, String? nextCursor, bool loadingMore, Failure? failure, Map<String, SwipeAction> swiped, MarriageFeedNotice? notice, Failure? actionFailure, String? matchedName
});


@override $DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$MarriageFeedStateCopyWithImpl<$Res>
    implements _$MarriageFeedStateCopyWith<$Res> {
  __$MarriageFeedStateCopyWithImpl(this._self, this._then);

  final _MarriageFeedState _self;
  final $Res Function(_MarriageFeedState) _then;

/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profiles = null,Object? index = null,Object? filters = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,Object? swiped = null,Object? notice = freezed,Object? actionFailure = freezed,Object? matchedName = freezed,}) {
  return _then(_MarriageFeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MarriageFeedStatus,profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<MarriageProfile>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,swiped: null == swiped ? _self._swiped : swiped // ignore: cast_nullable_to_non_nullable
as Map<String, SwipeAction>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MarriageFeedNotice?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,matchedName: freezed == matchedName ? _self.matchedName : matchedName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MarriageFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
