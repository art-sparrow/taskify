// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LogInModel _$LogInModelFromJson(Map<String, dynamic> json) {
  return _LogInModel.fromJson(json);
}

/// @nodoc
mixin _$LogInModel {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LogInModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogInModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogInModelCopyWith<LogInModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInModelCopyWith<$Res> {
  factory $LogInModelCopyWith(
          LogInModel value, $Res Function(LogInModel) then) =
      _$LogInModelCopyWithImpl<$Res, LogInModel>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LogInModelCopyWithImpl<$Res, $Val extends LogInModel>
    implements $LogInModelCopyWith<$Res> {
  _$LogInModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogInModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogInModelImplCopyWith<$Res>
    implements $LogInModelCopyWith<$Res> {
  factory _$$LogInModelImplCopyWith(
          _$LogInModelImpl value, $Res Function(_$LogInModelImpl) then) =
      __$$LogInModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LogInModelImplCopyWithImpl<$Res>
    extends _$LogInModelCopyWithImpl<$Res, _$LogInModelImpl>
    implements _$$LogInModelImplCopyWith<$Res> {
  __$$LogInModelImplCopyWithImpl(
      _$LogInModelImpl _value, $Res Function(_$LogInModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogInModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$LogInModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogInModelImpl implements _LogInModel {
  const _$LogInModelImpl({required this.email, required this.password});

  factory _$LogInModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogInModelImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LogInModel(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogInModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LogInModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogInModelImplCopyWith<_$LogInModelImpl> get copyWith =>
      __$$LogInModelImplCopyWithImpl<_$LogInModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogInModelImplToJson(
      this,
    );
  }
}

abstract class _LogInModel implements LogInModel {
  const factory _LogInModel(
      {required final String email,
      required final String password}) = _$LogInModelImpl;

  factory _LogInModel.fromJson(Map<String, dynamic> json) =
      _$LogInModelImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LogInModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogInModelImplCopyWith<_$LogInModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
