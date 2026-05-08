import '../../../discover/data/models/title_detail_model.dart';

class HomeUpdateItem {
  final String title;
  final String genre;
  final String timeAgo;
  final String episode;
  final String coverTone;
  final String? coverUrl;
  final TitleDetailModel detail;

  const HomeUpdateItem({
    required this.title,
    required this.genre,
    required this.timeAgo,
    required this.episode,
    required this.coverTone,
    this.coverUrl,
    required this.detail,
  });
}

class HomeRankItem {
  final String rank;
  final String title;
  final String description;
  final TitleDetailModel detail;

  const HomeRankItem({
    required this.rank,
    required this.title,
    required this.description,
    required this.detail,
  });
}

class HomeNovelItem {
  final String number;
  final String title;
  final String tag;
  final String reads;
  final TitleDetailModel detail;

  const HomeNovelItem({
    required this.number,
    required this.title,
    required this.tag,
    required this.reads,
    required this.detail,
  });
}

enum HomeNotificationType { savedWorkChapterUpdate, general }

class HomeNotificationItem {
  final HomeNotificationType type;
  final bool isUnread;
  final String title;

  const HomeNotificationItem({
    required this.type,
    required this.isUnread,
    required this.title,
  });
}
