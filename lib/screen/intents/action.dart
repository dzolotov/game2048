import 'package:flutter/material.dart';
import 'package:web/web.dart';

import '../../game/state.dart';
import 'intent.dart';

class NewGameAction extends Action<NewGameIntent> {
  GameState state;

  NewGameAction(this.state);

  @override
  Object? invoke(NewGameIntent intent) {
    state.reset();
    return null;
  }
}

class DropGameAction extends Action<DropGameIntent> {
  GameState state;

  DropGameAction(this.state);

  @override
  Object? invoke(DropGameIntent intent) {
    final result = window.confirm('Are you sure to drop the game?');
    if (result) {
      state.fail();
    }
    return null;
  }
}
