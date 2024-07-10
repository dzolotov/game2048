import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:game2048/screen/main.dart';
import 'package:provider/provider.dart';

import 'game/state.dart';

late FragmentProgram fireProgram;

void main() async {
  fireProgram = await FragmentProgram.fromAsset('shaders/fire.frag');

  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
      ],
      child: const AppWidget(),
    ),
  );
}
