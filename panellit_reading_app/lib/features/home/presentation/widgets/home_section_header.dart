import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: HomeColors.title,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: HomeColors.muted),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel.isNotEmpty)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '$actionLabel ›',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
