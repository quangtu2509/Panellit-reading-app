import 'package:flutter/material.dart';

import '../theme/novel_reading_colors.dart';

/// Top bar for the novel reader: back arrow ←, title/chapter, and bookmark icon.
class NovelReaderTopBar extends StatelessWidget {
  final String title;
  final String chapterLabel;
  final bool isSaved;
  final bool isGuest;
  final bool showGuestHint;
  final VoidCallback onSaveTap;

  const NovelReaderTopBar({
    super.key,
    required this.title,
    required this.chapterLabel,
    required this.isSaved,
    required this.isGuest,
    required this.showGuestHint,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 14),
      decoration: const BoxDecoration(
        color: NovelReadingColors.topBarBackground,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ← Back button (replaces hamburger icon)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: NovelReadingColors.topBarIcon,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              // Title + chapter centred
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: NovelReadingColors.topBarTitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chapterLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: NovelReadingColors.topBarSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmark icon — identical behaviour to manga reader
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border,
                    ),
                    color: isGuest
                        ? NovelReadingColors.bookmarkDisabled
                        : (isSaved
                            ? NovelReadingColors.bookmarkActive
                            : NovelReadingColors.bookmarkInactive),
                    onPressed: onSaveTap,
                  ),
                  AnimatedOpacity(
                    opacity: showGuestHint ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: const Text(
                      'login to use',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: NovelReadingColors.guestHint,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Swipe right on the left edge to open the sidebar',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: NovelReadingColors.topBarSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}
