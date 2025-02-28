import 'package:equatable/equatable.dart';

class ResetPwdEntity extends Equatable {
  const ResetPwdEntity({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}
