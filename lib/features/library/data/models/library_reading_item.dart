import 'package:flutter/material.dart';

class LibraryReadingItem {
  final String title;
  final String typeLabel;
  final String unitLabel;
  final int currentUnit;
  final int totalUnit;
  final int lastReadHoursAgo;
  final Color coverColor;

  const LibraryReadingItem({
    required this.title,
    required this.typeLabel,
    required this.unitLabel,
    required this.currentUnit,
    required this.totalUnit,
    required this.lastReadHoursAgo,
    required this.coverColor,
  });

  double get progressValue {
    if (totalUnit <= 0) {
      return 0;
    }

    return (currentUnit / totalUnit).clamp(0, 1).toDouble();
  }

  int get progressPercent => (progressValue * 100).round();

  String get progressLabel => '$unitLabel $currentUnit / $totalUnit';

  String get lastReadLabel {
    if (lastReadHoursAgo < 24) {
      return 'LAST READ ${lastReadHoursAgo}H AGO';
    }

    final days = lastReadHoursAgo ~/ 24;
    return 'LAST READ ${days}D AGO';
  }
}
