import 'package:flutter/material.dart';

class AiPopup extends StatelessWidget {
  final Widget child;

  const AiPopup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
