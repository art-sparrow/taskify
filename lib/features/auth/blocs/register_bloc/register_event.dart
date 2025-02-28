import 'package:equatable/equatable.dart';
import 'package:taskify/features/auth/data/models/register_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  const RegisterRequested(this.registerModel);

  final RegisterModel registerModel;

  @override
  List<Object> get props => [registerModel];
}
