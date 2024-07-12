import 'notifications_plugin_platform_interface.dart';

class NotificationsPlugin {
  Future<bool?> requestPermission() =>
      NotificationsPluginPlatform.instance.requestPermission();

  Future<bool?> showNotification({
    required String title,
    required String subtitle,
    required String body,
  }) {
    return NotificationsPluginPlatform.instance.showNotification(
        title: title,
        subtitle: subtitle,
        body: body,
      );
  }
}
