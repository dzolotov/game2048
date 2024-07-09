import 'package:flutter/material.dart';

import '../navigation/router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('/Fail_stamp.jpg'), context);
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
