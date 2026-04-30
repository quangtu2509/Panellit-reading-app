import 'package:flutter/material.dart';

import '../../../discover/data/models/title_detail_model.dart';

enum LibrarySortOption { az, za, newestToOldest, oldestToNewest }

extension LibrarySortOptionLabel on LibrarySortOption {
  String get label {
    switch (this) {
      case LibrarySortOption.az:
        return 'A -> Z';
      case LibrarySortOption.za:
        return 'Z -> A';
      case LibrarySortOption.newestToOldest:
        return 'Newest -> Oldest';
      case LibrarySortOption.oldestToNewest:
        return 'Oldest -> Newest';
    }
  }
}

class LibraryItem {
  final String title;
  final String genre;
  final int updatedHoursAgo;
  final String chapter;
  final String actionLabel;
  final String? badge;
  final Color coverColor;
  final TitleDetailModel detail;

  const LibraryItem({
    required this.title,
    required this.genre,
    required this.updatedHoursAgo,
    required this.chapter,
    required this.actionLabel,
    required this.coverColor,
    required this.detail,
    this.badge,
  });

  String get updatedLabel {
    if (updatedHoursAgo < 24) {
      return 'Updated ${updatedHoursAgo}h ago';
    }

    final days = updatedHoursAgo ~/ 24;
    return 'Updated ${days}d ago';
  }
}
