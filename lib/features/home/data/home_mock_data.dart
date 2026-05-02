import '../../../../core/data/mock_database.dart';
import '../../discover/data/models/title_detail_model.dart';
import '../../discover/data/title_detail_mock_data.dart';
import 'models/home_content_models.dart';

const String kHomeAppName = 'Panellit';
const String kHomeFeaturedTitle = 'The Azure\nSentinel:\nRebirth';
const String kHomeFeaturedSubtitle =
    'In a world where the stars have\nforgotten their names, one...';
final TitleDetailModel kHomeFeaturedDetail = getDetailModelForTitle('The Azure Sentinel: Rebirth');



final List<HomeUpdateItem> kHomeUpdates = MockDatabase.titles
    .take(3)
    .map((t) => HomeUpdateItem(
          title: t.title,
          genre: t.genres.last, // Pick a specific genre
          timeAgo: t.chapters.isNotEmpty ? t.chapters.first.timeLabel : 'Just now',
          episode: t.chapters.isNotEmpty ? 'EP. ${t.chapters.first.number}' : 'EP. 1',
          coverTone: 'neutral', // Fixed or derived
          detail: getDetailModelForTitle(t.title),
        ))
    .toList();

final List<HomeRankItem> kHomePopularManga = MockDatabase.titles
    .where((t) => t.type == 'Manga')
    .toList()
    .asMap()
    .entries
    .map((entry) => HomeRankItem(
          rank: '#${entry.key + 1}',
          title: entry.value.title,
          description: '${entry.value.synopsis.split('.').first}.', // First sentence
          detail: getDetailModelForTitle(entry.value.title),
        ))
    .toList();

final List<HomeNovelItem> kHomeTopWebnovels = MockDatabase.titles
    .where((t) => t.type == 'Novel')
    .toList()
    .asMap()
    .entries
    .map((entry) => HomeNovelItem(
          number: '0${entry.key + 1}',
          title: entry.value.title,
          tag: entry.value.genres.last.toUpperCase(),
          reads: entry.value.readsLabel,
          detail: getDetailModelForTitle(entry.value.title),
        ))
    .toList();

const List<HomeNotificationItem> kHomeNotifications = [
  HomeNotificationItem(
    type: HomeNotificationType.savedWorkChapterUpdate,
    isUnread: true,
    title: 'Shadow Realm Chronicles has a new chapter',
  ),
  HomeNotificationItem(
    type: HomeNotificationType.general,
    isUnread: false,
    title: 'Weekly reading digest is ready',
  ),
];
