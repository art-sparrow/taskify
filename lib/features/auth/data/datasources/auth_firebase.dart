import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:taskify/features/auth/data/models/register_model.dart';

class AuthFirebase {
  AuthFirebase({
    required this.firebaseAuth,
    required this.firestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  Future<void> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('Sign in failed: $e');
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('Sign out failed: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  Future<String?> signInViaGoogle() async {
    try {
      // Start interactive sign-in process
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        log('Google sign-in canceled by user.');
        throw Exception('Google sign-in canceled by user');
      }

      // Capture authentication details from the Google sign-in process
      final googleAuth = await googleUser.authentication;

      // Create user credential for Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Capture user's email
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final email = userCredential.user?.email;
      if (email == null) throw Exception('No email from Google sign-in');

      // Exit if the user lacks a firestore entry
      final userModel = await getUserByEmail(email);
      if (userModel == null) {
        throw Exception('User not registered. Please sign up first.');
      }

      // Existing user: return email
      return email;
    } catch (e) {
      log('Google sign-in failed: $e');
      throw Exception('Google sign-in failed: $e');
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user!.uid;
    } catch (e) {
      log('Error signing up user: $e');
      throw Exception(
        'Failed to sign up user. Please try again later.',
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('Failed to send password reset email: $e');
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<RegisterModel?> getUserByEmail(String email) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final data = snapshot.docs.first.data();
      return RegisterModel.fromJson(data);
    } catch (e) {
      log('Error fetching user by email: $e');
      throw Exception('Failed to fetch user details. Please try again later.');
    }
  }

  Future<RegisterModel> completeSignUpModel(RegisterModel model) async {
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final joinedOn = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return model.copyWith(
      fcmToken: fcmToken,
      joinedOn: joinedOn,
      password: '',
    );
  }

  Future<void> saveUserData(RegisterModel model) async {
    try {
      await firestore.collection('users').doc(model.uid).set(model.toJson());
    } catch (e) {
      log('Error fetching user by email: $e');
      throw Exception('Failed to fetch user details. Please try again later.');
    }
  }
}
