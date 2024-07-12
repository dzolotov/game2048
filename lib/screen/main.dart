import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
import '../interop/web/web_impl.dart';
// import '../interop/universal_export.dart';
import '../navigation/router.dart';

class AppWidget extends HookWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameSoundController = useMemoized(
      () => GameSoundController()
        ..setBackgroundMusicEnabled(getSetting('background') != 'false')
        ..setSoundEffectsEnabled(getSetting('effects') != 'false'),
    );
    useEffect(() {
      gameSoundController.init();
      return () {
        gameSoundController.dispose;
        fame.clear();
      };
    });
    // precacheImage(const AssetImage('assets/fail_stamp.jpg'), context);
    return Provider.value(
      value: gameSoundController,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
