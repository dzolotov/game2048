import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui';
import 'dart:ui_web' as ui_web;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;
import '../../screen/webgl/box3d.dart';

extension type FameEntry(JSObject _) implements JSObject {
  external String player;
  external int score;
}

extension type Fame(JSObject _) implements JSObject {
  external JSArray<FameEntry> records;

  external void add(String player, int score);

  external void clear();
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

  external String salutation;

  external void setName(String name);

  external String greeting();
}

// Future<int> power11() async => 2048;
// Future<int> power11() async {
// final wasm =
//     await instantiateStreaming(fetch('assets/assets/wasm_bg.wasm'), JSObject())
//         .toDart;
// return wasm.instance.exports.power(11);
// }
@JS('power')
external int wasmPower(int n);

@JS('getTitle')
external String title(String str);

Future<int> power11() async => wasmPower(11);

// Future<String> getTitle() async => "Ya ${await power11()}";
Future<String> getTitle() async => title((await power11()).toString());

Player get currentPlayer => globalContext.getProperty('player'.toJS) as Player;

bool get confirmForceQuit => web.window.confirm('Are you sure to drop the game?');

void registerIFrame() {
  ui_web.PlatformViewRegistry().registerViewFactory(
    'manual',
    (_) {
      return web.HTMLIFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = 'https://ru.wikipedia.org/wiki/2048_(игра)';
    },
  );
}

void makeScreenshot(BuildContext context, GlobalKey screenshotKey) {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    final scr = screenshotKey.currentContext?.findRenderObject()
    as RenderRepaintBoundary;
    final image = await scr.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
    final a = web.document.createElement('a') as web.HTMLAnchorElement;
    a.href = 'data:image/png;base64,${base64Encode(bytes)}';
    a.download = 'screenshot.png';
    a.click();
  });
}

class GLWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Box3D();
}

void setPathStrategy() => setUrlStrategy(PathUrlStrategy());

final localSettings = web.window.localStorage;

String? getSetting(String key) => localSettings.getItem(key);

void setSetting(String key, String value) => localSettings.setItem(key, value);

Future<void> initEnvironment() async {}
