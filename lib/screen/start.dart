import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game2048/screen/shader/fire.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
// import 'dart:js_interop';
// import 'dart:js_interop_unsafe';
import '../interop/universal_export.dart';

// import '../interop/web_impl.dart';
// import 'webgl/box3d.dart';

class StartScreen extends HookWidget {
  final GlobalKey screenshotKey = GlobalKey();

  final GlobalKey<TooltipState> webglTooltipKey = GlobalKey();
  final GlobalKey<TooltipState> externalImageKey = GlobalKey();
  final GlobalKey<TooltipState> wasmEvaluationKey = GlobalKey();
  final GlobalKey<TooltipState> fragmentShaderKey = GlobalKey();

  StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = useMemoized(getTitle);
    // final player =
    //     useMemoized(() => globalContext.getProperty('player'.toJS) as Player);
    final player = currentPlayer;
    useEffect(() {
      final soundController = context.read<GameSoundController>();
      soundController.menuMusic();
      return null;
    });

    return RepaintBoundary(
      key: screenshotKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    key: externalImageKey,
                    message: 'External image demo',
                    child: SizedBox(
                      width: 64,
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/1/1a/2048_Icon.png',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Tooltip(
                    key: webglTooltipKey,
                    message: 'WebGL demo',
                    child: GLWidget(),
                  ),
                  Tooltip(
                    key: wasmEvaluationKey,
                    message: 'Rust Wasm evaluation demo',
                    child: FutureBuilder(
                      future: title,
                      builder: (context, snapshot) => Text(
                        snapshot.data ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
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
                        decoration:
                            const InputDecoration(hintText: 'Player name'),
                        onChanged: (name) => player.setName(name),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/game'),
                    child: const Text('1️⃣ Start'),
                    // child: const Text('Start'),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => context.push('/manual'),
                    child: const Text('2⃣ Manual'),
                    // child: const Text('Manual'),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => context.go('/fame'),
                    child: const Text('Hall of Fame'),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => makeScreenshot(context, screenshotKey),
                    child: const Text('Make screenshot'),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => context.push('/settings'),
                    child: const Text('Settings'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //todo: add fragment shader (fire)
                  Tooltip(
                    key: fragmentShaderKey,
                    message: 'Fragment shader animation demo',
                    child: Transform.scale(
                      scaleY: -1, //flip the fire
                      child: SizedBox.square(
                        dimension: 256,
                        child: Fire(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
