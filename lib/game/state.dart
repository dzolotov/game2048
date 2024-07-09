import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../controllers/game_sound.dart';
import 'data.dart';

class GameState with ChangeNotifier {
  bool _animating = false;

  Completer _completer = Completer();

  final _focusNode = FocusNode();

  FocusNode get focusNode => _focusNode;

  int get score => grid.reduce((a, b) => a + b);

  void reset() {
    grid = List.generate(gridSize * gridSize, (_) => 0);
    place();
    place();
    notifyListeners();
  }

  List<int> grid = List.generate(gridSize * gridSize, (_) => 0);
  List<Offset> positions = List.generate(
    gridSize * gridSize,
    (i) => Offset(
      (i % gridSize).toDouble(),
      (i ~/ gridSize).toDouble(),
    ),
  );
  List<int> targetGrid = [];
  Timer? animationTimer;

  bool finished() => grid.firstWhere((e) => e == 0, orElse: () => -1) == -1;

  GameState() {
    place(); //first two 2's
    place();
  }

  int getIndex(int coord1, int coord2, bool horizontal, bool direction) {
    int normalized1 = direction ? (gridSize - 1) - coord1 : coord1;
    int normalized2 = direction ? (gridSize - 1) - coord2 : coord2;
    int row = horizontal ? normalized2 : normalized1;
    int col = horizontal ? normalized1 : normalized2;
    return row * gridSize + col;
  }

  Future<void> moveUp(GameSoundController soundController) async => shift(
      horizontal: false, direction: true, soundController: soundController);

  Future<void> moveDown(GameSoundController soundController) async => shift(
      horizontal: false, direction: false, soundController: soundController);

  Future<void> moveLeft(GameSoundController soundController) async => shift(
      horizontal: true, direction: true, soundController: soundController);

  Future<void> moveRight(GameSoundController soundController) async => shift(
      horizontal: true, direction: false, soundController: soundController);

  void _finalize() {
    animationTimer?.cancel();
    animationTimer = null;
    grid = targetGrid;
    _animating = false;
    place();
    for (int i = 0; i < gridSize * gridSize; i++) {
      positions[i] =
          Offset((i % gridSize).toDouble(), (i ~/ gridSize).toDouble());
    }
    _completer.complete();
  }

  Future<void> shift({
    required bool horizontal,
    required bool direction,
    required GameSoundController soundController,
  }) async {
    if (_animating) {
      //force complete previous animation
      _finalize();
    }
    _completer = Completer();
    targetGrid = List.of(grid);
    final Map<int, int> mutations = {};
    final doubled = <int>{};
    for (int coord1 = gridSize - 2; coord1 >= 0; coord1--) {
      for (int coord2 = 0; coord2 < gridSize; coord2++) {
        int sourceIndex = getIndex(coord1, coord2, horizontal, direction);
        if (targetGrid[sourceIndex] != 0) {
          bool moved = false;
          for (int coords = coord1 + 1; coords < gridSize; coords++) {
            int targetIndex = getIndex(coords, coord2, horizontal, direction);
            if (targetGrid[targetIndex] == targetGrid[sourceIndex] &&
                !doubled.contains(targetIndex)) {
              //double number at target position
              mutations[sourceIndex] = targetIndex;
              targetGrid[targetIndex] = 2 * targetGrid[targetIndex];
              targetGrid[sourceIndex] = 0;
              doubled.add(targetIndex);
              moved = true;
              break;
            } else if (targetGrid[targetIndex] != 0) {
              if (coords - 1 != coord1) {
                final nearIndex =
                    getIndex(coords - 1, coord2, horizontal, direction);
                mutations[sourceIndex] = nearIndex;
                targetGrid[nearIndex] = targetGrid[sourceIndex];
                targetGrid[sourceIndex] = 0;
              }
              moved = true;
              break;
            }
          }
          if (!moved) {
            int lastIndex =
                getIndex(gridSize - 1, coord2, horizontal, direction);
            mutations[sourceIndex] = lastIndex;
            targetGrid[lastIndex] = targetGrid[sourceIndex];
            targetGrid[sourceIndex] = 0;
          }
        }
      }
    }
    final movements = <int, (Offset, Offset)>{};
    for (final key in mutations.keys) {
      final source =
          Offset((key % gridSize).toDouble(), (key ~/ gridSize).toDouble());
      final k = mutations[key]!;
      final target =
          Offset((k % gridSize).toDouble(), (k ~/ gridSize).toDouble());
      movements[key] = (source, target);
    }

    if (movements.isNotEmpty) {
      soundController.moveEffect();

      _animating = true;
      animationTimer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) {
          bool isShifted = false;
          for (final key in movements.keys) {
            final (offsetStart, offsetEnd) = movements[key]!;
            if (positions[key] != offsetEnd) {
              isShifted = true;
              final shift = offsetEnd - offsetStart;

              final shiftX = shift.dx / shift.distance * 0.1;
              final shiftY = shift.dy / shift.distance * 0.1;
              positions[key] = positions[key] + Offset(shiftX, shiftY);
              if ((positions[key] - offsetEnd).distance < 0.1) {
                positions[key] = offsetEnd;
                if (doubled.contains(mutations[key])) {
                  soundController.mergeEffect();
                }
              }
            }
            notifyListeners();
          }
          if (!isShifted) {
            _finalize();
          }
        },
      );
    }
    notifyListeners();
    return _completer.future;
  }

  void place() {
    final indexes = [];
    for (final (k, v) in grid.indexed) {
      if (v == 0) indexes.add(k);
    }
    if (indexes.isEmpty) {
      return;
    }
    final rnd = indexes[Random().nextInt(indexes.length)];
    grid[rnd] = 2; //always 2
    positions[rnd] =
        Offset((rnd % gridSize).toDouble(), (rnd ~/ gridSize).toDouble());
  }
}
