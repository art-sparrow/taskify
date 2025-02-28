import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_bloc.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_bloc.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_bloc.dart';
import 'package:taskify/firebase_options.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Cross-flavor configuration

  // Initialize Firebase (Backend-as-a-Service)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Firebase initialization failed: $e');
  }

  // Restrict app to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Get It and Hive
  await setupLocator();
  try {
    await getIt<HiveHelper>().initBoxes();
  } catch (e) {
    log('Hive initialization failed: $e');
  }

  // Initialize the Blocs
  runApp(
    MultiBlocProvider(
      providers: [
        // Log in Bloc
        BlocProvider<LogInBloc>(
          create: (context) => LogInBloc(),
        ),
        // Register Bloc
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        // Reset password Bloc
        BlocProvider<ResetPwdBloc>(
          create: (context) => ResetPwdBloc(),
        ),
      ],
      child: await builder(),
    ),
  );
}
