import 'package:flutter/material.dart';

class TranslatePopup extends StatelessWidget {
  final String originalText;
  final String translatedText;

  const TranslatePopup({
    super.key,
    required this.originalText,
    required this.translatedText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Translation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(originalText),
          const SizedBox(height: 12),
          Text(
            translatedText,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
