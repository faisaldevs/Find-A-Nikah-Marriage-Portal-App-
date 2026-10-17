// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedFilter {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedFilter);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedFilter()';
}


}

/// @nodoc
class $FeedFilterCopyWith<$Res>  {
$FeedFilterCopyWith(FeedFilter _, $Res Function(FeedFilter) __);
}


/// Adds pattern-matching-related methods to [FeedFilter].
extension FeedFilterPatterns on FeedFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedForYou value)?  forYou,TResult Function( FeedNewest value)?  newest,TResult Function( FeedTopicFilter value)?  topic,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedForYou() when forYou != null:
return forYou(_that);case FeedNewest() when newest != null:
return newest(_that);case FeedTopicFilter() when topic != null:
return topic(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedForYou value)  forYou,required TResult Function( FeedNewest value)  newest,required TResult Function( FeedTopicFilter value)  topic,}){
final _that = this;
switch (_that) {
case FeedForYou():
return forYou(_that);case FeedNewest():
return newest(_that);case FeedTopicFilter():
return topic(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedForYou value)?  forYou,TResult? Function( FeedNewest value)?  newest,TResult? Function( FeedTopicFilter value)?  topic,}){
final _that = this;
switch (_that) {
case FeedForYou() when forYou != null:
return forYou(_that);case FeedNewest() when newest != null:
return newest(_that);case FeedTopicFilter() when topic != null:
return topic(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  forYou,TResult Function()?  newest,TResult Function( FeedTopic topic)?  topic,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedForYou() when forYou != null:
return forYou();case FeedNewest() when newest != null:
return newest();case FeedTopicFilter() when topic != null:
return topic(_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  forYou,required TResult Function()  newest,required TResult Function( FeedTopic topic)  topic,}) {final _that = this;
switch (_that) {
case FeedForYou():
return forYou();case FeedNewest():
return newest();case FeedTopicFilter():
return topic(_that.topic);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  forYou,TResult? Function()?  newest,TResult? Function( FeedTopic topic)?  topic,}) {final _that = this;
switch (_that) {
case FeedForYou() when forYou != null:
return forYou();case FeedNewest() when newest != null:
return newest();case FeedTopicFilter() when topic != null:
return topic(_that.topic);case _:
  return null;

}
}

}

/// @nodoc


class FeedForYou implements FeedFilter {
  const FeedForYou();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedForYou);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedFilter.forYou()';
}


}




/// @nodoc


class FeedNewest implements FeedFilter {
  const FeedNewest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedNewest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedFilter.newest()';
}


}




/// @nodoc


class FeedTopicFilter implements FeedFilter {
  const FeedTopicFilter(this.topic);
  

 final  FeedTopic topic;

/// Create a copy of FeedFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedTopicFilterCopyWith<FeedTopicFilter> get copyWith => _$FeedTopicFilterCopyWithImpl<FeedTopicFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedTopicFilter&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,topic);

@override
String toString() {
  return 'FeedFilter.topic(topic: $topic)';
}


}

/// @nodoc
abstract mixin class $FeedTopicFilterCopyWith<$Res> implements $FeedFilterCopyWith<$Res> {
  factory $FeedTopicFilterCopyWith(FeedTopicFilter value, $Res Function(FeedTopicFilter) _then) = _$FeedTopicFilterCopyWithImpl;
@useResult
$Res call({
 FeedTopic topic
});


$FeedTopicCopyWith<$Res> get topic;

}
/// @nodoc
class _$FeedTopicFilterCopyWithImpl<$Res>
    implements $FeedTopicFilterCopyWith<$Res> {
  _$FeedTopicFilterCopyWithImpl(this._self, this._then);

  final FeedTopicFilter _self;
  final $Res Function(FeedTopicFilter) _then;

/// Create a copy of FeedFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? topic = null,}) {
  return _then(FeedTopicFilter(
null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as FeedTopic,
  ));
}

/// Create a copy of FeedFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedTopicCopyWith<$Res> get topic {
  
  return $FeedTopicCopyWith<$Res>(_self.topic, (value) {
    return _then(_self.copyWith(topic: value));
  });
}
}

// dart format on
