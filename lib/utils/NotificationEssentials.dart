import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificationessentials {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Inicializar servicio de notificaciones
  Future<void> iniciarNotificacion() async {
      if (_isInitialized) return;

      //Preparar ajustes de android
      const androidSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");

      const initSettings = InitializationSettings(
          android: androidSettings, macOS: DarwinInitializationSettings());

      await notificationsPlugin.initialize(initSettings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily Notifications',
            channelDescription: "Daily Notification Channel",
            importance: Importance.max,
            priority: Priority.high),
        macOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(id, title, body, NotificationDetails());
  }
}