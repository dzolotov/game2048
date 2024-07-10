import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/state.dart';
import 'interop/universal_export.dart';
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
