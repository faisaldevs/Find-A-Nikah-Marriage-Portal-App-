// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liveness_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LivenessStep {

 String get fieldName; LivenessPose get pose;
/// Create a copy of LivenessStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LivenessStepCopyWith<LivenessStep> get copyWith => _$LivenessStepCopyWithImpl<LivenessStep>(this as LivenessStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LivenessStep&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.pose, pose) || other.pose == pose));
}


@override
int get hashCode => Object.hash(runtimeType,fieldName,pose);

@override
String toString() {
  return 'LivenessStep(fieldName: $fieldName, pose: $pose)';
}


}

/// @nodoc
abstract mixin class $LivenessStepCopyWith<$Res>  {
  factory $LivenessStepCopyWith(LivenessStep value, $Res Function(LivenessStep) _then) = _$LivenessStepCopyWithImpl;
@useResult
$Res call({
 String fieldName, LivenessPose pose
});




}
/// @nodoc
class _$LivenessStepCopyWithImpl<$Res>
    implements $LivenessStepCopyWith<$Res> {
  _$LivenessStepCopyWithImpl(this._self, this._then);

  final LivenessStep _self;
  final $Res Function(LivenessStep) _then;

/// Create a copy of LivenessStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldName = null,Object? pose = null,}) {
  return _then(_self.copyWith(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as LivenessPose,
  ));
}

}


/// Adds pattern-matching-related methods to [LivenessStep].
extension LivenessStepPatterns on LivenessStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LivenessStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LivenessStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LivenessStep value)  $default,){
final _that = this;
switch (_that) {
case _LivenessStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LivenessStep value)?  $default,){
final _that = this;
switch (_that) {
case _LivenessStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldName,  LivenessPose pose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LivenessStep() when $default != null:
return $default(_that.fieldName,_that.pose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldName,  LivenessPose pose)  $default,) {final _that = this;
switch (_that) {
case _LivenessStep():
return $default(_that.fieldName,_that.pose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldName,  LivenessPose pose)?  $default,) {final _that = this;
switch (_that) {
case _LivenessStep() when $default != null:
return $default(_that.fieldName,_that.pose);case _:
  return null;

}
}

}

/// @nodoc


class _LivenessStep implements LivenessStep {
  const _LivenessStep({required this.fieldName, required this.pose});
  

@override final  String fieldName;
@override final  LivenessPose pose;

/// Create a copy of LivenessStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LivenessStepCopyWith<_LivenessStep> get copyWith => __$LivenessStepCopyWithImpl<_LivenessStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LivenessStep&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.pose, pose) || other.pose == pose));
}


@override
int get hashCode => Object.hash(runtimeType,fieldName,pose);

@override
String toString() {
  return 'LivenessStep(fieldName: $fieldName, pose: $pose)';
}


}

/// @nodoc
abstract mixin class _$LivenessStepCopyWith<$Res> implements $LivenessStepCopyWith<$Res> {
  factory _$LivenessStepCopyWith(_LivenessStep value, $Res Function(_LivenessStep) _then) = __$LivenessStepCopyWithImpl;
@override @useResult
$Res call({
 String fieldName, LivenessPose pose
});




}
/// @nodoc
class __$LivenessStepCopyWithImpl<$Res>
    implements _$LivenessStepCopyWith<$Res> {
  __$LivenessStepCopyWithImpl(this._self, this._then);

  final _LivenessStep _self;
  final $Res Function(_LivenessStep) _then;

/// Create a copy of LivenessStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldName = null,Object? pose = null,}) {
  return _then(_LivenessStep(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as LivenessPose,
  ));
}


}

/// @nodoc
mixin _$LivenessStepPlan {

 List<LivenessStep> get steps;
/// Create a copy of LivenessStepPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LivenessStepPlanCopyWith<LivenessStepPlan> get copyWith => _$LivenessStepPlanCopyWithImpl<LivenessStepPlan>(this as LivenessStepPlan, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LivenessStepPlan&&const DeepCollectionEquality().equals(other.steps, steps));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'LivenessStepPlan(steps: $steps)';
}


}

/// @nodoc
abstract mixin class $LivenessStepPlanCopyWith<$Res>  {
  factory $LivenessStepPlanCopyWith(LivenessStepPlan value, $Res Function(LivenessStepPlan) _then) = _$LivenessStepPlanCopyWithImpl;
@useResult
$Res call({
 List<LivenessStep> steps
});




}
/// @nodoc
class _$LivenessStepPlanCopyWithImpl<$Res>
    implements $LivenessStepPlanCopyWith<$Res> {
  _$LivenessStepPlanCopyWithImpl(this._self, this._then);

  final LivenessStepPlan _self;
  final $Res Function(LivenessStepPlan) _then;

/// Create a copy of LivenessStepPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? steps = null,}) {
  return _then(_self.copyWith(
steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<LivenessStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [LivenessStepPlan].
extension LivenessStepPlanPatterns on LivenessStepPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LivenessStepPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LivenessStepPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LivenessStepPlan value)  $default,){
final _that = this;
switch (_that) {
case _LivenessStepPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LivenessStepPlan value)?  $default,){
final _that = this;
switch (_that) {
case _LivenessStepPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LivenessStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LivenessStepPlan() when $default != null:
return $default(_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LivenessStep> steps)  $default,) {final _that = this;
switch (_that) {
case _LivenessStepPlan():
return $default(_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LivenessStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _LivenessStepPlan() when $default != null:
return $default(_that.steps);case _:
  return null;

}
}

}

/// @nodoc


class _LivenessStepPlan extends LivenessStepPlan {
  const _LivenessStepPlan({required final  List<LivenessStep> steps}): _steps = steps,super._();
  

 final  List<LivenessStep> _steps;
@override List<LivenessStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of LivenessStepPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LivenessStepPlanCopyWith<_LivenessStepPlan> get copyWith => __$LivenessStepPlanCopyWithImpl<_LivenessStepPlan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LivenessStepPlan&&const DeepCollectionEquality().equals(other._steps, _steps));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'LivenessStepPlan(steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$LivenessStepPlanCopyWith<$Res> implements $LivenessStepPlanCopyWith<$Res> {
  factory _$LivenessStepPlanCopyWith(_LivenessStepPlan value, $Res Function(_LivenessStepPlan) _then) = __$LivenessStepPlanCopyWithImpl;
@override @useResult
$Res call({
 List<LivenessStep> steps
});




}
/// @nodoc
class __$LivenessStepPlanCopyWithImpl<$Res>
    implements _$LivenessStepPlanCopyWith<$Res> {
  __$LivenessStepPlanCopyWithImpl(this._self, this._then);

  final _LivenessStepPlan _self;
  final $Res Function(_LivenessStepPlan) _then;

/// Create a copy of LivenessStepPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? steps = null,}) {
  return _then(_LivenessStepPlan(
steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<LivenessStep>,
  ));
}


}

// dart format on
