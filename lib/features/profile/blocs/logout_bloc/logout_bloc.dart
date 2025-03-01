import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';
import 'package:taskify/features/profile/blocs/logout_bloc/logout_event.dart';
import 'package:taskify/features/profile/blocs/logout_bloc/logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({
    AuthFirebase? authFirebase,
    HiveHelper? hiveHelper,
  })  : authFirebase = authFirebase ?? getIt<AuthFirebase>(),
        hiveHelper = hiveHelper ?? getIt<HiveHelper>(),
        super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthFirebase authFirebase;
  final HiveHelper hiveHelper;

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      await authFirebase.signOut();
      await hiveHelper.clearHiveDB();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
