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
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'aterik_magikav_file', 'Daily Notifications',
            channelDescription: "Daily Notification Channel",
            importance: Importance.max,
            priority: Priority.high),
        macOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      int id, String title, String body) async {
    if (!_isInitialized) {
      await iniciarNotificacion();
    }
    return await notificationsPlugin.show(id, title, body, notificationDetails());
  }
}
