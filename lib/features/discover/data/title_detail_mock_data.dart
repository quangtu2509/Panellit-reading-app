import 'package:flutter/material.dart';

import 'models/title_detail_model.dart';

const List<ChapterUpdateModel> kDefaultChapterUpdates = [
  ChapterUpdateModel(
    chapterNumber: 176,
    title: 'After the Rift',
    timeLabel: '30 minutes ago',
    isNew: true,
  ),
  ChapterUpdateModel(
    chapterNumber: 175,
    title: 'Reunion and Revelation',
    timeLabel: '2 hours ago',
    isNew: true,
  ),
  ChapterUpdateModel(
    chapterNumber: 174,
    title: 'The Calm Before',
    timeLabel: '3 days ago',
  ),
  ChapterUpdateModel(
    chapterNumber: 173,
    title: 'Echoes of the Past',
    timeLabel: '1 week ago',
  ),
  ChapterUpdateModel(
    chapterNumber: 172,
    title: 'Diverging Paths',
    timeLabel: 'Read · 2 weeks ago',
    isRead: true,
  ),
  ChapterUpdateModel(
    chapterNumber: 171,
    title: 'A Quiet Resolve',
    timeLabel: '3 weeks ago',
  ),
];

const ReviewSummaryModel kDefaultReviewSummary = ReviewSummaryModel(
  average: 4.8,
  ratingsCountLabel: '12.5k ratings',
  bars: {5: 0.92, 4: 0.16, 3: 0.04, 2: 0.01, 1: 0.02},
);

const List<CommunityReviewModel> kDefaultReviews = [
  CommunityReviewModel(
    author: 'Sarah Jenkins',
    timeLabel: '2d ago',
    rating: 5,
    content:
        'This series just keeps getting better! The character development in the latest arc is phenomenal. Can\'t wait for the next update.',
    likes: 245,
    comments: 12,
  ),
];

const List<RelatedStoryModel> kDefaultRelatedStories = [
  RelatedStoryModel(
    title: 'Omniscient Reader\'s Viewpoint',
    rating: 4.9,
    coverColor: Color(0xFF8BA1C2),
  ),
  RelatedStoryModel(
    title: 'Solo Leveling',
    rating: 4.8,
    coverColor: Color(0xFF70839F),
  ),
  RelatedStoryModel(
    title: 'Tower of God',
    rating: 4.7,
    coverColor: Color(0xFF8A98AF),
  ),
];

const TitleDetailModel kDetailAzureSentinel = TitleDetailModel(
  title: 'The Azure Sentinel: Rebirth',
  author: 'Iris Vale',
  status: 'ONGOING',
  rating: 4.9,
  chapters: 68,
  readsLabel: '1.8M',
  synopsis:
      'A sentinel returns to a shattered sky to rebuild a fallen order and defend the last city of light.',
  genres: ['Action', 'Sci-Fi', 'Fantasy'],
  chapterUpdates: kDefaultChapterUpdates,
  reviewSummary: kDefaultReviewSummary,
  reviews: kDefaultReviews,
  relatedStories: kDefaultRelatedStories,
  coverColor: Color(0xFF6FAED6),
);

const TitleDetailModel kDetailStarCrossed = TitleDetailModel(
  title: 'Star-Crossed...',
  author: 'Mina Cho',
  status: 'ONGOING',
  rating: 4.6,
  chapters: 142,
  readsLabel: '980k',
  synopsis:
      'Two worlds collide when a comet awakens a forbidden bond between rival families.',
  genres: ['Romance', 'Drama', 'Fantasy'],
  chapterUpdates: kDefaultChapterUpdates,
  reviewSummary: kDefaultReviewSummary,
  reviews: kDefaultReviews,
  relatedStories: kDefaultRelatedStories,
  coverColor: Color(0xFFD7E9F1),
);

const TitleDetailModel kDetailVoidWalker = TitleDetailModel(
  title: 'Void Walker',
  author: 'Aiden Roe',
  status: 'ONGOING',
  rating: 4.7,
  chapters: 89,
  readsLabel: '1.2M',
  synopsis:
      'A lone ranger maps the void between realms to prevent a war that could erase time itself.',
  genres: ['Dark Fantasy', 'Action', 'Adventure'],
  chapterUpdates: kDefaultChapterUpdates,
  reviewSummary: kDefaultReviewSummary,
  reviews: kDefaultReviews,
  relatedStories: kDefaultRelatedStories,
  coverColor: Color(0xFF111827),
);

const TitleDetailModel kDetailFinalQuarter = TitleDetailModel(
  title: 'Final Quarter',
  author: 'Jasper Hall',
  status: 'ONGOING',
  rating: 4.3,
  chapters: 24,
  readsLabel: '640k',
  synopsis:
      'A last season comeback puts a fractured team against impossible odds.',
  genres: ['Sports', 'Drama'],
  chapterUpdates: kDefaultChapterUpdates,
  reviewSummary: kDefaultReviewSummary,
  reviews: kDefaultReviews,
  relatedStories: kDefaultRelatedStories,
  coverColor: Color(0xFFE7E7E7),
);

const TitleDetailModel kDetailEternalHorizon = TitleDetailModel(
  title: 'Eternal Horizon',
  author: 'Rhea Wolfe',
  status: 'ONGOING',
  rating: 4.9,
  chapters: 112,
  readsLabel: '2.2M',
  synopsis:
      'Beyond the edge of the known universe, an expedition uncovers a hidden empire.',
  genres: ['Sci-Fi', 'Adventure'],
  chapterUpdates: kDefaultChapterUpdates,
  reviewSummary: kDefaultReviewSummary,
  reviews: kDefaultReviews,
  relatedStories: kDefaultRelatedStories,
  coverColor: Color(0xFFD8EAF4),
);

const TitleDetailModel kTitleDetail = kDetailAzureSentinel;
