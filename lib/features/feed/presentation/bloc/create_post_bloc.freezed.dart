// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreatePostState {

 CreatePostStatus get status; FeedAuthor? get me; List<FeedTopic> get topics; FeedTopic? get topic; String get text; bool get anonymous; FeedPost? get published; Failure? get failure;
/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePostStateCopyWith<CreatePostState> get copyWith => _$CreatePostStateCopyWithImpl<CreatePostState>(this as CreatePostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePostState&&(identical(other.status, status) || other.status == status)&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other.topics, topics)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.text, text) || other.text == text)&&(identical(other.anonymous, anonymous) || other.anonymous == anonymous)&&(identical(other.published, published) || other.published == published)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,me,const DeepCollectionEquality().hash(topics),topic,text,anonymous,published,failure);

@override
String toString() {
  return 'CreatePostState(status: $status, me: $me, topics: $topics, topic: $topic, text: $text, anonymous: $anonymous, published: $published, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CreatePostStateCopyWith<$Res>  {
  factory $CreatePostStateCopyWith(CreatePostState value, $Res Function(CreatePostState) _then) = _$CreatePostStateCopyWithImpl;
@useResult
$Res call({
 CreatePostStatus status, FeedAuthor? me, List<FeedTopic> topics, FeedTopic? topic, String text, bool anonymous, FeedPost? published, Failure? failure
});


$FeedAuthorCopyWith<$Res>? get me;$FeedTopicCopyWith<$Res>? get topic;$FeedPostCopyWith<$Res>? get published;

}
/// @nodoc
class _$CreatePostStateCopyWithImpl<$Res>
    implements $CreatePostStateCopyWith<$Res> {
  _$CreatePostStateCopyWithImpl(this._self, this._then);

  final CreatePostState _self;
  final $Res Function(CreatePostState) _then;

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? me = freezed,Object? topics = null,Object? topic = freezed,Object? text = null,Object? anonymous = null,Object? published = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreatePostStatus,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as FeedAuthor?,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<FeedTopic>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as FeedTopic?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,anonymous: null == anonymous ? _self.anonymous : anonymous // ignore: cast_nullable_to_non_nullable
as bool,published: freezed == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as FeedPost?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res>? get me {
    if (_self.me == null) {
    return null;
  }

  return $FeedAuthorCopyWith<$Res>(_self.me!, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $FeedTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedPostCopyWith<$Res>? get published {
    if (_self.published == null) {
    return null;
  }

  return $FeedPostCopyWith<$Res>(_self.published!, (value) {
    return _then(_self.copyWith(published: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePostState].
extension CreatePostStatePatterns on CreatePostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePostState value)  $default,){
final _that = this;
switch (_that) {
case _CreatePostState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePostState value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CreatePostStatus status,  FeedAuthor? me,  List<FeedTopic> topics,  FeedTopic? topic,  String text,  bool anonymous,  FeedPost? published,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
return $default(_that.status,_that.me,_that.topics,_that.topic,_that.text,_that.anonymous,_that.published,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CreatePostStatus status,  FeedAuthor? me,  List<FeedTopic> topics,  FeedTopic? topic,  String text,  bool anonymous,  FeedPost? published,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _CreatePostState():
return $default(_that.status,_that.me,_that.topics,_that.topic,_that.text,_that.anonymous,_that.published,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CreatePostStatus status,  FeedAuthor? me,  List<FeedTopic> topics,  FeedTopic? topic,  String text,  bool anonymous,  FeedPost? published,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
return $default(_that.status,_that.me,_that.topics,_that.topic,_that.text,_that.anonymous,_that.published,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _CreatePostState extends CreatePostState {
  const _CreatePostState({this.status = CreatePostStatus.editing, this.me, final  List<FeedTopic> topics = const <FeedTopic>[], this.topic, this.text = '', this.anonymous = false, this.published, this.failure}): _topics = topics,super._();
  

@override@JsonKey() final  CreatePostStatus status;
@override final  FeedAuthor? me;
 final  List<FeedTopic> _topics;
@override@JsonKey() List<FeedTopic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

@override final  FeedTopic? topic;
@override@JsonKey() final  String text;
@override@JsonKey() final  bool anonymous;
@override final  FeedPost? published;
@override final  Failure? failure;

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePostStateCopyWith<_CreatePostState> get copyWith => __$CreatePostStateCopyWithImpl<_CreatePostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePostState&&(identical(other.status, status) || other.status == status)&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other._topics, _topics)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.text, text) || other.text == text)&&(identical(other.anonymous, anonymous) || other.anonymous == anonymous)&&(identical(other.published, published) || other.published == published)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,me,const DeepCollectionEquality().hash(_topics),topic,text,anonymous,published,failure);

@override
String toString() {
  return 'CreatePostState(status: $status, me: $me, topics: $topics, topic: $topic, text: $text, anonymous: $anonymous, published: $published, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$CreatePostStateCopyWith<$Res> implements $CreatePostStateCopyWith<$Res> {
  factory _$CreatePostStateCopyWith(_CreatePostState value, $Res Function(_CreatePostState) _then) = __$CreatePostStateCopyWithImpl;
@override @useResult
$Res call({
 CreatePostStatus status, FeedAuthor? me, List<FeedTopic> topics, FeedTopic? topic, String text, bool anonymous, FeedPost? published, Failure? failure
});


@override $FeedAuthorCopyWith<$Res>? get me;@override $FeedTopicCopyWith<$Res>? get topic;@override $FeedPostCopyWith<$Res>? get published;

}
/// @nodoc
class __$CreatePostStateCopyWithImpl<$Res>
    implements _$CreatePostStateCopyWith<$Res> {
  __$CreatePostStateCopyWithImpl(this._self, this._then);

  final _CreatePostState _self;
  final $Res Function(_CreatePostState) _then;

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? me = freezed,Object? topics = null,Object? topic = freezed,Object? text = null,Object? anonymous = null,Object? published = freezed,Object? failure = freezed,}) {
  return _then(_CreatePostState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreatePostStatus,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as FeedAuthor?,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<FeedTopic>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as FeedTopic?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,anonymous: null == anonymous ? _self.anonymous : anonymous // ignore: cast_nullable_to_non_nullable
as bool,published: freezed == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as FeedPost?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res>? get me {
    if (_self.me == null) {
    return null;
  }

  return $FeedAuthorCopyWith<$Res>(_self.me!, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $FeedTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedPostCopyWith<$Res>? get published {
    if (_self.published == null) {
    return null;
  }

  return $FeedPostCopyWith<$Res>(_self.published!, (value) {
    return _then(_self.copyWith(published: value));
  });
}
}

// dart format on
