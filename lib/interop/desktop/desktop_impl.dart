import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:universal_platform/universal_platform.dart';

late SharedPreferences prefs;

Future<void> initEnvironment() async {
  prefs = await SharedPreferences.getInstance();
  await PlatformNotifier.I.init(appName: '2048');
  final p = await PlatformNotifier.I.requestPermissions();
  print('Accepted is $p');
}

class FameEntry {
  String player = '';
  int score = 0;

  String asString() => "Player: $player, Score: $score";
}

class Fame {
  List<FameEntry> records = [];

  void add(String player, int score) {
    records.add(FameEntry()
      ..player = player
      ..score = score);
  }
}

final _fame = Fame();

Fame get fame => _fame;

List<FameEntry> get fameRecords => fame.records;

FameEntry createEmpty() {
  final empty = FameEntry()
    ..player = ''
    ..score = -1;
  return empty;
}

class Player {
  String nickname = '';

  void setName(String name) => nickname = name;

  String greeting() => 'Hi, $nickname';
}

final _player = Player();

Player get currentPlayer => _player;

bool get confirmForceQuit => true;

//ignore for desktop
void setPathStrategy() {}

//also ignore for desktop
void registerIFrame() {}

Future<String> getTitle() async => "Ya.Game.Desktop/Mobile 2048";

Future<void> showNotification(
    BuildContext context, String title, String body) async {
  await PlatformNotifier.I.showPluginNotification(
    ShowPluginNotificationModel(
        id: DateTime.now().second, title: title, body: body),
    context,
  );
}

void makeScreenshot(BuildContext context, GlobalKey screenshotKey) {
  const savedMessage = 'Screenshot has been saved into the clipboard';
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    final scr = screenshotKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    final image = await scr.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
    final sc = SystemClipboard.instance;
    sc?.write([
      DataWriterItem(suggestedName: 'clipboard.png')..add(Formats.png(bytes))
    ]);
    if (UniversalPlatform.isMacOS) {
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: Text(savedMessage),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(savedMessage),
        ),
      );
    }
  });
}

class GLWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

String? getSetting(String key) => prefs.getBool(key)?.toString();

void setSetting(String key, String value) =>
    prefs.setBool(key, bool.tryParse(value) ?? false);
