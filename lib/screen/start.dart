import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
import '../interop/web_impl.dart';

class StartScreen extends HookWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final player = currentPlayer;
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
                    onChanged: (name) => player.setName(name),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => context.go('/game'),
                // child: const Text('1️⃣ Start'),
                child: const Text('Start'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () => context.push('/manual'),
                // child: const Text('2⃣ Manual'),
                child: const Text('Manual'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () => context.go('/fame'),
                child: const Text('Hall of Fame'),
              ),
              const SizedBox(
                height: 16,
              ),
              //todo: add fragment shader (fire)
            ],
          ),
        ),
      ),
    );
  }
}
