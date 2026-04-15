import 'models/home_content_models.dart';

const String kHomeAppName = 'Panellit';
const String kHomeFeaturedTitle = 'The Azure\nSentinel:\nRebirth';
const String kHomeFeaturedSubtitle =
    'In a world where the stars have\nforgotten their names, one...';

const List<HomeUpdateItem> kHomeUpdates = [
  HomeUpdateItem(
    title: 'Star-Crossed...',
    genre: 'Romance',
    timeAgo: '2h ago',
    episode: 'EP. 142',
    coverTone: 'light',
  ),
  HomeUpdateItem(
    title: 'Void Walker',
    genre: 'Dark Fantasy',
    timeAgo: '5h ago',
    episode: 'EP. 89',
    coverTone: 'dark',
  ),
  HomeUpdateItem(
    title: 'Final Quarter',
    genre: 'Sports',
    timeAgo: '8h ago',
    episode: 'EP. 24',
    coverTone: 'neutral',
  ),
];

const List<HomeRankItem> kHomePopularManga = [
  HomeRankItem(
    rank: '#1',
    title: 'Eternal Horizon',
    description: 'A journey beyond the edge of the known universe.',
  ),
  HomeRankItem(
    rank: '#2',
    title: 'Shadow Architect',
    description: 'Building worlds in darkness of the mind.',
  ),
  HomeRankItem(
    rank: '#3',
    title: 'Cursed Legacy',
    description: 'The sins of the father shall be the power of the son.',
  ),
  HomeRankItem(
    rank: '#4',
    title: 'Wind Whisperer',
    description: 'Listen to the breeze, it tells the tales of old.',
  ),
];

const List<HomeNovelItem> kHomeTopWebnovels = [
  HomeNovelItem(
    number: '01',
    title: 'Solo Ascension: The Infinite Library',
    tag: 'PROGRESSION',
    reads: '1.2M Reads',
  ),
  HomeNovelItem(
    number: '02',
    title: 'My System is a Gacha Machine',
    tag: 'COMEDY',
    reads: '980k Reads',
  ),
  HomeNovelItem(
    number: '03',
    title: 'Reincarnated as a Spirit Forge',
    tag: 'CRAFTING',
    reads: '850k Reads',
  ),
  HomeNovelItem(
    number: '04',
    title: 'The Alchemist of Silent Hill',
    tag: 'MYSTERY',
    reads: '720k Reads',
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
