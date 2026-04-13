import 'package:flutter/material.dart';

class SummaryBottomSheet extends StatelessWidget {
  final String summary;

  const SummaryBottomSheet({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: Text(summary)),
      ),
    );
  }
}
