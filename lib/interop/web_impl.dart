import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart';

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

FameEntry createEmpty() {
  final entry = JSObject() as FameEntry;
  entry.player = '';
  entry.score = -1;
  return entry;
}

extension type Player(JSObject _) implements JSObject {
  external String nickname;

  external void setName(String name);

  external String greeting();
}

Player get currentPlayer => globalContext.getProperty('player'.toJS) as Player;

bool get confirmForceQuit => window.confirm('Are you sure to drop the game?');

void registerIFrame() {
  ui_web.PlatformViewRegistry().registerViewFactory(
    'manual',
    (_) {
      return HTMLIFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = 'https://ru.wikipedia.org/wiki/2048_(игра)';
    },
  );
}

Future<void> showNotification(int id, String title, String body) async {}
