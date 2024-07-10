import 'dart:js_interop';

extension type Player(JSObject _) implements JSObject {
  external String nickname;

  external void setName(String name);

  external String greeting();
}
