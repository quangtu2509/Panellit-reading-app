import 'history_api_model.dart'; // To reuse ApiMangaRef

class ApiBookmarkItem {
  final String mangaSlug;
  final int? chapterId;
  final DateTime updatedAt;
  final ApiMangaRef manga;

  const ApiBookmarkItem({
    required this.mangaSlug,
    this.chapterId,
    required this.updatedAt,
    required this.manga,
  });

  factory ApiBookmarkItem.fromJson(Map<String, dynamic> json) {
    return ApiBookmarkItem(
      mangaSlug: json['mangaSlug']?.toString() ?? '',
      chapterId: (json['chapterId'] as num?)?.toInt(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      manga: ApiMangaRef.fromJson(json['manga'] as Map<String, dynamic>? ?? {}),
    );
  }
}
