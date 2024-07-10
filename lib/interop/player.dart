import 'dart:js_interop';
import 'dart:js_interop_unsafe';

extension type Player(JSObject _) implements JSObject {
  external String nickname;

  external void setName(String name);

  external String greeting();
}

Player get currentPlayer => globalContext.getProperty('player'.toJS) as Player;