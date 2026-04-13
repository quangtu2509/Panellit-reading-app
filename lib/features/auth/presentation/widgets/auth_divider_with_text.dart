import 'package:flutter/material.dart';

class AuthDividerWithText extends StatelessWidget {
  final String text;

  const AuthDividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E8EC), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E8EC), thickness: 1)),
      ],
    );
  }
}
