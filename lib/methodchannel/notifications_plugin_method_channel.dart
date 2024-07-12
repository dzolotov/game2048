import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'notifications_plugin_platform_interface.dart';

/// An implementation of [NotificationsPluginPlatform] that uses method channels.
class MethodChannelNotificationsPlugin extends NotificationsPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('notifications_plugin');

  @override
  Future<bool?> requestPermission() async {
    return methodChannel.invokeMethod<bool>('requestPermission');
  }

  @override
  Future<bool?> showNotification({
    required String title,
    required String subtitle,
    required String body,
  }) async {
    return methodChannel.invokeMethod<bool>('showNotification', {
      'title': title,
      'subtitle': subtitle,
      'body': body,
    });
  }
}
