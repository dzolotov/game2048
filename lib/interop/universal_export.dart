export 'desktop_dart_logger.dart'
    if (dart.library.html) 'web_dart_logger.dart';
export 'desktop_impl.dart' if (dart.library.html) 'web_impl.dart';
export 'webplugins_stub.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';
export 'ui_web_stub.dart' if (dart.library.html) 'dart:ui_web';