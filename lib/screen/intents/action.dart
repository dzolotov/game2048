import 'package:flutter/material.dart';
import '../../interop/desktop_impl.dart';

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
    if (confirmForceQuit) {
      state.fail();
    }
    return null;
  }
}
