// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedComment {

 String get id; FeedAuthor get author;/// Display-ready relative time ("4h ago").
 String get postedAgo; String get body;/// Handle (without "@") this comment replies to — shown in pink before
/// [body].
 String? get mention; bool get edited;/// The post's own author — gets the pink "Author" tag.
 bool get isPostAuthor; int get likeCount; int get replyCount; List<FeedComment> get replies;
/// Create a copy of FeedComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCommentCopyWith<FeedComment> get copyWith => _$FeedCommentCopyWithImpl<FeedComment>(this as FeedComment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedComment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.postedAgo, postedAgo) || other.postedAgo == postedAgo)&&(identical(other.body, body) || other.body == body)&&(identical(other.mention, mention) || other.mention == mention)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.isPostAuthor, isPostAuthor) || other.isPostAuthor == isPostAuthor)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&const DeepCollectionEquality().equals(other.replies, replies));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,postedAgo,body,mention,edited,isPostAuthor,likeCount,replyCount,const DeepCollectionEquality().hash(replies));

@override
String toString() {
  return 'FeedComment(id: $id, author: $author, postedAgo: $postedAgo, body: $body, mention: $mention, edited: $edited, isPostAuthor: $isPostAuthor, likeCount: $likeCount, replyCount: $replyCount, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $FeedCommentCopyWith<$Res>  {
  factory $FeedCommentCopyWith(FeedComment value, $Res Function(FeedComment) _then) = _$FeedCommentCopyWithImpl;
@useResult
$Res call({
 String id, FeedAuthor author, String postedAgo, String body, String? mention, bool edited, bool isPostAuthor, int likeCount, int replyCount, List<FeedComment> replies
});


$FeedAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$FeedCommentCopyWithImpl<$Res>
    implements $FeedCommentCopyWith<$Res> {
  _$FeedCommentCopyWithImpl(this._self, this._then);

  final FeedComment _self;
  final $Res Function(FeedComment) _then;

/// Create a copy of FeedComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? postedAgo = null,Object? body = null,Object? mention = freezed,Object? edited = null,Object? isPostAuthor = null,Object? likeCount = null,Object? replyCount = null,Object? replies = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,postedAgo: null == postedAgo ? _self.postedAgo : postedAgo // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,isPostAuthor: null == isPostAuthor ? _self.isPostAuthor : isPostAuthor // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<FeedComment>,
  ));
}
/// Create a copy of FeedComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedAuthorCopyWith<$Res> get author {
  
  return $FeedAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedComment].
extension FeedCommentPatterns on FeedComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedComment value)  $default,){
final _that = this;
switch (_that) {
case _FeedComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedComment value)?  $default,){
final _that = this;
switch (_that) {
case _FeedComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FeedAuthor author,  String postedAgo,  String body,  String? mention,  bool edited,  bool isPostAuthor,  int likeCount,  int replyCount,  List<FeedComment> replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedComment() when $default != null:
return $default(_that.id,_that.author,_that.postedAgo,_that.body,_that.mention,_that.edited,_that.isPostAuthor,_that.likeCount,_that.replyCount,_that.replies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FeedAuthor author,  String postedAgo,  String body,  String? mention,  bool edited,  bool isPostAuthor,  int likeCount,  int replyCount,  List<FeedComment> replies)  $default,) {final _that = this;
switch (_that) {
case _FeedComment():
return $default(_that.id,_that.author,_that.postedAgo,_that.body,_that.mention,_that.edited,_that.isPostAuthor,_that.likeCount,_that.replyCount,_that.replies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FeedAuthor author,  String postedAgo,  String body,  String? mention,  bool edited,  bool isPostAuthor,  int likeCount,  int replyCount,  List<FeedComment> replies)?  $default,) {final _that = this;
switch (_that) {
case _FeedComment() when $default != null:
return $default(_that.id,_that.author,_that.postedAgo,_that.body,_that.mention,_that.edited,_that.isPostAuthor,_that.likeCount,_that.replyCount,_that.replies);case _:
  return null;

}
}

}

/// @nodoc


class _FeedComment implements FeedComment {
  const _FeedComment({required this.id, required this.author, required this.postedAgo, required this.body, this.mention, this.edited = false, this.isPostAuthor = false, this.likeCount = 0, this.replyCount = 0, final  List<FeedComment> replies = const <FeedComment>[]}): _replies = replies;
  

@override final  String id;
@override final  FeedAuthor author;
/// Display-ready relative time ("4h ago").
@override final  String postedAgo;
@override final  String body;
/// Handle (without "@") this comment replies to — shown in pink before
/// [body].
@override final  String? mention;
@override@JsonKey() final  bool edited;
/// The post's own author — gets the pink "Author" tag.
@override@JsonKey() final  bool isPostAuthor;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int replyCount;
 final  List<FeedComment> _replies;
@override@JsonKey() List<FeedComment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}


/// Create a copy of FeedComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCommentCopyWith<_FeedComment> get copyWith => __$FeedCommentCopyWithImpl<_FeedComment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedComment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.postedAgo, postedAgo) || other.postedAgo == postedAgo)&&(identical(other.body, body) || other.body == body)&&(identical(other.mention, mention) || other.mention == mention)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.isPostAuthor, isPostAuthor) || other.isPostAuthor == isPostAuthor)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&const DeepCollectionEquality().equals(other._replies, _replies));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,postedAgo,body,mention,edited,isPostAuthor,likeCount,replyCount,const DeepCollectionEquality().hash(_replies));

@override
String toString() {
  return 'FeedComment(id: $id, author: $author, postedAgo: $postedAgo, body: $body, mention: $mention, edited: $edited, isPostAuthor: $isPostAuthor, likeCount: $likeCount, replyCount: $replyCount, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$FeedCommentCopyWith<$Res> implements $FeedCommentCopyWith<$Res> {
  factory _$FeedCommentCopyWith(_FeedComment value, $Res Function(_FeedComment) _then) = __$FeedCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, FeedAuthor author, String postedAgo, String body, String? mention, bool edited, bool isPostAuthor, int likeCount, int replyCount, List<FeedComment> replies
});


@override $FeedAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$FeedCommentCopyWithImpl<$Res>
    implements _$FeedCommentCopyWith<$Res> {
  __$FeedCommentCopyWithImpl(this._self, this._then);

  final _FeedComment _self;
  final $Res Function(_FeedComment) _then;

/// Create a copy of FeedComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? postedAgo = null,Object? body = null,Object? mention = freezed,Object? edited = null,Object? isPostAuthor = null,Object? likeCount = null,Object? replyCount = null,Object? replies = null,}) {
  return _then(_FeedComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as FeedAuthor,postedAgo: null == postedAgo ? _self.postedAgo : postedAgo // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,isPostAuthor: null == isPostAuthor ? _self.isPostAuthor : isPostAuthor // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<FeedComment>,
  ));
}

/// Create a copy of FeedComment
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
