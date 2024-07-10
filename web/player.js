//class TopScopes {
//  constructor() {
//    this.scores = [];
//  }

//  function addScore(String player, int score) {
//    scores.add({'player': player, 'score': score});
//  }
//}

window.player = {
  "nickname": "Shmr2024",
  "setName": function(name) {
    this.nickname = name;
    window.logger.nameIsChanged(name);
  },
  "greeting": function() {
    return "Mr "+this.nickname;
  }
}

window.fame = {
  "records": [],
  "add": function(player, score) {
    this.records.push({'player': player, 'score': score});
  }
}

//class Player {
//  String nickname;
//  constructor(String nickname) {
//    this.nickname = nickname;
//  }
//}

//console.log('WINDOW');
//window.player = Player('shmr2024');
//window.scores = TopScores();
