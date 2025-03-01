import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/core/widgets/menu_option.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';
import 'package:taskify/features/profile/blocs/logout_bloc/logout_bloc.dart';
import 'package:taskify/features/profile/blocs/logout_bloc/logout_event.dart';
import 'package:taskify/features/profile/blocs/logout_bloc/logout_state.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final RegistrationEntity? user;

  @override
  void initState() {
    super.initState();
    // Fetch user
    user = getIt<HiveHelper>().retrieveUserProfile();
  }

  void _logOut() {
    // Trigger sign out event
    context.read<LogoutBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
      ),
    );

    // Access the current theme state directly
    final isDarkTheme =
        BlocProvider.of<ThemeBloc>(context).state.themeData.brightness ==
            Brightness.dark;

    // Define gradient
    final linearGradient = const LinearGradient(
      colors: <Color>[AppColors.primaryLight, AppColors.primary],
    ).createShader(const Rect.fromLTWH(0, 0, 200, 70));

    return Scaffold(
      body: BlocConsumer<LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushReplacementNamed(
              context,
              TaskifyRouter.logInScreenRoute,
            );
          }
          if (state is LogoutFailure) {
            ErrorMessage.show(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                            user?.name ?? 'Username',
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
                        MenuOption(
                          title: 'Change theme',
                          leadingIcon: Icon(
                            isDarkTheme
                                ? LineAwesomeIcons.moon_solid
                                : LineAwesomeIcons.lightbulb,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailingIcon: Icon(
                            LineAwesomeIcons.angle_right_solid,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailing: true,
                          onTap: state is LogoutLoading
                              ? () {}
                              : () async {
                                  await Navigator.pushNamed(
                                    context,
                                    TaskifyRouter.changeThemeScreenRoute,
                                  );
                                },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //notifications
                        MenuOption(
                          title: 'Notifications',
                          leadingIcon: Icon(
                            LineAwesomeIcons.bell_solid,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailingIcon: Icon(
                            LineAwesomeIcons.angle_right_solid,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailing: true,
                          onTap: state is LogoutLoading
                              ? () {}
                              : () async {
                                  await Navigator.pushNamed(
                                    context,
                                    TaskifyRouter.notificationsScreenRoute,
                                  );
                                },
                        ),
                        /* const SizedBox(
                          height: 20,
                        ), */
                        //logout
                        MenuOption(
                          title: 'Log out',
                          leadingIcon: Icon(
                            LineAwesomeIcons.sign_out_alt_solid,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailingIcon: Icon(
                            LineAwesomeIcons.angle_right_solid,
                            color: isDarkTheme
                                ? AppColors.white
                                : AppColors.greyDark,
                          ),
                          trailing: false,
                          isLoading: state is LogoutLoading,
                          onTap: state is LogoutLoading ? () {} : _logOut,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
