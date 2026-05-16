// DTO models for the History API responses.

/// A single manga entry within a history item (embedded object from join).
class ApiMangaRef {
  final String slug;
  final String title;
  final String cover;
  final List<String> genres;

  const ApiMangaRef({
    required this.slug,
    required this.title,
    required this.cover,
    this.genres = const [],
  });

  factory ApiMangaRef.fromJson(Map<String, dynamic> json) {
    return ApiMangaRef(
      slug:  json['slug']?.toString()  ?? '',
      title: json['title']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

/// One record from GET /api/history/me — represents a user's last reading position.
class ApiHistoryItem {
  final String? mangaSlug;
  final String? novelSlug;
  final String? chapterId;
  final int lastPageIndex;
  final DateTime updatedAt;
  final ApiMangaRef? manga;
  final ApiMangaRef? novel; // Reusing the same ref model for both

  const ApiHistoryItem({
    this.mangaSlug,
    this.novelSlug,
    this.chapterId,
    required this.lastPageIndex,
    required this.updatedAt,
    this.manga,
    this.novel,
  });

  factory ApiHistoryItem.fromJson(Map<String, dynamic> json) {
    return ApiHistoryItem(
      mangaSlug: json['mangaSlug']?.toString(),
      novelSlug: json['novelSlug']?.toString(),
      chapterId: json['chapterId']?.toString(),
      lastPageIndex: (json['lastPageIndex'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      manga: json['manga'] != null ? ApiMangaRef.fromJson(json['manga'] as Map<String, dynamic>) : null,
      novel: json['novel'] != null ? ApiMangaRef.fromJson(json['novel'] as Map<String, dynamic>) : null,
    );
  }
}
