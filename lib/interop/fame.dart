import 'dart:js_interop';
import 'dart:js_interop_unsafe';

extension type FameEntry(JSObject _) implements JSObject {
  external String player;
  external int score;

  String asString() => "Player: $player, Score: $score";
}

extension type Fame(JSObject _) implements JSObject {
  external JSArray<FameEntry> records;

  external void add(String player, int score);
}

Fame get fame => globalContext.getProperty('fame'.toJS) as Fame;

List<FameEntry> get fameRecords => fame.records.toDart;