import 'package:equatable/equatable.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';

abstract class LogInState extends Equatable {
  const LogInState();

  @override
  List<Object> get props => [];
}

class LogInInitial extends LogInState {}

class LogInLoading extends LogInState {}

class LogInSuccess extends LogInState {
  const LogInSuccess(this.user);
  final RegistrationEntity user;
  @override
  List<Object> get props => [user];
}

class LogInFailure extends LogInState {
  const LogInFailure(this.errorMessage);
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
