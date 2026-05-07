import 'package:flutter/material.dart';

import '../../data/models/novel_reading_model.dart';
import '../theme/novel_reading_colors.dart';

/// Scrollable novel text content for a single chapter.
class NovelReaderContent extends StatelessWidget {
  final NovelChapter chapter;
  final ScrollController scrollController;

  const NovelReaderContent({
    super.key,
    required this.chapter,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 160),
      children: [
        _ChapterHeader(chapter: chapter),
        const SizedBox(height: 24),
        _ChapterBody(content: chapter.content),
        const SizedBox(height: 32),
        _ChapterFooter(wordCount: chapter.wordCount),
      ],
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _ChapterHeader extends StatelessWidget {
  final NovelChapter chapter;

  const _ChapterHeader({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chapter.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: NovelReadingColors.magicPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          chapter.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.25,
            color: NovelReadingColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: NovelReadingColors.chapterDivider, thickness: 1),
      ],
    );
  }
}

class _ChapterBody extends StatelessWidget {
  final String content;

  const _ChapterBody({required this.content});

  @override
  Widget build(BuildContext context) {
    // Split on blank lines → paragraphs
    final paragraphs = content
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            para,
            style: const TextStyle(
              fontSize: 16,
              height: 1.85,
              fontWeight: FontWeight.w400,
              color: NovelReadingColors.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChapterFooter extends StatelessWidget {
  final int wordCount;

  const _ChapterFooter({required this.wordCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: NovelReadingColors.chapterDivider, thickness: 1),
        const SizedBox(height: 12),
        Text(
          '~ ${wordCount.toString()} words ~',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: NovelReadingColors.topBarSubtitle,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
