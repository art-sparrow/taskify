import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskify/features/auth/presentation/login_screen.dart';
import 'package:taskify/features/auth/presentation/register_screen.dart';
import 'package:taskify/features/auth/presentation/reset_pwd_screen.dart';
import 'package:taskify/features/decision/presentation/decision_screen.dart';
import 'package:taskify/features/landing/presentation/landing_screen.dart';

class TaskifyRouter {
  static const String decisionScreenRoute = 'decision-screen';
  static const String landingScreenRoute = 'landing-screen';
  static const String logInScreenRoute = 'logIn-screen';
  static const String registerScreenRoute = 'register-screen';
  static const String resetPwdScreenRoute = 'resetPwd-screen';

  static Route<dynamic>? handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case decisionScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const DecisionScreen(),
        );
      case landingScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LandingScreen(),
        );
      case logInScreenRoute:
        return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginScreen(),
        );
      case registerScreenRoute:
        return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const RegisterScreen(),
        );
      case resetPwdScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ResetPwdScreen(),
        );
    }
    return null;
  }
}
