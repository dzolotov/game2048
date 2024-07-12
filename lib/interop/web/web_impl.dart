import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import '../../screen/webgl/box3d.dart';

class Player {
  String nickname = '';
  String salutation = '';

  void setName(String name) {
    nickname = name;
  }

  String greeting() => '${'Hello, $salutation'.trim()} $nickname';
}

class FameEntry {
  String player;
  int score;

  FameEntry(this.player, this.score);
}

final _player = Player();

Player get currentPlayer => _player;

final _fame = <FameEntry>[];

get fameRecords => _fame;

class Fame {
  void add(String player, int score) => _fame.add(FameEntry(player, score));

  void clear() => _fame.clear();
}

get fame => _fame;

FameEntry createEmpty() => FameEntry('', 0);

Future<int> power11() async => 2048;

Future<String> getTitle() async => "Ya ${await power11()}";

bool get confirmForceQuit =>
    web.window.confirm('Are you sure to drop the game?');

void registerIFrame(BuildContext context) {}

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

Future<void> initEnvironment() async {}

//stub implementation
String? getSetting(String key) => 'true';

setSetting(String key, String value) {}
