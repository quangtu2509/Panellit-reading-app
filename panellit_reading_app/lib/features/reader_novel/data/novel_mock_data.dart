import '../../../../core/data/mock_database.dart';
import 'models/novel_reading_model.dart';

/// Mock data for the novel reader — "Elara and the Forgotten Kingdom".
/// Dynamically mapped from the central MockDatabase.
NovelReadingModel getNovelModelForTitle(String title) {
  final novelMock = MockDatabase.titles.firstWhere(
    (t) => t.title == title,
    orElse: () => MockDatabase.titles.firstWhere((t) => t.type == 'Novel', orElse: () => MockDatabase.titles.first),
  );

  return NovelReadingModel(
    title: novelMock.title,
    author: novelMock.author,
    chapters: novelMock.chapters
        .map((c) => NovelChapter(
              number: c.number,
              title: c.title,
              wordCount: c.wordCount ?? 2000,
              content: c.content ?? 'Content coming soon...',
            ))
        .toList(),
  );
}
