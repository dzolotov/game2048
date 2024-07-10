import 'dart:js_interop';

extension type FameEntry(JSObject _) implements JSObject {
  external String player;
  external int score;

  @override
  String asString() {
    return "Player: $player, Score: $score";
  }
}

extension type Fame(JSObject _) implements JSObject {
  external JSArray<FameEntry> records;

  external void add(String player, int score);
}
