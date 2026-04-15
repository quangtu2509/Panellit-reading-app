import 'package:flutter/material.dart';

import '../../data/models/library_item.dart';
import '../theme/library_colors.dart';
import 'library_sort_button.dart';

class LibraryTabSection extends StatelessWidget {
  final double topPadding;
  final String? title;
  final LibrarySortOption selectedSort;
  final ValueChanged<LibrarySortOption> onSortSelected;
  final List<Widget> children;

  const LibraryTabSection({
    super.key,
    required this.topPadding,
    required this.selectedSort,
    required this.onSortSelected,
    required this.children,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(18, topPadding, 18, 96),
      children: [
        Row(
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: LibraryColors.title,
                ),
              ),
            const Spacer(),
            LibrarySortButton(
              selectedSort: selectedSort,
              onSelected: onSortSelected,
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}
