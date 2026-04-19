import 'package:flutter/material.dart';

class TitleDetailModel {
  final String title;
  final String author;
  final String status;
  final double rating;
  final int chapters;
  final String readsLabel;
  final String synopsis;
  final List<String> genres;
  final List<ChapterUpdateModel> chapterUpdates;
  final ReviewSummaryModel reviewSummary;
  final List<CommunityReviewModel> reviews;
  final List<RelatedStoryModel> relatedStories;
  final Color coverColor;

  const TitleDetailModel({
    required this.title,
    required this.author,
    required this.status,
    required this.rating,
    required this.chapters,
    required this.readsLabel,
    required this.synopsis,
    required this.genres,
    required this.chapterUpdates,
    required this.reviewSummary,
    required this.reviews,
    required this.relatedStories,
    required this.coverColor,
  });
}

class ChapterUpdateModel {
  final int chapterNumber;
  final String title;
  final String timeLabel;
  final bool isNew;
  final bool isRead;

  const ChapterUpdateModel({
    required this.chapterNumber,
    required this.title,
    required this.timeLabel,
    this.isNew = false,
    this.isRead = false,
  });
}

class ReviewSummaryModel {
  final double average;
  final String ratingsCountLabel;
  final Map<int, double> bars;

  const ReviewSummaryModel({
    required this.average,
    required this.ratingsCountLabel,
    required this.bars,
  });
}

class CommunityReviewModel {
  final String author;
  final String timeLabel;
  final double rating;
  final String content;
  final int likes;
  final int comments;

  const CommunityReviewModel({
    required this.author,
    required this.timeLabel,
    required this.rating,
    required this.content,
    required this.likes,
    required this.comments,
  });
}

class RelatedStoryModel {
  final String title;
  final double rating;
  final Color coverColor;

  const RelatedStoryModel({
    required this.title,
    required this.rating,
    required this.coverColor,
  });
}
