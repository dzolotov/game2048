
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../main.dart';

class Fire extends StatefulWidget {
  @override
  State<Fire> createState() => _FireState();
}

class _FireState extends State<Fire> with SingleTickerProviderStateMixin {
  double time = 0.0;
  Ticker? ticker;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((t) {
      setState(() {
        time = t.inMilliseconds / 1000.0;
      });
    });
    ticker?.start();
  }

  @override
  void dispose() {
    ticker?.stop();
    ticker?.dispose();
    ticker = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShaderView(time),
      size: const Size.square(128),
    );
  }
}

class ShaderView extends CustomPainter {
  double time;

  ShaderView(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final shader = fireProgram.fragmentShader();
    shader.setFloat(0, time); //time
    shader.setFloat(1, size.width); //rect
    shader.setFloat(2, size.height);
    shader.setFloat(3, 0); //mouse
    shader.setFloat(4, 0);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
