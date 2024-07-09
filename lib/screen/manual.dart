import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  @override
  void initState() {
    super.initState();
    ui_web.PlatformViewRegistry().registerViewFactory(
      'manual',
      (_) {
        return HTMLIFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..src = 'https://ru.wikipedia.org/wiki/2048_(игра)';
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      const HtmlElementView(viewType: 'manual');
}
