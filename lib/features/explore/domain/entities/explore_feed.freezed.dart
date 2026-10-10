// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExploreSection {

 int get count; List<ExploreProfile> get profiles;
/// Create a copy of ExploreSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<ExploreSection> get copyWith => _$ExploreSectionCopyWithImpl<ExploreSection>(this as ExploreSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreSection&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.profiles, profiles));
}


@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(profiles));

@override
String toString() {
  return 'ExploreSection(count: $count, profiles: $profiles)';
}


}

/// @nodoc
abstract mixin class $ExploreSectionCopyWith<$Res>  {
  factory $ExploreSectionCopyWith(ExploreSection value, $Res Function(ExploreSection) _then) = _$ExploreSectionCopyWithImpl;
@useResult
$Res call({
 int count, List<ExploreProfile> profiles
});




}
/// @nodoc
class _$ExploreSectionCopyWithImpl<$Res>
    implements $ExploreSectionCopyWith<$Res> {
  _$ExploreSectionCopyWithImpl(this._self, this._then);

  final ExploreSection _self;
  final $Res Function(ExploreSection) _then;

/// Create a copy of ExploreSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? profiles = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExploreSection].
extension ExploreSectionPatterns on ExploreSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreSection value)  $default,){
final _that = this;
switch (_that) {
case _ExploreSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  List<ExploreProfile> profiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreSection() when $default != null:
return $default(_that.count,_that.profiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  List<ExploreProfile> profiles)  $default,) {final _that = this;
switch (_that) {
case _ExploreSection():
return $default(_that.count,_that.profiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  List<ExploreProfile> profiles)?  $default,) {final _that = this;
switch (_that) {
case _ExploreSection() when $default != null:
return $default(_that.count,_that.profiles);case _:
  return null;

}
}

}

/// @nodoc


class _ExploreSection implements ExploreSection {
  const _ExploreSection({this.count = 0, final  List<ExploreProfile> profiles = const <ExploreProfile>[]}): _profiles = profiles;
  

@override@JsonKey() final  int count;
 final  List<ExploreProfile> _profiles;
@override@JsonKey() List<ExploreProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}


/// Create a copy of ExploreSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreSectionCopyWith<_ExploreSection> get copyWith => __$ExploreSectionCopyWithImpl<_ExploreSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreSection&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._profiles, _profiles));
}


@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_profiles));

@override
String toString() {
  return 'ExploreSection(count: $count, profiles: $profiles)';
}


}

/// @nodoc
abstract mixin class _$ExploreSectionCopyWith<$Res> implements $ExploreSectionCopyWith<$Res> {
  factory _$ExploreSectionCopyWith(_ExploreSection value, $Res Function(_ExploreSection) _then) = __$ExploreSectionCopyWithImpl;
@override @useResult
$Res call({
 int count, List<ExploreProfile> profiles
});




}
/// @nodoc
class __$ExploreSectionCopyWithImpl<$Res>
    implements _$ExploreSectionCopyWith<$Res> {
  __$ExploreSectionCopyWithImpl(this._self, this._then);

  final _ExploreSection _self;
  final $Res Function(_ExploreSection) _then;

/// Create a copy of ExploreSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? profiles = null,}) {
  return _then(_ExploreSection(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<ExploreProfile>,
  ));
}


}

/// @nodoc
mixin _$ExploreFeed {

 ExploreSection get likesInFilters; ExploreSection get secondLook; ExploreSection get currentlyAvailable; ExploreSection get visitedYou; ExploreSection get justJoined; ExploreSection get activeNearYou;
/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreFeedCopyWith<ExploreFeed> get copyWith => _$ExploreFeedCopyWithImpl<ExploreFeed>(this as ExploreFeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreFeed&&(identical(other.likesInFilters, likesInFilters) || other.likesInFilters == likesInFilters)&&(identical(other.secondLook, secondLook) || other.secondLook == secondLook)&&(identical(other.currentlyAvailable, currentlyAvailable) || other.currentlyAvailable == currentlyAvailable)&&(identical(other.visitedYou, visitedYou) || other.visitedYou == visitedYou)&&(identical(other.justJoined, justJoined) || other.justJoined == justJoined)&&(identical(other.activeNearYou, activeNearYou) || other.activeNearYou == activeNearYou));
}


@override
int get hashCode => Object.hash(runtimeType,likesInFilters,secondLook,currentlyAvailable,visitedYou,justJoined,activeNearYou);

@override
String toString() {
  return 'ExploreFeed(likesInFilters: $likesInFilters, secondLook: $secondLook, currentlyAvailable: $currentlyAvailable, visitedYou: $visitedYou, justJoined: $justJoined, activeNearYou: $activeNearYou)';
}


}

/// @nodoc
abstract mixin class $ExploreFeedCopyWith<$Res>  {
  factory $ExploreFeedCopyWith(ExploreFeed value, $Res Function(ExploreFeed) _then) = _$ExploreFeedCopyWithImpl;
@useResult
$Res call({
 ExploreSection likesInFilters, ExploreSection secondLook, ExploreSection currentlyAvailable, ExploreSection visitedYou, ExploreSection justJoined, ExploreSection activeNearYou
});


$ExploreSectionCopyWith<$Res> get likesInFilters;$ExploreSectionCopyWith<$Res> get secondLook;$ExploreSectionCopyWith<$Res> get currentlyAvailable;$ExploreSectionCopyWith<$Res> get visitedYou;$ExploreSectionCopyWith<$Res> get justJoined;$ExploreSectionCopyWith<$Res> get activeNearYou;

}
/// @nodoc
class _$ExploreFeedCopyWithImpl<$Res>
    implements $ExploreFeedCopyWith<$Res> {
  _$ExploreFeedCopyWithImpl(this._self, this._then);

  final ExploreFeed _self;
  final $Res Function(ExploreFeed) _then;

/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likesInFilters = null,Object? secondLook = null,Object? currentlyAvailable = null,Object? visitedYou = null,Object? justJoined = null,Object? activeNearYou = null,}) {
  return _then(_self.copyWith(
likesInFilters: null == likesInFilters ? _self.likesInFilters : likesInFilters // ignore: cast_nullable_to_non_nullable
as ExploreSection,secondLook: null == secondLook ? _self.secondLook : secondLook // ignore: cast_nullable_to_non_nullable
as ExploreSection,currentlyAvailable: null == currentlyAvailable ? _self.currentlyAvailable : currentlyAvailable // ignore: cast_nullable_to_non_nullable
as ExploreSection,visitedYou: null == visitedYou ? _self.visitedYou : visitedYou // ignore: cast_nullable_to_non_nullable
as ExploreSection,justJoined: null == justJoined ? _self.justJoined : justJoined // ignore: cast_nullable_to_non_nullable
as ExploreSection,activeNearYou: null == activeNearYou ? _self.activeNearYou : activeNearYou // ignore: cast_nullable_to_non_nullable
as ExploreSection,
  ));
}
/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get likesInFilters {
  
  return $ExploreSectionCopyWith<$Res>(_self.likesInFilters, (value) {
    return _then(_self.copyWith(likesInFilters: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get secondLook {
  
  return $ExploreSectionCopyWith<$Res>(_self.secondLook, (value) {
    return _then(_self.copyWith(secondLook: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get currentlyAvailable {
  
  return $ExploreSectionCopyWith<$Res>(_self.currentlyAvailable, (value) {
    return _then(_self.copyWith(currentlyAvailable: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get visitedYou {
  
  return $ExploreSectionCopyWith<$Res>(_self.visitedYou, (value) {
    return _then(_self.copyWith(visitedYou: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get justJoined {
  
  return $ExploreSectionCopyWith<$Res>(_self.justJoined, (value) {
    return _then(_self.copyWith(justJoined: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get activeNearYou {
  
  return $ExploreSectionCopyWith<$Res>(_self.activeNearYou, (value) {
    return _then(_self.copyWith(activeNearYou: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExploreFeed].
extension ExploreFeedPatterns on ExploreFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreFeed value)  $default,){
final _that = this;
switch (_that) {
case _ExploreFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreFeed value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExploreSection likesInFilters,  ExploreSection secondLook,  ExploreSection currentlyAvailable,  ExploreSection visitedYou,  ExploreSection justJoined,  ExploreSection activeNearYou)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreFeed() when $default != null:
return $default(_that.likesInFilters,_that.secondLook,_that.currentlyAvailable,_that.visitedYou,_that.justJoined,_that.activeNearYou);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExploreSection likesInFilters,  ExploreSection secondLook,  ExploreSection currentlyAvailable,  ExploreSection visitedYou,  ExploreSection justJoined,  ExploreSection activeNearYou)  $default,) {final _that = this;
switch (_that) {
case _ExploreFeed():
return $default(_that.likesInFilters,_that.secondLook,_that.currentlyAvailable,_that.visitedYou,_that.justJoined,_that.activeNearYou);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExploreSection likesInFilters,  ExploreSection secondLook,  ExploreSection currentlyAvailable,  ExploreSection visitedYou,  ExploreSection justJoined,  ExploreSection activeNearYou)?  $default,) {final _that = this;
switch (_that) {
case _ExploreFeed() when $default != null:
return $default(_that.likesInFilters,_that.secondLook,_that.currentlyAvailable,_that.visitedYou,_that.justJoined,_that.activeNearYou);case _:
  return null;

}
}

}

/// @nodoc


class _ExploreFeed implements ExploreFeed {
  const _ExploreFeed({this.likesInFilters = const ExploreSection(), this.secondLook = const ExploreSection(), this.currentlyAvailable = const ExploreSection(), this.visitedYou = const ExploreSection(), this.justJoined = const ExploreSection(), this.activeNearYou = const ExploreSection()});
  

@override@JsonKey() final  ExploreSection likesInFilters;
@override@JsonKey() final  ExploreSection secondLook;
@override@JsonKey() final  ExploreSection currentlyAvailable;
@override@JsonKey() final  ExploreSection visitedYou;
@override@JsonKey() final  ExploreSection justJoined;
@override@JsonKey() final  ExploreSection activeNearYou;

/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreFeedCopyWith<_ExploreFeed> get copyWith => __$ExploreFeedCopyWithImpl<_ExploreFeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreFeed&&(identical(other.likesInFilters, likesInFilters) || other.likesInFilters == likesInFilters)&&(identical(other.secondLook, secondLook) || other.secondLook == secondLook)&&(identical(other.currentlyAvailable, currentlyAvailable) || other.currentlyAvailable == currentlyAvailable)&&(identical(other.visitedYou, visitedYou) || other.visitedYou == visitedYou)&&(identical(other.justJoined, justJoined) || other.justJoined == justJoined)&&(identical(other.activeNearYou, activeNearYou) || other.activeNearYou == activeNearYou));
}


@override
int get hashCode => Object.hash(runtimeType,likesInFilters,secondLook,currentlyAvailable,visitedYou,justJoined,activeNearYou);

@override
String toString() {
  return 'ExploreFeed(likesInFilters: $likesInFilters, secondLook: $secondLook, currentlyAvailable: $currentlyAvailable, visitedYou: $visitedYou, justJoined: $justJoined, activeNearYou: $activeNearYou)';
}


}

/// @nodoc
abstract mixin class _$ExploreFeedCopyWith<$Res> implements $ExploreFeedCopyWith<$Res> {
  factory _$ExploreFeedCopyWith(_ExploreFeed value, $Res Function(_ExploreFeed) _then) = __$ExploreFeedCopyWithImpl;
@override @useResult
$Res call({
 ExploreSection likesInFilters, ExploreSection secondLook, ExploreSection currentlyAvailable, ExploreSection visitedYou, ExploreSection justJoined, ExploreSection activeNearYou
});


@override $ExploreSectionCopyWith<$Res> get likesInFilters;@override $ExploreSectionCopyWith<$Res> get secondLook;@override $ExploreSectionCopyWith<$Res> get currentlyAvailable;@override $ExploreSectionCopyWith<$Res> get visitedYou;@override $ExploreSectionCopyWith<$Res> get justJoined;@override $ExploreSectionCopyWith<$Res> get activeNearYou;

}
/// @nodoc
class __$ExploreFeedCopyWithImpl<$Res>
    implements _$ExploreFeedCopyWith<$Res> {
  __$ExploreFeedCopyWithImpl(this._self, this._then);

  final _ExploreFeed _self;
  final $Res Function(_ExploreFeed) _then;

/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likesInFilters = null,Object? secondLook = null,Object? currentlyAvailable = null,Object? visitedYou = null,Object? justJoined = null,Object? activeNearYou = null,}) {
  return _then(_ExploreFeed(
likesInFilters: null == likesInFilters ? _self.likesInFilters : likesInFilters // ignore: cast_nullable_to_non_nullable
as ExploreSection,secondLook: null == secondLook ? _self.secondLook : secondLook // ignore: cast_nullable_to_non_nullable
as ExploreSection,currentlyAvailable: null == currentlyAvailable ? _self.currentlyAvailable : currentlyAvailable // ignore: cast_nullable_to_non_nullable
as ExploreSection,visitedYou: null == visitedYou ? _self.visitedYou : visitedYou // ignore: cast_nullable_to_non_nullable
as ExploreSection,justJoined: null == justJoined ? _self.justJoined : justJoined // ignore: cast_nullable_to_non_nullable
as ExploreSection,activeNearYou: null == activeNearYou ? _self.activeNearYou : activeNearYou // ignore: cast_nullable_to_non_nullable
as ExploreSection,
  ));
}

/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get likesInFilters {
  
  return $ExploreSectionCopyWith<$Res>(_self.likesInFilters, (value) {
    return _then(_self.copyWith(likesInFilters: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get secondLook {
  
  return $ExploreSectionCopyWith<$Res>(_self.secondLook, (value) {
    return _then(_self.copyWith(secondLook: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get currentlyAvailable {
  
  return $ExploreSectionCopyWith<$Res>(_self.currentlyAvailable, (value) {
    return _then(_self.copyWith(currentlyAvailable: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get visitedYou {
  
  return $ExploreSectionCopyWith<$Res>(_self.visitedYou, (value) {
    return _then(_self.copyWith(visitedYou: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get justJoined {
  
  return $ExploreSectionCopyWith<$Res>(_self.justJoined, (value) {
    return _then(_self.copyWith(justJoined: value));
  });
}/// Create a copy of ExploreFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExploreSectionCopyWith<$Res> get activeNearYou {
  
  return $ExploreSectionCopyWith<$Res>(_self.activeNearYou, (value) {
    return _then(_self.copyWith(activeNearYou: value));
  });
}
}

// dart format on
