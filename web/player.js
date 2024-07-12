window.player = {
  "nickname": "Shmr2024",
  "salutation": "",
  "setName": function(name) {
    this.nickname = name;
    window.logger.nameIsChanged(name);
  },
  "greeting": function() {
    return ('Hi '+this.salutation).trim()+' '+this.nickname;
  }
}

window.fame = {
  "records": [],
  "add": function(player, score) {
    this.records.push({'player': player, 'score': score});
  },
  "clear": function() {
    this.records = [];
  }
}
