import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/widgets/custom_toggle.dart';
import 'package:taskify/core/widgets/selection_tile.dart';
import 'package:taskify/core/widgets/success_message.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_event.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_state.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: const Icon(
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          // Determine current theme states
          final isDarkTheme = state.themeData.brightness == Brightness.dark;
          final isDeviceTheme = state.isDeviceTheme;
          final isLightTheme = !isDarkTheme && !isDeviceTheme;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme options
                  Text(
                    'Change theme',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Light theme toggle
                  SelectionTile(
                    onTap: () {
                      if (!isLightTheme) {
                        context.read<ThemeBloc>().add(SwitchToLightTheme());
                        SuccessMessage.show(
                          context,
                          'Switched to light theme!',
                        );
                      }
                    },
                    icon: Icon(
                      isDeviceTheme
                          ? Icons.circle_outlined
                          : isDarkTheme
                              ? Icons.circle_outlined
                              : Icons.check_circle,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: isLightTheme,
                      onTap: () {
                        if (!isLightTheme) {
                          context.read<ThemeBloc>().add(SwitchToLightTheme());
                          SuccessMessage.show(
                            context,
                            'Switched to light theme!',
                          );
                        }
                      },
                    ),
                    title: Text(
                      'Light mode',
                      style: state.themeData.textTheme.titleMedium,
                    ),
                    showCustomIcon: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Dark theme toggle
                  SelectionTile(
                    onTap: () {
                      if (!isDarkTheme) {
                        context.read<ThemeBloc>().add(SwitchToDarkTheme());
                        SuccessMessage.show(context, 'Switched to dark theme!');
                      }
                    },
                    icon: Icon(
                      isDeviceTheme
                          ? Icons.circle_outlined
                          : isDarkTheme
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: isDarkTheme && !isDeviceTheme,
                      onTap: () {
                        if (!isDarkTheme) {
                          context.read<ThemeBloc>().add(SwitchToDarkTheme());
                          SuccessMessage.show(
                            context,
                            'Switched to dark theme!',
                          );
                        }
                      },
                    ),
                    title: Text(
                      'Dark mode',
                      style: state.themeData.textTheme.titleMedium,
                    ),
                    showCustomIcon: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Device theme toggle
                  SelectionTile(
                    onTap: () {
                      if (!isDeviceTheme) {
                        context.read<ThemeBloc>().add(SwitchToDeviceTheme());
                        SuccessMessage.show(
                          context,
                          'Switched to device theme!',
                        );
                      }
                    },
                    icon: Icon(
                      isDeviceTheme
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: isDeviceTheme,
                      onTap: () {
                        if (!isDeviceTheme) {
                          context.read<ThemeBloc>().add(SwitchToDeviceTheme());
                          SuccessMessage.show(
                            context,
                            'Switched to device theme!',
                          );
                        }
                      },
                    ),
                    title: Text(
                      'Device theme',
                      style: state.themeData.textTheme.titleMedium,
                    ),
                    showCustomIcon: true,
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
