import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

// import '../interop/web/web_impl.dart';

import '../controllers/game_sound.dart';
import '../interop/universal_export.dart';
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
      return gameSoundController.dispose;
    });
    // precacheImage(const AssetImage('assets/fail_stamp.jpg'), context);
    return Provider.value(
      value: gameSoundController,
      child: UniversalPlatform.isMacOS
          ? MacosApp.router(routerConfig: router)
          : MaterialApp.router(routerConfig: router),
    );
  }
}

class WrapWithMenuBar extends StatelessWidget {
  final Widget child;

  const WrapWithMenuBar({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isMacOS) {
      return child;
    };
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'Game',
          menus: [
            PlatformMenuItem(
                label: 'Hall of Fame', onSelected: () => context.go('/fame')),
          ],
        )
      ],
      child: child,
    );
  }
}
