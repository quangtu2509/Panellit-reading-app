import 'models/library_item.dart';
import 'models/library_reading_item.dart';
import 'models/library_completed_item.dart';
import 'package:flutter/material.dart';

const int kLibraryTotalTitles = 12;

const List<LibraryItem> kFollowingLibraryItems = [
  LibraryItem(
    title: 'Shadow Realm Chronicles',
    genre: 'Fantasy',
    updatedHoursAgo: 2,
    chapter: 'Ch. 142',
    actionLabel: 'Continue',
    badge: 'NEW',
    coverColor: Color(0xFF1E3340),
  ),
  LibraryItem(
    title: 'Cyber City 2099',
    genre: 'Sci-Fi',
    updatedHoursAgo: 5,
    chapter: 'Ch. 88',
    actionLabel: 'Continue',
    badge: 'NEW',
    coverColor: Color(0xFF122033),
  ),
  LibraryItem(
    title: 'The Midnight Library',
    genre: 'Mystery',
    updatedHoursAgo: 24,
    chapter: 'Ch. 24',
    actionLabel: 'Read Now',
    coverColor: Color(0xFF4E3415),
  ),
  LibraryItem(
    title: "Ron's Path",
    genre: 'Historical',
    updatedHoursAgo: 72,
    chapter: 'Ch. 12',
    actionLabel: 'Resume',
    badge: 'NEW',
    coverColor: Color(0xFF5A2A31),
  ),
];

const List<LibraryReadingItem> kReadingLibraryItems = [
  LibraryReadingItem(
    title: 'Shadow Realm Chronicles',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    currentUnit: 45,
    totalUnit: 120,
    lastReadHoursAgo: 2,
    coverColor: Color(0xFF1E3340),
  ),
  LibraryReadingItem(
    title: 'Azure Sky High',
    typeLabel: 'MANGA',
    unitLabel: 'Volume',
    currentUnit: 3,
    totalUnit: 12,
    lastReadHoursAgo: 5,
    coverColor: Color(0xFF10243B),
  ),
  LibraryReadingItem(
    title: "The Weaver's Paradox",
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    currentUnit: 88,
    totalUnit: 92,
    lastReadHoursAgo: 24,
    coverColor: Color(0xFF2B2722),
  ),
  LibraryReadingItem(
    title: 'Midnight Tea Garden',
    typeLabel: 'MANGA',
    unitLabel: 'Volume',
    currentUnit: 1,
    totalUnit: 5,
    lastReadHoursAgo: 72,
    coverColor: Color(0xFF272A31),
  ),
];

const List<LibraryCompletedItem> kCompletedLibraryItems = [
  LibraryCompletedItem(
    title: "The Alchemist's Shadow",
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 108,
    completedHoursAgo: 12,
    rating: 4.9,
    coverColor: Color(0xFF2A7597),
  ),
  LibraryCompletedItem(
    title: 'Neon Horizon: Protocol Zero',
    typeLabel: 'MANGA',
    unitLabel: 'Volume',
    totalUnit: 24,
    completedHoursAgo: 36,
    rating: 4.7,
    coverColor: Color(0xFF30274A),
  ),
  LibraryCompletedItem(
    title: 'Whispers of the Sakura',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 67,
    completedHoursAgo: 96,
    rating: 5.0,
    coverColor: Color(0xFF7D5C70),
  ),
  LibraryCompletedItem(
    title: 'The Forgotten Archivist',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 92,
    completedHoursAgo: 168,
    rating: 4.5,
    coverColor: Color(0xFF36393F),
  ),
  LibraryCompletedItem(
    title: 'Skyward Bound',
    typeLabel: 'NOVEL',
    unitLabel: 'Chapter',
    totalUnit: 84,
    completedHoursAgo: 216,
    rating: 4.8,
    coverColor: Color(0xFF7EA5A6),
  ),
];
