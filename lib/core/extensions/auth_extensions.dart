import 'package:taskify/features/auth/data/entities/login_entity.dart';
import 'package:taskify/features/auth/data/entities/register_entity.dart';
import 'package:taskify/features/auth/data/entities/reset_pwd_entity.dart';
import 'package:taskify/features/auth/data/models/login_model.dart';
import 'package:taskify/features/auth/data/models/register_model.dart';
import 'package:taskify/features/auth/data/models/reset_pwd_model.dart';

// Extension to convert RegisterModel to RegisterEntity
extension RegisterModelToEntity on RegisterModel {
  RegisterEntity toEntity() {
    return RegisterEntity(
      name: name,
      phone: phone,
      email: email,
      password: password,
      joinedOn: joinedOn,
      uid: uid,
      fcmToken: fcmToken,
    );
  }
}

// Extension to convert RegisterEntity to RegisterModel
extension RegisterEntityToModel on RegisterEntity {
  RegisterModel toModel() {
    return RegisterModel(
      name: name,
      phone: phone,
      email: email,
      password: password,
      joinedOn: joinedOn,
      uid: uid,
      fcmToken: fcmToken,
    );
  }
}

// Extension to convert LogInModel to LogInEntity
extension LogInModelToEntity on LogInModel {
  LogInEntity toEntity() {
    return LogInEntity(
      email: email,
      password: password,
    );
  }
}

// Extension to convert LogInEntity to LogInModel
extension LogInEntityToModel on LogInEntity {
  LogInModel toModel() {
    return LogInModel(
      email: email,
      password: password,
    );
  }
}

// Extension to convert ResetPwdModel to ResetPwdEntity
extension ResetPwdModelToEntity on ResetPwdModel {
  ResetPwdEntity toEntity() {
    return ResetPwdEntity(
      email: email,
    );
  }
}

// Extension to convert ResetPwdEntity to ResetPwdModel
extension ResetPwdEntityToModel on ResetPwdEntity {
  ResetPwdModel toModel() {
    return ResetPwdModel(
      email: email,
    );
  }
}
