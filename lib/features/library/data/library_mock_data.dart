import 'models/library_item.dart';
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
