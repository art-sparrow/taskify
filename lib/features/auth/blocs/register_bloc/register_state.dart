import 'package:equatable/equatable.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.user);

  final RegistrationEntity user;

  @override
  List<Object> get props => [user];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
