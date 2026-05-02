import 'package:flutter/material.dart';

class SearchResultModel {
  final String title;
  final String typeLabel; // 'Novel' or 'Manga'
  final String author;
  final List<String> genres;
  final double rating;
  final String ratingsCountLabel;
  final Color coverColor;
  final bool openAsGuest;

  const SearchResultModel({
    required this.title,
    required this.typeLabel,
    required this.author,
    required this.genres,
    required this.rating,
    required this.ratingsCountLabel,
    required this.coverColor,
    this.openAsGuest = false,
  });
}

class SearchSuggestionModel {
  final String keyword;

  const SearchSuggestionModel({required this.keyword});
}
