import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class DartLogger {
  @JSExport()
  void nameIsChanged(String newName) => print('Name is changed to $newName');
}

void setDartLogger() {
  globalContext.setProperty(
    'logger'.toJS,
    createJSInteropWrapper(
      DartLogger(),
    ),
  );
}