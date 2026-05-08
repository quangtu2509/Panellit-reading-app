

import '../../../../core/data/mock_database.dart';
import 'models/title_detail_model.dart';

// Helper to convert MockTitle to TitleDetailModel
TitleDetailModel _mapToDetailModel(MockTitle mock) {
  return TitleDetailModel(
    id: mock.id,
    title: mock.title,
    author: mock.author,
    status: mock.status,
    rating: mock.rating,
    chapters: mock.chapters.length,
    readsLabel: mock.readsLabel,
    synopsis: mock.synopsis,
    genres: mock.genres,
    chapterUpdates: mock.chapters.map((c) => ChapterUpdateModel(
      chapterNumber: c.number,
      title: c.title,
      timeLabel: c.timeLabel,
      isNew: c.isNew,
      isRead: c.isRead,
    )).toList(),
    reviewSummary: ReviewSummaryModel(
      average: mock.reviewSummary.average,
      ratingsCountLabel: mock.reviewSummary.ratingsCountLabel,
      bars: mock.reviewSummary.bars,
    ),
    reviews: mock.reviews.map((r) => CommunityReviewModel(
      author: r.author,
      timeLabel: r.timeLabel,
      rating: r.rating,
      content: r.content,
      likes: r.likes,
      comments: r.comments,
    )).toList(),
    relatedStories: mock.relatedStories.map((rs) => RelatedStoryModel(
      title: rs.title,
      rating: rs.rating,
      coverColor: rs.coverColor,
    )).toList(),
    coverColor: mock.coverColor,
  );
}

// Convert all titles from MockDatabase into a map for easy lookup
final Map<String, TitleDetailModel> _detailModels = {
  for (var title in MockDatabase.titles) title.title: _mapToDetailModel(title),
};

// Fallback logic to get detail model
TitleDetailModel getDetailModelForTitle(String title) {
  if (_detailModels.containsKey(title)) {
    return _detailModels[title]!;
  }
  // Return a safe fallback if title is not found
  return _detailModels.values.first;
}

// We expose kTitleDetail as the featured one (e.g., Azure Sentinel or Final Quarter)
final TitleDetailModel kTitleDetail = getDetailModelForTitle('The Azure Sentinel: Rebirth');

// Keep old constant names for compatibility, pointing to our mapped items
final TitleDetailModel kDetailAzureSentinel = getDetailModelForTitle('The Azure Sentinel: Rebirth');
final TitleDetailModel kDetailStarCrossed = getDetailModelForTitle('Star-Crossed...');
final TitleDetailModel kDetailVoidWalker = getDetailModelForTitle('Solo Leveling'); // Fallback map
final TitleDetailModel kDetailFinalQuarter = getDetailModelForTitle('Final Quarter');
final TitleDetailModel kDetailEternalHorizon = getDetailModelForTitle('Elara and the Forgotten Kingdom'); // Fallback map
