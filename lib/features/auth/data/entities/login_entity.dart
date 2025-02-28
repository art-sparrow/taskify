import 'package:equatable/equatable.dart';

class LogInEntity extends Equatable {
  const LogInEntity({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
