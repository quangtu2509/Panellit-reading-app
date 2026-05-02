import 'package:flutter/material.dart';

import '../theme/novel_reading_colors.dart';

/// Bottom control bar: prev / chapter selector / next — mirrors manga reader.
class NovelReaderControlBar extends StatelessWidget {
  final String chapterLabel;
  final bool canGoPrev;
  final bool canGoNext;
  final VoidCallback onPrevTap;
  final VoidCallback onNextTap;
  final VoidCallback onChapterTap;

  const NovelReaderControlBar({
    super.key,
    required this.chapterLabel,
    required this.canGoPrev,
    required this.canGoNext,
    required this.onPrevTap,
    required this.onNextTap,
    required this.onChapterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: NovelReadingColors.controlBar,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _ControlIconButton(
            icon: Icons.skip_previous_rounded,
            onTap: onPrevTap,
            isEnabled: canGoPrev,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onChapterTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: NovelReadingColors.controlIcon,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      chapterLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: NovelReadingColors.controlIcon,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: NovelReadingColors.controlIcon,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _ControlIconButton(
            icon: Icons.skip_next_rounded,
            onTap: onNextTap,
            isEnabled: canGoNext,
          ),
        ],
      ),
    );
  }
}

class _ControlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _ControlIconButton({
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFFF1F4F8)
              : const Color(0xFFE1E7EF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? NovelReadingColors.controlIcon
              : NovelReadingColors.controlInactive,
        ),
      ),
    );
  }
}
