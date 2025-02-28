import 'package:flutter/material.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/features/auth/presentation/login_screen.dart';
import 'package:taskify/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: TaskifyRouter.handleRoute,
      home: LoginScreen(),
    );
  }
}
