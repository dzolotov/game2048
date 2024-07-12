import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

class DartLogger {
  @JSExport()
  void nameIsChanged(String newName) => debugPrint('Name is changed to $newName');
}

void setDartLogger() {
  globalContext.setProperty(
    'logger'.toJS,
    createJSInteropWrapper(
      DartLogger(),
    ),
  );
}