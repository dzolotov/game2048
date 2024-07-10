import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../interop/web_impl.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  // late InAppWebViewController _controller;

  @override
  void initState() {
    super.initState();
    // showNotification(1, 'Manual is shown', 'Manual page is opened');
    registerIFrame(); //only for Flutter Web
  }

  @override
  Widget build(BuildContext context) => kIsWeb
      ? const SizedBox.shrink() //todo: replace with HTMLElementView
      : Scaffold(
          appBar: AppBar(),
          body: const SizedBox.shrink(),
        ); //todo: in app webview
}
