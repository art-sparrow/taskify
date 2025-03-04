import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskify/features/auth/presentation/login_screen.dart';
import 'package:taskify/features/auth/presentation/register_screen.dart';
import 'package:taskify/features/auth/presentation/reset_pwd_screen.dart';
import 'package:taskify/features/decision/presentation/decision_screen.dart';
import 'package:taskify/features/landing/presentation/landing_screen.dart';
import 'package:taskify/features/profile/presentation/change_theme_screen.dart';
import 'package:taskify/features/profile/presentation/notification_settings_screen.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';
import 'package:taskify/features/task/presentation/task_details_screen.dart';

class TaskifyRouter {
  static const String changeThemeScreenRoute = 'changeTheme-screen';
  static const String decisionScreenRoute = 'decision-screen';
  static const String landingScreenRoute = 'landing-screen';
  static const String logInScreenRoute = 'logIn-screen';
  static const String notificationsScreenRoute = 'notifications-screen';
  static const String registerScreenRoute = 'register-screen';
  static const String resetPwdScreenRoute = 'resetPwd-screen';
  static const String taskDetailsScreenRoute = 'taskDetails-screen';

  static Route<dynamic>? handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case changeThemeScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ChangeThemeScreen(),
        );
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
      case notificationsScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const NotificationSettingsScreen(),
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
      case taskDetailsScreenRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        final task = args?['task'] as Task?;
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: TaskDetailScreen(
            task: task,
          ),
          settings: settings,
        );
    }
    return null;
  }
}
