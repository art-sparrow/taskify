import 'package:equatable/equatable.dart';
import 'package:taskify/features/auth/data/models/reset_pwd_model.dart';

abstract class ResetPwdEvent extends Equatable {
  const ResetPwdEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordRequested extends ResetPwdEvent {
  const ResetPasswordRequested(this.resetPwdModel);

  final ResetPwdModel resetPwdModel;

  @override
  List<Object> get props => [resetPwdModel];
}
