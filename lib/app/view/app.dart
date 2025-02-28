import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/features/decision/presentation/decision_screen.dart';
import 'package:taskify/features/profile/blocs/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_state.dart';
import 'package:taskify/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: state.themeData,
          onGenerateRoute: TaskifyRouter.handleRoute,
          home: const DecisionScreen(),
        );
      },
    );
  }
}
