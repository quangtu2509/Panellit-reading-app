import '../../discover/data/models/title_detail_model.dart';
import '../../discover/data/title_detail_mock_data.dart';
import 'models/home_content_models.dart';

const String kHomeAppName = 'Panellit';
const String kHomeFeaturedTitle = 'The Azure\nSentinel:\nRebirth';
const String kHomeFeaturedSubtitle =
    'In a world where the stars have\nforgotten their names, one...';
final TitleDetailModel kHomeFeaturedDetail = kDetailAzureSentinel;

final List<HomeUpdateItem> kHomeUpdates = [
  HomeUpdateItem(
    title: 'Star-Crossed...',
    genre: 'Romance',
    timeAgo: '2h ago',
    episode: 'EP. 142',
    coverTone: 'light',
    detail: kDetailStarCrossed,
  ),
  HomeUpdateItem(
    title: 'Void Walker',
    genre: 'Dark Fantasy',
    timeAgo: '5h ago',
    episode: 'EP. 89',
    coverTone: 'dark',
    detail: kDetailVoidWalker,
  ),
  HomeUpdateItem(
    title: 'Final Quarter',
    genre: 'Sports',
    timeAgo: '8h ago',
    episode: 'EP. 24',
    coverTone: 'neutral',
    detail: kDetailFinalQuarter,
  ),
];

final List<HomeRankItem> kHomePopularManga = [
  HomeRankItem(
    rank: '#1',
    title: 'Eternal Horizon',
    description: 'A journey beyond the edge of the known universe.',
    detail: kDetailEternalHorizon,
  ),
  HomeRankItem(
    rank: '#2',
    title: 'The Azure Sentinel: Rebirth',
    description: 'A sentinel returns to rebuild a fallen order.',
    detail: kDetailAzureSentinel,
  ),
  HomeRankItem(
    rank: '#3',
    title: 'Star-Crossed...',
    description: 'A forbidden bond sparked by a passing comet.',
    detail: kDetailStarCrossed,
  ),
  HomeRankItem(
    rank: '#4',
    title: 'Void Walker',
    description: 'A ranger maps the void between realms.',
    detail: kDetailVoidWalker,
  ),
];

final List<HomeNovelItem> kHomeTopWebnovels = [
  HomeNovelItem(
    number: '01',
    title: 'The Azure Sentinel: Rebirth',
    tag: 'SCI-FI',
    reads: '1.8M Reads',
    detail: kDetailAzureSentinel,
  ),
  HomeNovelItem(
    number: '02',
    title: 'Eternal Horizon',
    tag: 'ADVENTURE',
    reads: '2.2M Reads',
    detail: kDetailEternalHorizon,
  ),
  HomeNovelItem(
    number: '03',
    title: 'Void Walker',
    tag: 'DARK FANTASY',
    reads: '1.2M Reads',
    detail: kDetailVoidWalker,
  ),
  HomeNovelItem(
    number: '04',
    title: 'Final Quarter',
    tag: 'SPORTS',
    reads: '640k Reads',
    detail: kDetailFinalQuarter,
  ),
];

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
