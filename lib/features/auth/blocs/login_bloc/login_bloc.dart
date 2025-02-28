import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_event.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_state.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({
    AuthFirebase? authFirebase,
    HiveHelper? hiveHelper,
  })  : authFirebase = authFirebase ?? getIt<AuthFirebase>(),
        hiveHelper = hiveHelper ?? getIt<HiveHelper>(),
        super(LogInInitial()) {
    on<LogInRequested>(_onLoginRequested);
    on<GoogleLogInRequested>(_onGoogleLogInRequested);
  }

  final AuthFirebase authFirebase;
  final HiveHelper hiveHelper;

  Future<void> _onLoginRequested(
    LogInRequested event,
    Emitter<LogInState> emit,
  ) async {
    emit(LogInLoading());
    try {
      await authFirebase.signIn(
        event.logInModel.email,
        event.logInModel.password,
      );
      final userModel = await authFirebase.getUserByEmail(
        event.logInModel.email,
      );
      if (userModel == null) throw Exception('User not found');
      final entity = RegistrationEntity(
        name: userModel.name,
        phone: userModel.phone,
        email: userModel.email,
        joinedOn: userModel.joinedOn,
        uid: userModel.uid,
        fcmToken: userModel.fcmToken,
      );
      await hiveHelper.persistUserProfile(userProfile: entity);
      emit(LogInSuccess(entity));
    } catch (e) {
      emit(LogInFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLogInRequested(
    GoogleLogInRequested event,
    Emitter<LogInState> emit,
  ) async {
    emit(LogInLoading());
    try {
      final email = await authFirebase.signInViaGoogle();
      if (email == null) throw Exception('Google Sign-In returned no email');
      final userModel = await authFirebase.getUserByEmail(email);
      if (userModel == null) throw Exception('User account not found');
      final entity = RegistrationEntity(
        name: userModel.name,
        phone: userModel.phone,
        email: userModel.email,
        joinedOn: userModel.joinedOn,
        uid: userModel.uid,
        fcmToken: userModel.fcmToken,
      );
      await hiveHelper.persistUserProfile(userProfile: entity);
      emit(LogInSuccess(entity));
    } catch (e) {
      emit(LogInFailure(e.toString()));
    }
  }
}
