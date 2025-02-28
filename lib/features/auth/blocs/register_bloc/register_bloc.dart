import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_event.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_state.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    AuthFirebase? authFirebase,
    HiveHelper? hiveHelper,
  })  : authFirebase = authFirebase ?? getIt<AuthFirebase>(),
        hiveHelper = hiveHelper ?? getIt<HiveHelper>(),
        super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  final AuthFirebase authFirebase;
  final HiveHelper hiveHelper;

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      // Create Firebase Auth user
      final uid = await authFirebase.signUp(
        event.registerModel.email,
        event.registerModel.password,
      );

      // Complete the model with additional data
      final updatedModel = await authFirebase.completeSignUpModel(
        event.registerModel.copyWith(uid: uid),
      );

      // Save to Firestore
      await authFirebase.saveUserData(updatedModel);

      // Convert to entity and store in Hive
      final entity = RegistrationEntity(
        name: updatedModel.name,
        phone: updatedModel.phone,
        email: updatedModel.email,
        joinedOn: updatedModel.joinedOn,
        uid: updatedModel.uid,
        fcmToken: updatedModel.fcmToken,
      );
      await hiveHelper.persistUserProfile(userProfile: entity);

      emit(RegisterSuccess(entity));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
