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
