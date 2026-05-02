import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailChaptersSection extends StatefulWidget {
  final List<ChapterUpdateModel> chapters;
  final ValueChanged<int> onChapterTap;
  final int? savedChapterNumber;

  const DetailChaptersSection({
    super.key,
    required this.chapters,
    required this.onChapterTap,
    this.savedChapterNumber,
  });

  @override
  State<DetailChaptersSection> createState() => _DetailChaptersSectionState();
}

class _DetailChaptersSectionState extends State<DetailChaptersSection> {
  ChapterSortOption _sortOption = ChapterSortOption.newest;

  List<ChapterUpdateModel> get _sortedChapters {
    final result = List<ChapterUpdateModel>.from(widget.chapters);
    result.sort((a, b) {
      switch (_sortOption) {
        case ChapterSortOption.newest:
          return b.chapterNumber.compareTo(a.chapterNumber);
        case ChapterSortOption.oldest:
          return a.chapterNumber.compareTo(b.chapterNumber);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final chapters = _sortedChapters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Chapters',
                style: TextStyle(
                  color: TitleDetailColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            PopupMenuButton<ChapterSortOption>(
              initialValue: _sortOption,
              onSelected: (value) {
                setState(() {
                  _sortOption = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    _sortOption == ChapterSortOption.newest
                        ? 'Newest'
                        : 'Oldest',
                    style: const TextStyle(
                      color: TitleDetailColors.brand,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.sort_rounded,
                    size: 18,
                    color: TitleDetailColors.brand,
                  ),
                ],
              ),
              itemBuilder: (context) {
                return ChapterSortOption.values.map((option) {
                  return PopupMenuItem<ChapterSortOption>(
                    value: option,
                    child: Text(
                      option == ChapterSortOption.newest ? 'Newest' : 'Oldest',
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: TitleDetailColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TitleDetailColors.divider),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              itemCount: chapters.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return _ChapterTile(
                  item: chapter,
                  isSaved: chapter.chapterNumber == widget.savedChapterNumber,
                  onTap: () => widget.onChapterTap(chapter.chapterNumber),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final ChapterUpdateModel item;
  final bool isSaved;
  final VoidCallback onTap;

  const _ChapterTile({
    required this.item,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSaved ? const Color(0xFFFFF7D1) : const Color(0xFFF9FBFD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSaved
                ? const Color(0xFFFFC107)
                : TitleDetailColors.divider,
          ),
          boxShadow: isSaved
              ? const [
                  BoxShadow(
                    color: Color(0x1AF2B705),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSaved
                    ? const Color(0xFFFFECB3)
                    : const Color(0xFFF0F2F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${item.chapterNumber}',
                style: TextStyle(
                  color: isSaved
                      ? const Color(0xFF8A6400)
                      : const Color(0xFF67758C),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: TitleDetailColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSaved)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'SAVED',
                            style: TextStyle(
                              color: Color(0xFF3A2B00),
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        )
                      else if (item.isNew)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: TitleDetailColors.brand,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        )
                      else if (item.isRead)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: TitleDetailColors.brand,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: TitleDetailColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
