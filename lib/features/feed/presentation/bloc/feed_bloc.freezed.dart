// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {

 FeedStatus get status; FeedFilter get filter; List<FeedTopic> get topics; List<FeedPost> get posts; String get query; Failure? get failure;
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStateCopyWith<FeedState> get copyWith => _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState&&(identical(other.status, status) || other.status == status)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.topics, topics)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.query, query) || other.query == query)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,filter,const DeepCollectionEquality().hash(topics),const DeepCollectionEquality().hash(posts),query,failure);

@override
String toString() {
  return 'FeedState(status: $status, filter: $filter, topics: $topics, posts: $posts, query: $query, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res>  {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) = _$FeedStateCopyWithImpl;
@useResult
$Res call({
 FeedStatus status, FeedFilter filter, List<FeedTopic> topics, List<FeedPost> posts, String query, Failure? failure
});


$FeedFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$FeedStateCopyWithImpl<$Res>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? filter = null,Object? topics = null,Object? posts = null,Object? query = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FeedFilter,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<FeedTopic>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<FeedPost>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedFilterCopyWith<$Res> get filter {
  
  return $FeedFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedState value)  $default,){
final _that = this;
switch (_that) {
case _FeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeedStatus status,  FeedFilter filter,  List<FeedTopic> topics,  List<FeedPost> posts,  String query,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.status,_that.filter,_that.topics,_that.posts,_that.query,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeedStatus status,  FeedFilter filter,  List<FeedTopic> topics,  List<FeedPost> posts,  String query,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FeedState():
return $default(_that.status,_that.filter,_that.topics,_that.posts,_that.query,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeedStatus status,  FeedFilter filter,  List<FeedTopic> topics,  List<FeedPost> posts,  String query,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.status,_that.filter,_that.topics,_that.posts,_that.query,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FeedState extends FeedState {
  const _FeedState({this.status = FeedStatus.initial, this.filter = const FeedFilter.forYou(), final  List<FeedTopic> topics = const <FeedTopic>[], final  List<FeedPost> posts = const <FeedPost>[], this.query = '', this.failure}): _topics = topics,_posts = posts,super._();
  

@override@JsonKey() final  FeedStatus status;
@override@JsonKey() final  FeedFilter filter;
 final  List<FeedTopic> _topics;
@override@JsonKey() List<FeedTopic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

 final  List<FeedPost> _posts;
@override@JsonKey() List<FeedPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  String query;
@override final  Failure? failure;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStateCopyWith<_FeedState> get copyWith => __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedState&&(identical(other.status, status) || other.status == status)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other._topics, _topics)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.query, query) || other.query == query)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,filter,const DeepCollectionEquality().hash(_topics),const DeepCollectionEquality().hash(_posts),query,failure);

@override
String toString() {
  return 'FeedState(status: $status, filter: $filter, topics: $topics, posts: $posts, query: $query, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(_FeedState value, $Res Function(_FeedState) _then) = __$FeedStateCopyWithImpl;
@override @useResult
$Res call({
 FeedStatus status, FeedFilter filter, List<FeedTopic> topics, List<FeedPost> posts, String query, Failure? failure
});


@override $FeedFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$FeedStateCopyWithImpl<$Res>
    implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? filter = null,Object? topics = null,Object? posts = null,Object? query = null,Object? failure = freezed,}) {
  return _then(_FeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FeedFilter,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<FeedTopic>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<FeedPost>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedFilterCopyWith<$Res> get filter {
  
  return $FeedFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
