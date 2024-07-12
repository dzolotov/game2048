import 'dart:js_interop';
import 'dart:typed_data' as typed_data;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:web/web.dart';

class Box3D extends HookWidget {
  static const size = 64.0;

  const Box3D({super.key});

  @override
  Widget build(BuildContext context) {

    return const SizedBox(
      width: size,
      height: size,
      child: HtmlElementView(
        viewType: 'canvas3d',
      ),
    );
  }
}
