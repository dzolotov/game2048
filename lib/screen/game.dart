import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
import '../game/data.dart';
import '../game/state.dart';
import '../interop/web_impl.dart';
import '../widgets/empty_slot.dart';
import '../widgets/number_slot.dart';
import 'intents/action.dart';
import 'intents/intent.dart';

class GameScreen extends HookWidget {
  const GameScreen({super.key});

  Future<void> gameOver(
    GameState state,
    BuildContext context,
  ) async {
    await showGeneralDialog(
      barrierLabel: 'Fail',
      barrierDismissible: true,
      context: context,
      pageBuilder: (context, _, __) => Dialog(
        backgroundColor: Colors.red,
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.multiply),
                  image: AssetImage('assets/fail_stamp.jpg'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final player =
        useMemoized(() => globalContext.getProperty('player'.toJS) as Player);
    final fame =
        useMemoized(() => globalContext.getProperty('fame'.toJS) as Fame);
    fame.add(player.nickname, state.score);
    state.reset();
    context.go('/fame');
  }

  @override
  Widget build(BuildContext context) {
    final gameSoundController = useMemoized(() {
      final soundController = context.read<GameSoundController>();
      soundController.ingame();
      return soundController;
    });
    final player = currentPlayer;

    final state = context.watch<GameState>();
    if (state.forceFailed) {
      Future(() {
        gameOver(state, context);
      });
    }
    return Actions(
      actions: {
        NewGameIntent: NewGameAction(state),
        DropGameIntent: DropGameAction(state),
      },
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              NewGameIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              DropGameIntent(),
        },
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Text(
                  'Hi ${player.nickname}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  //todo: add gesture detector
                  //todo: add keyboard listener with autofocus
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth =
                          constraints.maxWidth > constraints.maxHeight
                              ? constraints.maxHeight
                              : constraints.maxWidth;
                      final paddingLeft = constraints.maxWidth >
                              constraints.maxHeight
                          ? (constraints.maxWidth - constraints.maxHeight) / 2
                          : 0;
                      final paddingTop = constraints.maxHeight >
                              constraints.maxWidth
                          ? (constraints.maxHeight - constraints.maxWidth) / 2
                          : 0;
                      return Stack(
                        children: [
                          for (final (key, value) in state.grid.indexed) ...[
                            Positioned(
                              left: key % gridSize * maxWidth / gridSize +
                                  paddingLeft,
                              top: (key ~/ gridSize) * maxWidth / gridSize +
                                  paddingTop,
                              child: SizedBox.square(
                                dimension: maxWidth / gridSize,
                                child: const EmptySlot(),
                              ),
                            ),
                            if (value != 0)
                              Positioned(
                                left: state.positions[key].dx *
                                        maxWidth /
                                        gridSize +
                                    paddingLeft,
                                top: state.positions[key].dy *
                                        maxWidth /
                                        gridSize +
                                    paddingTop,
                                child: SizedBox.square(
                                  dimension: maxWidth / gridSize,
                                  child: NumberSlot(
                                    value,
                                  ),
                                ),
                              ),
                          ]
                        ],
                      );
                    },
                  ),
                ),
                Text(
                  'Score is ${state.score}, Average is ${state.average.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
