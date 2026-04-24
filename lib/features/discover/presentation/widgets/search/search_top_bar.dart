import 'package:flutter/material.dart';

import '../../theme/search_colors.dart';

class SearchTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const SearchTopBar({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 18, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back_rounded),
            color: SearchColors.primary,
          ),
          const SizedBox(width: 4),
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: SearchColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
