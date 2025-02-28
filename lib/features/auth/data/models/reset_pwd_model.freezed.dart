// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_pwd_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResetPwdModel _$ResetPwdModelFromJson(Map<String, dynamic> json) {
  return _ResetPwdModel.fromJson(json);
}

/// @nodoc
mixin _$ResetPwdModel {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ResetPwdModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResetPwdModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPwdModelCopyWith<ResetPwdModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPwdModelCopyWith<$Res> {
  factory $ResetPwdModelCopyWith(
          ResetPwdModel value, $Res Function(ResetPwdModel) then) =
      _$ResetPwdModelCopyWithImpl<$Res, ResetPwdModel>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ResetPwdModelCopyWithImpl<$Res, $Val extends ResetPwdModel>
    implements $ResetPwdModelCopyWith<$Res> {
  _$ResetPwdModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPwdModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPwdModelImplCopyWith<$Res>
    implements $ResetPwdModelCopyWith<$Res> {
  factory _$$ResetPwdModelImplCopyWith(
          _$ResetPwdModelImpl value, $Res Function(_$ResetPwdModelImpl) then) =
      __$$ResetPwdModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ResetPwdModelImplCopyWithImpl<$Res>
    extends _$ResetPwdModelCopyWithImpl<$Res, _$ResetPwdModelImpl>
    implements _$$ResetPwdModelImplCopyWith<$Res> {
  __$$ResetPwdModelImplCopyWithImpl(
      _$ResetPwdModelImpl _value, $Res Function(_$ResetPwdModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPwdModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ResetPwdModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPwdModelImpl implements _ResetPwdModel {
  const _$ResetPwdModelImpl({required this.email});

  factory _$ResetPwdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPwdModelImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'ResetPwdModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPwdModelImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ResetPwdModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPwdModelImplCopyWith<_$ResetPwdModelImpl> get copyWith =>
      __$$ResetPwdModelImplCopyWithImpl<_$ResetPwdModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPwdModelImplToJson(
      this,
    );
  }
}

abstract class _ResetPwdModel implements ResetPwdModel {
  const factory _ResetPwdModel({required final String email}) =
      _$ResetPwdModelImpl;

  factory _ResetPwdModel.fromJson(Map<String, dynamic> json) =
      _$ResetPwdModelImpl.fromJson;

  @override
  String get email;

  /// Create a copy of ResetPwdModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPwdModelImplCopyWith<_$ResetPwdModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
