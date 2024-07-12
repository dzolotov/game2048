import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/state.dart';
// import 'interop/web/web_dart_logger.dart';
import 'interop/universal_export.dart';
import 'screen/main.dart';

late FragmentProgram fireProgram;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //load shaders
  fireProgram = await FragmentProgram.fromAsset('shaders/fire.frag');
  //setup JS interop (js -> dart)
  setDartLogger();
  //setup URL Strategy (only usable for Web)
  setPathStrategy();
  await initEnvironment();

  runApp(ChangeNotifierProvider(
    create: (_) => GameState(),
    child: const AppWidget(),
  ));
}
