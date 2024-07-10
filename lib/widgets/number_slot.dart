import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../theme/data.dart';

class NumberSlot extends HookWidget {
  final int number;

  const NumberSlot(
    this.number, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(
      duration: const Duration(seconds: 1),
    );
    final selected = useState(false);
    useEffect(() {
      listener() {
        if (selected.value) {
          animation.forward();
          animation.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animation.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animation.forward();
            }
          });
        } else {
          animation.reset();
          animation.stop();
        }
      }

      selected.addListener(listener);
      return () => selected.removeListener(listener);
    }, const []);
    int colorIndex = (log(number) * log2e).roundToDouble().toInt() - 1;
    if (colorIndex >= colors.length) {
      colorIndex = colors.length - 1;
    }
    final p = number.toString();
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        decoration: const BoxDecoration(color: Colors.white),
        foregroundDecoration: BoxDecoration(color: colors[colorIndex]),
        margin: EdgeInsets.all(8.0 - 6 * animation.value),
        child: Center(
          child: Text(
            p,
            style: TextStyle(
              fontSize: fontSizes[p.length - 1].toDouble(),
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
