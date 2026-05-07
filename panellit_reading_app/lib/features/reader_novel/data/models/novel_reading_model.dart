/// Model for a single chapter in a novel.
class NovelChapter {
  final int number;
  final String title;
  final String content;
  final int wordCount;

  const NovelChapter({
    required this.number,
    required this.title,
    required this.content,
    required this.wordCount,
  });

  String get label => 'Chapter $number';
}

/// Model for a novel available to read.
class NovelReadingModel {
  final String title;
  final String author;
  final List<NovelChapter> chapters;

  const NovelReadingModel({
    required this.title,
    required this.author,
    required this.chapters,
  });
}
