import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_pwd_model.freezed.dart';
part 'reset_pwd_model.g.dart';

@freezed
class ResetPwdModel with _$ResetPwdModel {
  const factory ResetPwdModel({
    required String email,
  }) = _ResetPwdModel;

  factory ResetPwdModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPwdModelFromJson(json);
}
