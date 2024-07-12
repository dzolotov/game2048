import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'notifications_plugin_method_channel.dart';

abstract class NotificationsPluginPlatform extends PlatformInterface {
  /// Constructs a NotificationsPluginPlatform.
  NotificationsPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationsPluginPlatform _instance =
      MethodChannelNotificationsPlugin();

  /// The default instance of [NotificationsPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelNotificationsPlugin].
  static NotificationsPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NotificationsPluginPlatform] when
  /// they register themselves.
  static set instance(NotificationsPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<bool?> showNotification({
    required String title,
    required String subtitle,
    required String body,
  }) {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }
}
