import '../../../../core/data/mock_database.dart';
import '../../discover/data/title_detail_mock_data.dart';
import 'models/library_completed_item.dart';
import 'models/library_item.dart';
import 'models/library_reading_item.dart';

const int kLibraryTotalTitles = 5;

final List<LibraryItem> kFollowingLibraryItems = MockDatabase.titles
    .take(4)
    .toList()
    .asMap()
    .entries
    .map((entry) => LibraryItem(
          title: entry.value.title,
          genre: entry.value.genres.last,
          updatedHoursAgo: (entry.key + 1) * 2,
          chapter: entry.value.chapters.isNotEmpty
              ? 'Ch. ${entry.value.chapters.first.number}'
              : 'Ch. 1',
          actionLabel: entry.key % 2 == 0 ? 'Continue' : 'Read Now',
          badge: entry.key < 2 ? 'NEW' : null,
          coverColor: entry.value.coverColor,
          detail: getDetailModelForTitle(entry.value.title),
        ))
    .toList();

final List<LibraryReadingItem> kReadingLibraryItems = MockDatabase.titles
    .take(4)
    .toList()
    .asMap()
    .entries
    .map((entry) => LibraryReadingItem(
          title: entry.value.title,
          typeLabel: entry.value.type.toUpperCase(),
          unitLabel: 'Chapter',
          currentUnit: entry.value.chapters.isNotEmpty ? entry.value.chapters.length ~/ 2 : 1,
          totalUnit: entry.value.chapters.length,
          lastReadHoursAgo: (entry.key + 1) * 3,
          coverColor: entry.value.coverColor,
          detail: getDetailModelForTitle(entry.value.title),
        ))
    .toList();

final List<LibraryCompletedItem> kCompletedLibraryItems = MockDatabase.titles
    .take(3)
    .toList()
    .asMap()
    .entries
    .map((entry) => LibraryCompletedItem(
          title: entry.value.title,
          typeLabel: entry.value.type.toUpperCase(),
          unitLabel: 'Chapter',
          totalUnit: entry.value.chapters.length,
          completedHoursAgo: (entry.key + 1) * 24,
          rating: entry.value.rating,
          coverColor: entry.value.coverColor,
          detail: getDetailModelForTitle(entry.value.title),
        ))
    .toList();
