import 'package:flutter/material.dart';

class EmptySlot extends StatelessWidget {
  const EmptySlot({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: ColoredBox(color: Colors.black12),
      );
}
