import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
import '../interop/universal_export.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundMusic = useState(getSetting('background') != 'false');
    final soundEffects = useState(getSetting('effects') != 'false');
    final soundController = context.read<GameSoundController>();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Settings',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: 'Roboto'),
            ),
            const Divider(
              thickness: 0,
              height: 32,
            ),
            ListTile(
              title: const Text('Background music'),
              trailing: Switch.adaptive(
                value: backgroundMusic.value,
                onChanged: (v) {
                  setSetting('background', v.toString());
                  backgroundMusic.value = v;
                  soundController.setBackgroundMusicEnabled(v);
                  if (v) {
                    soundController.menuMusic();
                  } else {
                    soundController.stopBackground();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Sound effects'),
              trailing: Switch.adaptive(
                value: soundEffects.value,
                onChanged: (v) {
                  setSetting('effects', v.toString());
                  soundEffects.value = v;
                  soundController.setSoundEffectsEnabled(v);
                },
              ),
            ),
            const Divider(
              thickness: 0.0,
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: context.pop,
              child: const Text('Go to menu'),
            ),
          ]),
        ),
      ),
    );
  }
}
