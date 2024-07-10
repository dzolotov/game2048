import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game2048/controllers/game_sound.dart';
import 'package:game2048/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../interop/player.dart';

class StartScreen extends HookWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player =
        useMemoized(() => globalContext.getProperty('player'.toJS) as Player);
    useEffect(() {
      final soundController = context.read<GameSoundController>();
      soundController.background();
      return null;
    });

    return Scaffold(
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ya 2048',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: TextFormField(
                    validator: (v) {
                      if (v?.isEmpty != false) {
                        return "Name is required";
                      }
                      return null;
                    },
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Player name'),
                    onChanged: (name) => player.nickname = name,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/game');
                },
                child: const Text('1️⃣ Start'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  context.go('/manual');
                },
                child: const Text('2⃣ Manual'),
              ),
              Transform.scale(
                scaleY: -1, //flip the fire
                child: SizedBox.square(
                  dimension: 256,
                  child: Fire(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
