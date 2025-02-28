import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  const RegisterEntity({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.joinedOn,
    required this.uid,
    required this.fcmToken,
  });

  final String name;
  final String phone;
  final String email;
  final String password;
  final String joinedOn;
  final String uid;
  final String fcmToken;

  @override
  List<Object?> get props => [name, phone, email, password];
}
