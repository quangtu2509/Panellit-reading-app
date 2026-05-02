import '../../../../core/data/mock_database.dart';
import 'models/search_models.dart';

final List<SearchResultModel> kSearchResultsCatalog = MockDatabase.titles
    .map((t) => SearchResultModel(
          title: t.title,
          typeLabel: t.type,
          author: t.author,
          genres: t.genres,
          rating: t.rating,
          ratingsCountLabel: t.ratingsCountLabel,
          coverColor: t.coverColor,
          openAsGuest: t.openAsGuest,
        ))
    .toList();

final List<SearchSuggestionModel> kSearchSuggestionSeeds = [
  const SearchSuggestionModel(keyword: 'Novel'),
  const SearchSuggestionModel(keyword: 'Manga'),
  const SearchSuggestionModel(keyword: 'Action'),
  const SearchSuggestionModel(keyword: 'Fantasy'),
  const SearchSuggestionModel(keyword: 'Drama'),
  const SearchSuggestionModel(keyword: 'Adventure'),
  const SearchSuggestionModel(keyword: 'Sci-Fi'),
  const SearchSuggestionModel(keyword: 'Romance'),
  const SearchSuggestionModel(keyword: 'Sports'),
  // Add all titles dynamically
  ...MockDatabase.titles.map((t) => SearchSuggestionModel(keyword: t.title)),
];

final List<String> kSearchRecentKeywords = [
  MockDatabase.titles.first.title, // Just take the first few
  if (MockDatabase.titles.length > 2) MockDatabase.titles[2].title,
];
