import 'package:flutter/material.dart';

class SearchResultModel {
  final String title;
  final String slug;
  final String typeLabel; // 'Manga' or 'Novel'
  final String author;
  final List<String> genres;
  final double rating;
  final String ratingsCountLabel;
  final Color coverColor;
  final String? coverUrl; // Real cover image URL from API
  final bool openAsGuest;

  const SearchResultModel({
    required this.title,
    required this.slug,
    required this.typeLabel,
    required this.author,
    required this.genres,
    required this.rating,
    required this.ratingsCountLabel,
    required this.coverColor,
    this.coverUrl,
    this.openAsGuest = false,
  });
}

class SearchSuggestionModel {
  final String keyword;

  const SearchSuggestionModel({required this.keyword});
}
