export 'desktop/desktop_dart_logger.dart'
    if (dart.library.html) 'web/web_dart_logger.dart';
export 'desktop/desktop_impl.dart' if (dart.library.html) 'web/web_impl.dart';
export 'desktop/ui_web_stub.dart' if (dart.library.html) 'dart:ui_web';
export 'desktop/webplugins_stub.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';
