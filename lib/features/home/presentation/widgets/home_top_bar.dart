import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

class HomeTopBar extends StatelessWidget {
  final String title;

  const HomeTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: HomeColors.brand,
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: HomeColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9EDF1)),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: HomeColors.mutedIcon,
            ),
          ),
        ],
      ),
    );
  }
}
