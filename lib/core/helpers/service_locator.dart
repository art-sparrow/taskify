import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';
import 'package:taskify/features/profile/blocs/theme_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  getIt
    // SharedPreferences
    ..registerSingleton<SharedPreferences>(prefs)
    // Hive
    ..registerSingleton<HiveHelper>(HiveHelperImplementation())
    // AuthFirebase
    ..registerSingleton<AuthFirebase>(
      AuthFirebase(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    )
    // Themes
    ..registerSingleton<ThemeBloc>(
      ThemeBloc(sharedPreferences: getIt<SharedPreferences>()),
    );
}
