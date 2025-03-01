import 'package:permission_handler/permission_handler.dart';

class NotificationSettingsService {
  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Open the phone's notification settings
  static Future<void> openNotificationSettings() async {
    await openAppSettings();
  }
}
