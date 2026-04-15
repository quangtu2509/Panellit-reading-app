class HomeUpdateItem {
  final String title;
  final String genre;
  final String timeAgo;
  final String episode;
  final String coverTone;

  const HomeUpdateItem({
    required this.title,
    required this.genre,
    required this.timeAgo,
    required this.episode,
    required this.coverTone,
  });
}

class HomeRankItem {
  final String rank;
  final String title;
  final String description;

  const HomeRankItem({
    required this.rank,
    required this.title,
    required this.description,
  });
}

class HomeNovelItem {
  final String number;
  final String title;
  final String tag;
  final String reads;

  const HomeNovelItem({
    required this.number,
    required this.title,
    required this.tag,
    required this.reads,
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
