// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_bio_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiBioResponse {

 AiBioData get data; int? get statusCode; String? get message; bool? get success;
/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBioResponseCopyWith<AiBioResponse> get copyWith => _$AiBioResponseCopyWithImpl<AiBioResponse>(this as AiBioResponse, _$identity);

  /// Serializes this AiBioResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBioResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,statusCode,message,success);

@override
String toString() {
  return 'AiBioResponse(data: $data, statusCode: $statusCode, message: $message, success: $success)';
}


}

/// @nodoc
abstract mixin class $AiBioResponseCopyWith<$Res>  {
  factory $AiBioResponseCopyWith(AiBioResponse value, $Res Function(AiBioResponse) _then) = _$AiBioResponseCopyWithImpl;
@useResult
$Res call({
 AiBioData data, int? statusCode, String? message, bool? success
});


$AiBioDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AiBioResponseCopyWithImpl<$Res>
    implements $AiBioResponseCopyWith<$Res> {
  _$AiBioResponseCopyWithImpl(this._self, this._then);

  final AiBioResponse _self;
  final $Res Function(AiBioResponse) _then;

/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? statusCode = freezed,Object? message = freezed,Object? success = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AiBioData,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiBioDataCopyWith<$Res> get data {
  
  return $AiBioDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiBioResponse].
extension AiBioResponsePatterns on AiBioResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBioResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBioResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBioResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiBioResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBioResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiBioResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiBioData data,  int? statusCode,  String? message,  bool? success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBioResponse() when $default != null:
return $default(_that.data,_that.statusCode,_that.message,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiBioData data,  int? statusCode,  String? message,  bool? success)  $default,) {final _that = this;
switch (_that) {
case _AiBioResponse():
return $default(_that.data,_that.statusCode,_that.message,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiBioData data,  int? statusCode,  String? message,  bool? success)?  $default,) {final _that = this;
switch (_that) {
case _AiBioResponse() when $default != null:
return $default(_that.data,_that.statusCode,_that.message,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBioResponse implements AiBioResponse {
  const _AiBioResponse({required this.data, this.statusCode, this.message, this.success});
  factory _AiBioResponse.fromJson(Map<String, dynamic> json) => _$AiBioResponseFromJson(json);

@override final  AiBioData data;
@override final  int? statusCode;
@override final  String? message;
@override final  bool? success;

/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBioResponseCopyWith<_AiBioResponse> get copyWith => __$AiBioResponseCopyWithImpl<_AiBioResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBioResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBioResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,statusCode,message,success);

@override
String toString() {
  return 'AiBioResponse(data: $data, statusCode: $statusCode, message: $message, success: $success)';
}


}

/// @nodoc
abstract mixin class _$AiBioResponseCopyWith<$Res> implements $AiBioResponseCopyWith<$Res> {
  factory _$AiBioResponseCopyWith(_AiBioResponse value, $Res Function(_AiBioResponse) _then) = __$AiBioResponseCopyWithImpl;
@override @useResult
$Res call({
 AiBioData data, int? statusCode, String? message, bool? success
});


@override $AiBioDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AiBioResponseCopyWithImpl<$Res>
    implements _$AiBioResponseCopyWith<$Res> {
  __$AiBioResponseCopyWithImpl(this._self, this._then);

  final _AiBioResponse _self;
  final $Res Function(_AiBioResponse) _then;

/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? statusCode = freezed,Object? message = freezed,Object? success = freezed,}) {
  return _then(_AiBioResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AiBioData,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of AiBioResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiBioDataCopyWith<$Res> get data {
  
  return $AiBioDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AiBioData {

 String get bio; List<AiBioOption> get options; String? get source;
/// Create a copy of AiBioData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBioDataCopyWith<AiBioData> get copyWith => _$AiBioDataCopyWithImpl<AiBioData>(this as AiBioData, _$identity);

  /// Serializes this AiBioData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBioData&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bio,const DeepCollectionEquality().hash(options),source);

@override
String toString() {
  return 'AiBioData(bio: $bio, options: $options, source: $source)';
}


}

/// @nodoc
abstract mixin class $AiBioDataCopyWith<$Res>  {
  factory $AiBioDataCopyWith(AiBioData value, $Res Function(AiBioData) _then) = _$AiBioDataCopyWithImpl;
@useResult
$Res call({
 String bio, List<AiBioOption> options, String? source
});




}
/// @nodoc
class _$AiBioDataCopyWithImpl<$Res>
    implements $AiBioDataCopyWith<$Res> {
  _$AiBioDataCopyWithImpl(this._self, this._then);

  final AiBioData _self;
  final $Res Function(AiBioData) _then;

/// Create a copy of AiBioData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bio = null,Object? options = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<AiBioOption>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBioData].
extension AiBioDataPatterns on AiBioData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBioData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBioData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBioData value)  $default,){
final _that = this;
switch (_that) {
case _AiBioData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBioData value)?  $default,){
final _that = this;
switch (_that) {
case _AiBioData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bio,  List<AiBioOption> options,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBioData() when $default != null:
return $default(_that.bio,_that.options,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bio,  List<AiBioOption> options,  String? source)  $default,) {final _that = this;
switch (_that) {
case _AiBioData():
return $default(_that.bio,_that.options,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bio,  List<AiBioOption> options,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _AiBioData() when $default != null:
return $default(_that.bio,_that.options,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBioData implements AiBioData {
  const _AiBioData({required this.bio, final  List<AiBioOption> options = const <AiBioOption>[], this.source}): _options = options;
  factory _AiBioData.fromJson(Map<String, dynamic> json) => _$AiBioDataFromJson(json);

@override final  String bio;
 final  List<AiBioOption> _options;
@override@JsonKey() List<AiBioOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String? source;

/// Create a copy of AiBioData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBioDataCopyWith<_AiBioData> get copyWith => __$AiBioDataCopyWithImpl<_AiBioData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBioDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBioData&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bio,const DeepCollectionEquality().hash(_options),source);

@override
String toString() {
  return 'AiBioData(bio: $bio, options: $options, source: $source)';
}


}

/// @nodoc
abstract mixin class _$AiBioDataCopyWith<$Res> implements $AiBioDataCopyWith<$Res> {
  factory _$AiBioDataCopyWith(_AiBioData value, $Res Function(_AiBioData) _then) = __$AiBioDataCopyWithImpl;
@override @useResult
$Res call({
 String bio, List<AiBioOption> options, String? source
});




}
/// @nodoc
class __$AiBioDataCopyWithImpl<$Res>
    implements _$AiBioDataCopyWith<$Res> {
  __$AiBioDataCopyWithImpl(this._self, this._then);

  final _AiBioData _self;
  final $Res Function(_AiBioData) _then;

/// Create a copy of AiBioData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bio = null,Object? options = null,Object? source = freezed,}) {
  return _then(_AiBioData(
bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<AiBioOption>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiBioOption {

 String get tone; String get title; String get bio;
/// Create a copy of AiBioOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiBioOptionCopyWith<AiBioOption> get copyWith => _$AiBioOptionCopyWithImpl<AiBioOption>(this as AiBioOption, _$identity);

  /// Serializes this AiBioOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiBioOption&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tone,title,bio);

@override
String toString() {
  return 'AiBioOption(tone: $tone, title: $title, bio: $bio)';
}


}

/// @nodoc
abstract mixin class $AiBioOptionCopyWith<$Res>  {
  factory $AiBioOptionCopyWith(AiBioOption value, $Res Function(AiBioOption) _then) = _$AiBioOptionCopyWithImpl;
@useResult
$Res call({
 String tone, String title, String bio
});




}
/// @nodoc
class _$AiBioOptionCopyWithImpl<$Res>
    implements $AiBioOptionCopyWith<$Res> {
  _$AiBioOptionCopyWithImpl(this._self, this._then);

  final AiBioOption _self;
  final $Res Function(AiBioOption) _then;

/// Create a copy of AiBioOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tone = null,Object? title = null,Object? bio = null,}) {
  return _then(_self.copyWith(
tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiBioOption].
extension AiBioOptionPatterns on AiBioOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiBioOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiBioOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiBioOption value)  $default,){
final _that = this;
switch (_that) {
case _AiBioOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiBioOption value)?  $default,){
final _that = this;
switch (_that) {
case _AiBioOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tone,  String title,  String bio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiBioOption() when $default != null:
return $default(_that.tone,_that.title,_that.bio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tone,  String title,  String bio)  $default,) {final _that = this;
switch (_that) {
case _AiBioOption():
return $default(_that.tone,_that.title,_that.bio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tone,  String title,  String bio)?  $default,) {final _that = this;
switch (_that) {
case _AiBioOption() when $default != null:
return $default(_that.tone,_that.title,_that.bio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiBioOption implements AiBioOption {
  const _AiBioOption({required this.tone, required this.title, required this.bio});
  factory _AiBioOption.fromJson(Map<String, dynamic> json) => _$AiBioOptionFromJson(json);

@override final  String tone;
@override final  String title;
@override final  String bio;

/// Create a copy of AiBioOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiBioOptionCopyWith<_AiBioOption> get copyWith => __$AiBioOptionCopyWithImpl<_AiBioOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiBioOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiBioOption&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.title, title) || other.title == title)&&(identical(other.bio, bio) || other.bio == bio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tone,title,bio);

@override
String toString() {
  return 'AiBioOption(tone: $tone, title: $title, bio: $bio)';
}


}

/// @nodoc
abstract mixin class _$AiBioOptionCopyWith<$Res> implements $AiBioOptionCopyWith<$Res> {
  factory _$AiBioOptionCopyWith(_AiBioOption value, $Res Function(_AiBioOption) _then) = __$AiBioOptionCopyWithImpl;
@override @useResult
$Res call({
 String tone, String title, String bio
});




}
/// @nodoc
class __$AiBioOptionCopyWithImpl<$Res>
    implements _$AiBioOptionCopyWith<$Res> {
  __$AiBioOptionCopyWithImpl(this._self, this._then);

  final _AiBioOption _self;
  final $Res Function(_AiBioOption) _then;

/// Create a copy of AiBioOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tone = null,Object? title = null,Object? bio = null,}) {
  return _then(_AiBioOption(
tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
