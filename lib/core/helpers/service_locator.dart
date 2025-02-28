import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/features/auth/data/datasources/auth_firebase.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt
    // Hive
    ..registerSingleton<HiveHelper>(HiveHelperImplementation())
    // AuthFirebase
    ..registerSingleton<AuthFirebase>(
      AuthFirebase(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );
}
