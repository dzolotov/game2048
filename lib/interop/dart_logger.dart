import 'dart:js_interop';

class DartLogger {
  @JSExport()
  void nameIsChanged(String newName) => print('Name is changed to $newName');
}