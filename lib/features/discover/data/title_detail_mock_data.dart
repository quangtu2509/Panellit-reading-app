import 'package:flutter/material.dart';

import 'models/title_detail_model.dart';

const TitleDetailModel kTitleDetail = TitleDetailModel(
  title: 'The Beginning After The End',
  author: 'TurtleMe',
  status: 'ONGOING',
  rating: 4.8,
  chapters: 175,
  readsLabel: '2.4M',
  synopsis:
      'King Grey has unrivaled strength, wealth, and prestige in a world governed by martial ability. However, solitude lingers closely behind those with great power. Beneath the glamorous exterior lies a man searching for meaning in a second life.',
  genres: [
    'Action',
    'Fantasy',
    'Adventure',
    'Isekai',
    'Drama',
    'Reincarnation',
  ],
  chapterUpdates: [
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
  ],
  reviewSummary: ReviewSummaryModel(
    average: 4.8,
    ratingsCountLabel: '12.5k ratings',
    bars: {5: 0.92, 4: 0.16, 3: 0.04, 2: 0.01, 1: 0.02},
  ),
  reviews: [
    CommunityReviewModel(
      author: 'Sarah Jenkins',
      timeLabel: '2d ago',
      rating: 5,
      content:
          'This series just keeps getting better! The character development in the latest arc is phenomenal. Can\'t wait for the next update.',
      likes: 245,
      comments: 12,
    ),
  ],
  relatedStories: [
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
  ],
  coverColor: Color(0xFF7DB9DD),
);
