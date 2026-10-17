// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExploreState {

 ExploreStatus get status; ExploreFeed get feed; Failure? get failure; ExploreStatus get historyStatus; ExploreHistoryFeed get history; Failure? get historyFailure;
/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreStateCopyWith<ExploreState> get copyWith => _$ExploreStateCopyWithImpl<ExploreState>(this as ExploreState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreState&&(identical(other.status, status) || other.status == status)&&(identical(other.feed, feed) || other.feed == feed)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.historyStatus, historyStatus) || other.historyStatus == historyStatus)&&(identical(other.history, history) || other.history == history)&&(identical(other.historyFailure, historyFailure) || other.historyFailure == historyFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,feed,failure,historyStatus,history,historyFailure);

@override
String toString() {
  return 'ExploreState(status: $status, feed: $feed, failure: $failure, historyStatus: $historyStatus, history: $history, historyFailure: $historyFailure)';
}


}

/// @nodoc
abstract mixin class $ExploreStateCopyWith<$Res>  {
  factory $ExploreStateCopyWith(ExploreState value, $Res Function(ExploreState) _then) = _$ExploreStateCopyWithImpl;
@useResult
$Res call({
 ExploreStatus status, ExploreFeed feed, Failure? failure, ExploreStatus historyStatus, ExploreHistoryFeed history, Failure? historyFailure
});


$ExploreFeedCopyWith<$Res> get feed;$ExploreHistoryFeedCopyWith<$Res> get history;

}
/// @nodoc
class _$ExploreStateCopyWithImpl<$Res>
    implements $ExploreStateCopyWith<$Res> {
  _$ExploreStateCopyWithImpl(this._self, this._then);

  final ExploreState _self;
  final $Res Function(ExploreState) _then;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? feed = null,Object? failure = freezed,Object? historyStatus = null,Object? history = null,Object? historyFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExploreStatus,feed: null == feed ? _self.feed : feed // ignore: cast_nullable_to_non_nullable
as ExploreFeed,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,historyStatus: null == historyStatus ? _self.historyStatus : historyStatus // ignore: cast_nullable_to_non_nullable
as ExploreStatus,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as ExploreHistoryFeed,historyFailure: freezed == historyFailure ? _self.historyFailure : historyFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreFeedCopyWith<$Res> get feed {
  
  return $ExploreFeedCopyWith<$Res>(_self.feed, (value) {
    return _then(_self.copyWith(feed: value));
  });
}/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreHistoryFeedCopyWith<$Res> get history {
  
  return $ExploreHistoryFeedCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExploreState].
extension ExploreStatePatterns on ExploreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreState value)  $default,){
final _that = this;
switch (_that) {
case _ExploreState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreState value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExploreStatus status,  ExploreFeed feed,  Failure? failure,  ExploreStatus historyStatus,  ExploreHistoryFeed history,  Failure? historyFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreState() when $default != null:
return $default(_that.status,_that.feed,_that.failure,_that.historyStatus,_that.history,_that.historyFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExploreStatus status,  ExploreFeed feed,  Failure? failure,  ExploreStatus historyStatus,  ExploreHistoryFeed history,  Failure? historyFailure)  $default,) {final _that = this;
switch (_that) {
case _ExploreState():
return $default(_that.status,_that.feed,_that.failure,_that.historyStatus,_that.history,_that.historyFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExploreStatus status,  ExploreFeed feed,  Failure? failure,  ExploreStatus historyStatus,  ExploreHistoryFeed history,  Failure? historyFailure)?  $default,) {final _that = this;
switch (_that) {
case _ExploreState() when $default != null:
return $default(_that.status,_that.feed,_that.failure,_that.historyStatus,_that.history,_that.historyFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ExploreState implements ExploreState {
  const _ExploreState({this.status = ExploreStatus.initial, this.feed = const ExploreFeed(), this.failure, this.historyStatus = ExploreStatus.initial, this.history = const ExploreHistoryFeed(), this.historyFailure});
  

@override@JsonKey() final  ExploreStatus status;
@override@JsonKey() final  ExploreFeed feed;
@override final  Failure? failure;
@override@JsonKey() final  ExploreStatus historyStatus;
@override@JsonKey() final  ExploreHistoryFeed history;
@override final  Failure? historyFailure;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreStateCopyWith<_ExploreState> get copyWith => __$ExploreStateCopyWithImpl<_ExploreState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreState&&(identical(other.status, status) || other.status == status)&&(identical(other.feed, feed) || other.feed == feed)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.historyStatus, historyStatus) || other.historyStatus == historyStatus)&&(identical(other.history, history) || other.history == history)&&(identical(other.historyFailure, historyFailure) || other.historyFailure == historyFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,feed,failure,historyStatus,history,historyFailure);

@override
String toString() {
  return 'ExploreState(status: $status, feed: $feed, failure: $failure, historyStatus: $historyStatus, history: $history, historyFailure: $historyFailure)';
}


}

/// @nodoc
abstract mixin class _$ExploreStateCopyWith<$Res> implements $ExploreStateCopyWith<$Res> {
  factory _$ExploreStateCopyWith(_ExploreState value, $Res Function(_ExploreState) _then) = __$ExploreStateCopyWithImpl;
@override @useResult
$Res call({
 ExploreStatus status, ExploreFeed feed, Failure? failure, ExploreStatus historyStatus, ExploreHistoryFeed history, Failure? historyFailure
});


@override $ExploreFeedCopyWith<$Res> get feed;@override $ExploreHistoryFeedCopyWith<$Res> get history;

}
/// @nodoc
class __$ExploreStateCopyWithImpl<$Res>
    implements _$ExploreStateCopyWith<$Res> {
  __$ExploreStateCopyWithImpl(this._self, this._then);

  final _ExploreState _self;
  final $Res Function(_ExploreState) _then;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? feed = null,Object? failure = freezed,Object? historyStatus = null,Object? history = null,Object? historyFailure = freezed,}) {
  return _then(_ExploreState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExploreStatus,feed: null == feed ? _self.feed : feed // ignore: cast_nullable_to_non_nullable
as ExploreFeed,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,historyStatus: null == historyStatus ? _self.historyStatus : historyStatus // ignore: cast_nullable_to_non_nullable
as ExploreStatus,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as ExploreHistoryFeed,historyFailure: freezed == historyFailure ? _self.historyFailure : historyFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreFeedCopyWith<$Res> get feed {
  
  return $ExploreFeedCopyWith<$Res>(_self.feed, (value) {
    return _then(_self.copyWith(feed: value));
  });
}/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreHistoryFeedCopyWith<$Res> get history {
  
  return $ExploreHistoryFeedCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}
}

// dart format on
