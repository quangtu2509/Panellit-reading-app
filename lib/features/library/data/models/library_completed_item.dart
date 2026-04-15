import 'package:flutter/material.dart';

class LibraryCompletedItem {
  final String title;
  final String typeLabel;
  final String unitLabel;
  final int totalUnit;
  final int completedHoursAgo;
  final double rating;
  final Color coverColor;

  const LibraryCompletedItem({
    required this.title,
    required this.typeLabel,
    required this.unitLabel,
    required this.totalUnit,
    required this.completedHoursAgo,
    required this.rating,
    required this.coverColor,
  });

  String get progressLabel => '$unitLabel $totalUnit / $totalUnit';

  String get completionLabel {
    if (completedHoursAgo < 24) {
      return 'COMPLETED ${completedHoursAgo}H AGO';
    }

    final days = completedHoursAgo ~/ 24;
    return 'COMPLETED ${days}D AGO';
  }
}
