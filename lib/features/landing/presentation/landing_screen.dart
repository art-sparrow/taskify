import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/profile/presentation/profile_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Widget> pages = [
    // Dashboard
    const ProfileScreen(),
    // Tasks
    const ProfileScreen(),
    // Profile
    const ProfileScreen(),
  ];

  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    // Show navbar and status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme state directly
    final isDarkTheme =
        BlocProvider.of<ThemeBloc>(context).state.themeData.brightness ==
            Brightness.dark;
    return Scaffold(
      body: IndexedStack(
        index: selectedPage,
        children: pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 5,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedPage,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          backgroundColor: isDarkTheme ? AppColors.black : AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.greyDark,
          selectedLabelStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            color: AppColors.greyDark,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.home_solid),
              activeIcon: Icon(LineAwesomeIcons.home_solid),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.tasks_solid),
              activeIcon: Icon(LineAwesomeIcons.tasks_solid),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.user_cog_solid),
              activeIcon: Icon(LineAwesomeIcons.user_cog_solid),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
