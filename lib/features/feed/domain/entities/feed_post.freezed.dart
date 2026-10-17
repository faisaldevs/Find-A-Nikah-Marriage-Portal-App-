// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedPost {

 String get id; FeedAuthor get author;/// Name of the topic the post was filed under ("All things marriage").
 String get topic;/// Display-ready relative time ("9h ago", "2 days ago").
 String get postedAgo; String get body; int get likeCount; int get commentCount; int get viewCount;/// A comment previewed inside the card (profile "Posts" tab).
 FeedComment? get topComment;
/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedPostCopyWith<FeedPost> get copyWith => _$FeedPostCopyWithImpl<FeedPost>(this as FeedPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.postedAgo, postedAgo) || other.postedAgo == postedAgo)&&(identical(other.body, body) || other.body == body)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.topComment, topComment) || other.topComment == topComment));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,topic,postedAgo,body,likeCount,commentCount,viewCount,topComment);

@override
String toString() {
  return 'FeedPost(id: $id, author: $author, topic: $topic, postedAgo: $postedAgo, body: $body, likeCount: $likeCount, commentCount: $commentCount, viewCount: $viewCount, topComment: $topComment)';
}


}

/// @nodoc
abstract mixin class $FeedPostCopyWith<$Res>  {
  factory $FeedPostCopyWith(FeedPost value, $Res Function(FeedPost) _then) = _$FeedPostCopyWithImpl;
@useResult
$Res call({
 String id, FeedAuthor author, String topic, String postedAgo, String body, int likeCount, int commentCount, int viewCount, FeedComment? topComment
});


$FeedAuthorCopyWith<$Res> get author;$FeedCommentCopyWith<$Res>? get topComment;

}
/// @nodoc
class _$FeedPostCopyWithImpl<$Res>
    implements $FeedPostCopyWith<$Res> {
  _$FeedPostCopyWithImpl(this._self, this._then);

  final FeedPost _self;
  final $Res Function(FeedPost) _then;

/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? topic = null,Object? postedAgo = null,Object? body = null,Object? likeCount = null,Object? commentCount = null,Object? viewCount = null,Object? topComment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,postedAgo: null == postedAgo ? _self.postedAgo : postedAgo // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,topComment: freezed == topComment ? _self.topComment : topComment // ignore: cast_nullable_to_non_nullable
as FeedComment?,
  ));
}
/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res> get author {
  
  return $FeedAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCommentCopyWith<$Res>? get topComment {
    if (_self.topComment == null) {
    return null;
  }

  return $FeedCommentCopyWith<$Res>(_self.topComment!, (value) {
    return _then(_self.copyWith(topComment: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedPost].
extension FeedPostPatterns on FeedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedPost value)  $default,){
final _that = this;
switch (_that) {
case _FeedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedPost value)?  $default,){
final _that = this;
switch (_that) {
case _FeedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FeedAuthor author,  String topic,  String postedAgo,  String body,  int likeCount,  int commentCount,  int viewCount,  FeedComment? topComment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedPost() when $default != null:
return $default(_that.id,_that.author,_that.topic,_that.postedAgo,_that.body,_that.likeCount,_that.commentCount,_that.viewCount,_that.topComment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FeedAuthor author,  String topic,  String postedAgo,  String body,  int likeCount,  int commentCount,  int viewCount,  FeedComment? topComment)  $default,) {final _that = this;
switch (_that) {
case _FeedPost():
return $default(_that.id,_that.author,_that.topic,_that.postedAgo,_that.body,_that.likeCount,_that.commentCount,_that.viewCount,_that.topComment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FeedAuthor author,  String topic,  String postedAgo,  String body,  int likeCount,  int commentCount,  int viewCount,  FeedComment? topComment)?  $default,) {final _that = this;
switch (_that) {
case _FeedPost() when $default != null:
return $default(_that.id,_that.author,_that.topic,_that.postedAgo,_that.body,_that.likeCount,_that.commentCount,_that.viewCount,_that.topComment);case _:
  return null;

}
}

}

/// @nodoc


class _FeedPost implements FeedPost {
  const _FeedPost({required this.id, required this.author, required this.topic, required this.postedAgo, required this.body, this.likeCount = 0, this.commentCount = 0, this.viewCount = 0, this.topComment});
  

@override final  String id;
@override final  FeedAuthor author;
/// Name of the topic the post was filed under ("All things marriage").
@override final  String topic;
/// Display-ready relative time ("9h ago", "2 days ago").
@override final  String postedAgo;
@override final  String body;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int viewCount;
/// A comment previewed inside the card (profile "Posts" tab).
@override final  FeedComment? topComment;

/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedPostCopyWith<_FeedPost> get copyWith => __$FeedPostCopyWithImpl<_FeedPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.postedAgo, postedAgo) || other.postedAgo == postedAgo)&&(identical(other.body, body) || other.body == body)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.topComment, topComment) || other.topComment == topComment));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,topic,postedAgo,body,likeCount,commentCount,viewCount,topComment);

@override
String toString() {
  return 'FeedPost(id: $id, author: $author, topic: $topic, postedAgo: $postedAgo, body: $body, likeCount: $likeCount, commentCount: $commentCount, viewCount: $viewCount, topComment: $topComment)';
}


}

/// @nodoc
abstract mixin class _$FeedPostCopyWith<$Res> implements $FeedPostCopyWith<$Res> {
  factory _$FeedPostCopyWith(_FeedPost value, $Res Function(_FeedPost) _then) = __$FeedPostCopyWithImpl;
@override @useResult
$Res call({
 String id, FeedAuthor author, String topic, String postedAgo, String body, int likeCount, int commentCount, int viewCount, FeedComment? topComment
});


@override $FeedAuthorCopyWith<$Res> get author;@override $FeedCommentCopyWith<$Res>? get topComment;

}
/// @nodoc
class __$FeedPostCopyWithImpl<$Res>
    implements _$FeedPostCopyWith<$Res> {
  __$FeedPostCopyWithImpl(this._self, this._then);

  final _FeedPost _self;
  final $Res Function(_FeedPost) _then;

/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? topic = null,Object? postedAgo = null,Object? body = null,Object? likeCount = null,Object? commentCount = null,Object? viewCount = null,Object? topComment = freezed,}) {
  return _then(_FeedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,postedAgo: null == postedAgo ? _self.postedAgo : postedAgo // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,topComment: freezed == topComment ? _self.topComment : topComment // ignore: cast_nullable_to_non_nullable
as FeedComment?,
  ));
}

/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res> get author {
  
  return $FeedAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of FeedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCommentCopyWith<$Res>? get topComment {
    if (_self.topComment == null) {
    return null;
  }

  return $FeedCommentCopyWith<$Res>(_self.topComment!, (value) {
    return _then(_self.copyWith(topComment: value));
  });
}
}

// dart format on
