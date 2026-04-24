import 'package:flutter/material.dart';

import 'models/search_models.dart';

const List<SearchResultModel> kSearchResultsCatalog = [
  SearchResultModel(
    title: 'Solo Leveling',
    author: 'Chugong, DUBU (REDICE STUDIO)',
    genres: ['Action', 'Fantasy'],
    rating: 4.9,
    ratingsCountLabel: '24.5k',
    coverColor: Color(0xFF0D2742),
  ),
  SearchResultModel(
    title: 'Solo Leveling: Ragnarok',
    author: 'Daul, REDICE STUDIO',
    genres: ['Action', 'Sci-Fi'],
    rating: 4.7,
    ratingsCountLabel: '8.2k',
    coverColor: Color(0xFF51352A),
  ),
  SearchResultModel(
    title: 'Omniscient Reader',
    author: 'singNsong, Sleepy-C',
    genres: ['Fantasy', 'Drama'],
    rating: 4.9,
    ratingsCountLabel: '31.1k',
    coverColor: Color(0xFF1B2C3E),
    openAsGuest: true,
  ),
  SearchResultModel(
    title: 'The Beginning After The End',
    author: 'TurtleMe, Fuyuki23',
    genres: ['Action', 'Adventure', 'Fantasy'],
    rating: 4.8,
    ratingsCountLabel: '12.5k',
    coverColor: Color(0xFF4D7C9E),
  ),
];

const List<SearchSuggestionModel> kSearchSuggestionSeeds = [
  SearchSuggestionModel(keyword: 'Solo Leveling'),
  SearchSuggestionModel(keyword: 'Solo Bug Player'),
  SearchSuggestionModel(keyword: 'Solo Necromancer'),
  SearchSuggestionModel(keyword: 'Soloist'),
  SearchSuggestionModel(keyword: 'Omniscient Reader'),
  SearchSuggestionModel(keyword: 'The Beginning After The End'),
  SearchSuggestionModel(keyword: 'Tower of God'),
  SearchSuggestionModel(keyword: 'Action'),
  SearchSuggestionModel(keyword: 'Fantasy'),
  SearchSuggestionModel(keyword: 'Drama'),
  SearchSuggestionModel(keyword: 'Adventure'),
];

const List<String> kSearchRecentKeywords = [
  'Solo Leveling',
  'The Beginning After the End',
  'Omniscient Reader',
];
