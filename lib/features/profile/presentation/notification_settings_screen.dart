import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/services/notification_settings_service.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/widgets/custom_toggle.dart';
import 'package:taskify/core/widgets/selection_tile.dart';
import 'package:taskify/core/widgets/success_message.dart';
import 'package:taskify/features/profile/blocs/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_state.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _areNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final enabled = await NotificationSettingsService.areNotificationsEnabled();
    setState(() {
      _areNotificationsEnabled = enabled;
    });
  }

  Future<void> _openSettings() async {
    Navigator.of(context).pop();
    await NotificationSettingsService.openNotificationSettings();
    // Re-check status after returning from settings
    await _checkNotificationStatus();
  }

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
                  // Notifications
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Enable toggle
                  SelectionTile(
                    onTap: _areNotificationsEnabled
                        ? () {
                            SuccessMessage.show(
                              context,
                              'Notifications are enabled',
                            );
                            Navigator.of(context).pop();
                          }
                        : _openSettings,
                    icon: Icon(
                      _areNotificationsEnabled
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: _areNotificationsEnabled,
                      onTap: _areNotificationsEnabled
                          ? () {
                              SuccessMessage.show(
                                context,
                                'Notifications are enabled',
                              );
                              Navigator.of(context).pop();
                            }
                          : _openSettings,
                    ),
                    title: Text(
                      'Enable',
                      style: state.themeData.textTheme.titleMedium,
                    ),
                    showCustomIcon: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Disable toggle
                  SelectionTile(
                    onTap: !_areNotificationsEnabled
                        ? () {
                            SuccessMessage.show(
                              context,
                              'Notifications are disabled',
                            );
                            Navigator.of(context).pop();
                          }
                        : _openSettings,
                    icon: Icon(
                      !_areNotificationsEnabled
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: !_areNotificationsEnabled,
                      onTap: !_areNotificationsEnabled
                          ? () {
                              SuccessMessage.show(
                                context,
                                'Notifications are disabled',
                              );
                              Navigator.of(context).pop();
                            }
                          : _openSettings,
                    ),
                    title: Text(
                      'Disable',
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
