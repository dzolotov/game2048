window.player = {
  "nickname": "Shmr2024",
  "salutation": "",
  "setName": function(name) {
    this.nickname = name;
    window.logger.nameIsChanged(name);
  },
}

window.fame = {
  "records": [],
  "add": function(player, score) {
    this.records.push({'player': player, 'score': score});
  }
}
