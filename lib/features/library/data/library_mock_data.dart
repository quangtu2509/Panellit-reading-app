import 'package:flutter/material.dart';
import '../../discover/data/title_detail_mock_data.dart';
import 'models/library_completed_item.dart';
import 'models/library_item.dart';
import 'models/library_reading_item.dart';

const int kLibraryTotalTitles = 12;

final List<LibraryItem> kFollowingLibraryItems = [
  LibraryItem(
    title: 'The Azure Sentinel: Rebirth',
    genre: 'Sci-Fi',
    updatedHoursAgo: 2,
    chapter: 'Ch. 68',
    actionLabel: 'Continue',
    badge: 'NEW',
    coverColor: Color(0xFF6FAED6),
    detail: kDetailAzureSentinel,
  ),
  LibraryItem(
    title: 'Void Walker',
    genre: 'Dark Fantasy',
    updatedHoursAgo: 5,
    chapter: 'Ch. 89',
    actionLabel: 'Continue',
    badge: 'NEW',
    coverColor: Color(0xFF111827),
    detail: kDetailVoidWalker,
  ),
  LibraryItem(
    title: 'Star-Crossed...',
    genre: 'Romance',
    updatedHoursAgo: 24,
    chapter: 'Ch. 142',
    actionLabel: 'Read Now',
    coverColor: Color(0xFFD7E9F1),
    detail: kDetailStarCrossed,
  ),
  LibraryItem(
    title: 'Eternal Horizon',
    genre: 'Adventure',
    updatedHoursAgo: 72,
    chapter: 'Ch. 112',
    actionLabel: 'Resume',
    badge: 'NEW',
    coverColor: Color(0xFFD8EAF4),
    detail: kDetailEternalHorizon,
  ),
];

final List<LibraryReadingItem> kReadingLibraryItems = [
  LibraryReadingItem(
    title: 'Final Quarter',
    typeLabel: 'MANGA',
    unitLabel: 'Chapter',
    currentUnit: 12,
    totalUnit: 24,
    lastReadHoursAgo: 2,
    coverColor: Color(0xFFE7E7E7),
    detail: kDetailFinalQuarter,
  ),
  LibraryReadingItem(
    title: 'The Azure Sentinel: Rebirth',
    typeLabel: 'NOVEL',
    unitLabel: 'Volume',
    currentUnit: 32,
    totalUnit: 68,
    lastReadHoursAgo: 5,
    coverColor: Color(0xFF6FAED6),
    detail: kDetailAzureSentinel,
  ),
  LibraryReadingItem(
    title: 'Void Walker',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    currentUnit: 40,
    totalUnit: 89,
    lastReadHoursAgo: 24,
    coverColor: Color(0xFF111827),
    detail: kDetailVoidWalker,
  ),
  LibraryReadingItem(
    title: 'Eternal Horizon',
    typeLabel: 'NOVEL',
    unitLabel: 'Volume',
    currentUnit: 64,
    totalUnit: 112,
    lastReadHoursAgo: 72,
    coverColor: Color(0xFFD8EAF4),
    detail: kDetailEternalHorizon,
  ),
];

final List<LibraryCompletedItem> kCompletedLibraryItems = [
  LibraryCompletedItem(
    title: 'Star-Crossed...',
    typeLabel: 'MANGA',
    unitLabel: 'Chapter',
    totalUnit: 142,
    completedHoursAgo: 12,
    rating: 4.6,
    coverColor: Color(0xFFD7E9F1),
    detail: kDetailStarCrossed,
  ),
  LibraryCompletedItem(
    title: 'Void Walker',
    typeLabel: 'NOVEL',
    unitLabel: 'Volume',
    totalUnit: 89,
    completedHoursAgo: 36,
    rating: 4.7,
    coverColor: Color(0xFF111827),
    detail: kDetailVoidWalker,
  ),
  LibraryCompletedItem(
    title: 'Final Quarter',
    typeLabel: 'MANGA',
    unitLabel: 'Chapter',
    totalUnit: 24,
    completedHoursAgo: 96,
    rating: 4.3,
    coverColor: Color(0xFFE7E7E7),
    detail: kDetailFinalQuarter,
  ),
  LibraryCompletedItem(
    title: 'Eternal Horizon',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 112,
    completedHoursAgo: 168,
    rating: 4.9,
    coverColor: Color(0xFFD8EAF4),
    detail: kDetailEternalHorizon,
  ),
  LibraryCompletedItem(
    title: 'The Azure Sentinel: Rebirth',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 68,
    completedHoursAgo: 216,
    rating: 4.9,
    coverColor: Color(0xFF6FAED6),
    detail: kDetailAzureSentinel,
  ),
];
