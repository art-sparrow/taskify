import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

@freezed
class LogInModel with _$LogInModel {
  const factory LogInModel({
    required String email,
    required String password,
  }) = _LogInModel;

  factory LogInModel.fromJson(Map<String, dynamic> json) =>
      _$LogInModelFromJson(json);
}
