import 'package:flutter/material.dart';

import '../../data/models/library_item.dart';

class LibrarySortButton extends StatelessWidget {
  final LibrarySortOption selectedSort;
  final ValueChanged<LibrarySortOption> onSelected;

  const LibrarySortButton({
    super.key,
    required this.selectedSort,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<LibrarySortOption>(
      initialValue: selectedSort,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: Colors.white,
      itemBuilder: (context) {
        return LibrarySortOption.values.map((option) {
          return PopupMenuItem<LibrarySortOption>(
            value: option,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: option == selectedSort
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: const Color(0xFF3A3F44),
                    ),
                  ),
                ),
                if (option == selectedSort)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF0F6F9B),
                    size: 18,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              'Sort',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
