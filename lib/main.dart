import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'game/state.dart';
import 'interop/web_dart_logger.dart';
import 'screen/main.dart';

late FragmentProgram fireProgram;

void main() async {
  fireProgram = await FragmentProgram.fromAsset('shaders/fire.frag');

  setDartLogger();
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
      ],
      child: const AppWidget(),
    ),
  );
}
