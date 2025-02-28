import 'package:equatable/equatable.dart';

abstract class ResetPwdState extends Equatable {
  const ResetPwdState();

  @override
  List<Object> get props => [];
}

class ResetPwdInitial extends ResetPwdState {}

class ResetPwdLoading extends ResetPwdState {}

class ResetPwdSuccess extends ResetPwdState {}

class ResetPwdFailure extends ResetPwdState {
  const ResetPwdFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
