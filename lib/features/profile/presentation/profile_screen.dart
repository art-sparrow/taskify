import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/menu_option.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';
import 'package:taskify/features/profile/blocs/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Fetch user from Hive using Service Locator
  late final RegistrationEntity? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
      ),
    );

    // Define gradient
    final linearGradient = const LinearGradient(
      colors: <Color>[AppColors.primaryLight, AppColors.primary],
    ).createShader(const Rect.fromLTWH(0, 0, 200, 70));

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 50,
                  bottom: 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //profile picture
                    const CircleAvatar(
                      backgroundColor: AppColors.transparent,
                      radius: 40,
                      backgroundImage: AssetImage(
                        AssetsPath.profilePicture,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //username
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Username',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    //menus
                    const SizedBox(
                      height: 60,
                    ),
                    //theme selection
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) {
                        // Switch icon based on the theme
                        final isDarkTheme =
                            state.themeData.brightness == Brightness.dark;
                        return MenuOption(
                          title: 'Change theme',
                          leadingIcon: Icon(
                            isDarkTheme
                                ? LineAwesomeIcons.moon_solid
                                : LineAwesomeIcons.lightbulb,
                            color: AppColors.primary,
                          ),
                          trailingIcon: const Icon(
                            LineAwesomeIcons.angle_right_solid,
                            color: AppColors.primary,
                          ),
                          trailing: true,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              TaskifyRouter.changeThemeScreenRoute,
                            );
                          },
                        );
                      },
                    ),
                    /* const SizedBox(
                      height: 20,
                    ), */
                    //notifications
                    /* MenuOption(
                      title: 'Notifications',
                      leadingIcon: const Icon(
                        LineAwesomeIcons.bell_solid,
                        color: AppColors.primaryColor,
                      ),
                      trailingIcon: const Icon(
                        LineAwesomeIcons.angle_right_solid,
                        color: AppColors.primaryColor,
                      ),
                      trailing: true,
                      onTap: state is LogOutLoading
                          ? () {}
                          : () async {
                              await Navigator.pushNamed(
                                context,
                                TaskifyRouter.notificationsScreenRoute,
                              );
                            },
                    ), */
                    /* const SizedBox(
                      height: 20,
                    ), */
                    //logout
                    /* MenuOption(
                      title: 'Log out',
                      leadingIcon: const Icon(
                        LineAwesomeIcons.sign_out_alt_solid,
                        color: AppColors.primaryColor,
                      ),
                      trailingIcon: const Icon(
                        LineAwesomeIcons.angle_right_solid,
                        color: AppColors.primaryColor,
                      ),
                      trailing: false,
                      isLoading: state is LogOutLoading,
                      onTap: state is LogOutLoading ? () {} : _logOut,
                    ), */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
