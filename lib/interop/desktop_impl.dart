// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

void registerIFrame() {}

Future<void> showNotification(int id, String title, String body) async {
  //now only MacOS is supported
  // final notificationDetails =
  //     NotificationDetails(macOS: DarwinNotificationDetails());
  // final plugin = FlutterLocalNotificationsPlugin();
  // await plugin.show(id, title, body, notificationDetails);
}
