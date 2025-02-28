import 'package:equatable/equatable.dart';
import 'package:taskify/features/auth/data/models/login_model.dart';

abstract class LogInEvent extends Equatable {
  const LogInEvent();

  @override
  List<Object> get props => [];
}

class LogInRequested extends LogInEvent {
  const LogInRequested(this.logInModel);

  final LogInModel logInModel;

  @override
  List<Object> get props => [logInModel];
}

class GoogleLogInRequested extends LogInEvent {}
