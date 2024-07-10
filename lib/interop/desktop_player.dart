class Player {
  String nickname = '';

  void setName(String name) => nickname = name;

  String greeting() => 'Hi, $nickname';
}

final _player = Player();

Player get currentPlayer => _player;