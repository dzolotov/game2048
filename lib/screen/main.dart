import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

import '../controllers/game_sound.dart';
import '../navigation/router.dart';

class AppWidget extends HookWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameSoundController = useMemoized(() => GameSoundController());
    useEffect(() {
      gameSoundController.init();
      return gameSoundController.dispose;
    });
    // precacheImage(const AssetImage('assets/fail_stamp.jpg'), context);
    return Provider.value(
      value: gameSoundController,
      child: UniversalPlatform.isMacOS
          ? PlatformMenuBar(
              menus: [
                PlatformMenu(label: 'Game', menus: [
                  PlatformMenuItem(
                      label: 'Hall of Fame',
                      onSelected: () => context.go('/fame')
                      //process action
                      ),
                ])
              ],
              //todo: use MacosApp, problem with 10.14
              child: MaterialApp.router(routerConfig: router),
            )
          : MaterialApp.router(routerConfig: router),
    );
  }
}
