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
