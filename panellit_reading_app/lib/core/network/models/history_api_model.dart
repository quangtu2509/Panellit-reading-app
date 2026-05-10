// DTO models for the History API responses.

/// A single manga entry within a history item (embedded object from join).
class ApiMangaRef {
  final String slug;
  final String title;
  final String cover;

  const ApiMangaRef({
    required this.slug,
    required this.title,
    required this.cover,
  });

  factory ApiMangaRef.fromJson(Map<String, dynamic> json) {
    return ApiMangaRef(
      slug:  json['slug']?.toString()  ?? '',
      title: json['title']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
    );
  }
}

/// One record from GET /api/history/me — represents a user's last reading position.
class ApiHistoryItem {
  final String mangaSlug;
  final String chapterId;
  final int lastPageIndex;
  final DateTime updatedAt;
  final ApiMangaRef manga;

  const ApiHistoryItem({
    required this.mangaSlug,
    required this.chapterId,
    required this.lastPageIndex,
    required this.updatedAt,
    required this.manga,
  });

  factory ApiHistoryItem.fromJson(Map<String, dynamic> json) {
    return ApiHistoryItem(
      mangaSlug:     json['mangaSlug']?.toString() ?? '',
      chapterId:     json['chapterId']?.toString() ?? '',
      lastPageIndex: (json['lastPageIndex'] as num?)?.toInt() ?? 0,
      updatedAt:     DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
                     DateTime.now(),
      manga:         ApiMangaRef.fromJson(
                       json['manga'] as Map<String, dynamic>? ?? {},
                     ),
    );
  }
}
