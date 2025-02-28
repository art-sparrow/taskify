import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_event.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_state.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';

class ResetPwdBloc extends Bloc<ResetPwdEvent, ResetPwdState> {
  ResetPwdBloc({
    AuthFirebase? authFirebase,
  })  : authFirebase = authFirebase ?? getIt<AuthFirebase>(),
        super(ResetPwdInitial()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final AuthFirebase authFirebase;

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ResetPwdState> emit,
  ) async {
    emit(ResetPwdLoading());
    try {
      await authFirebase.resetPassword(event.resetPwdModel.email);
      emit(ResetPwdSuccess());
    } catch (e) {
      emit(ResetPwdFailure(e.toString()));
    }
  }
}
