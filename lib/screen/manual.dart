import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../interop/web/web_impl.dart';
// import '../interop/universal_export.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  @override
  void initState() {
    super.initState();
    registerIFrame(context);
  }

  @override
  Widget build(BuildContext context) => kIsWeb
      ? const HtmlElementView(viewType: 'manual')
      : Scaffold(
          appBar: AppBar(),
          body: const SizedBox.shrink(),
        );
}
