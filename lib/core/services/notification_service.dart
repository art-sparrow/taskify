import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._internal();
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  // Flutter Local Notifications plugin instance
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    // Add custom notification icon to 'res/drawable/logo.png'
    const androidSettings = AndroidInitializationSettings('logo');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
    );

    // Request notification permissions for Android 13+ and iOS
    await _requestNotificationPermission();
  }

  // Request notification permissions
  Future<void> _requestNotificationPermission() async {
    // Android 13+ permissions
    if (await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false) {
      // Permissions already granted
      return;
    }

    // For iOS, request permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // Show a notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String message,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sync_channel', // Channel ID
      'Sync Notifications', // Channel name
      channelDescription: 'Notifications about data sync status',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iosDetails = DarwinNotificationDetails(presentSound: false);

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id, // Notification ID
      title, // Notification title
      message, // Notification body
      notificationDetails,
      payload: payload,
    );
  }

  // Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
