import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game2048/controllers/game_sound.dart';
import 'package:provider/provider.dart';

import '../navigation/router.dart';

class DartLogger {
  @JSExport()
  void nameIsChanged(String newName) => print('Name is changed to $newName');
}

class AppWidget extends HookWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameSoundController = useMemoized(() => GameSoundController());
    globalContext.setProperty(
      'logger'.toJS,
      createJSInteropWrapper(
        DartLogger(),
      ),
    );
    useEffect(() {
      gameSoundController.init();
      return gameSoundController.dispose;
    });
    precacheImage(const AssetImage('/Fail_stamp.jpg'), context);
    return Provider.value(
      value: gameSoundController,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
