import 'history_api_model.dart'; // To reuse ApiMangaRef

class ApiBookmarkItem {
  final String? mangaSlug;
  final String? novelSlug;
  final int? chapterId;
  final DateTime updatedAt;
  final ApiMangaRef? manga;
  final ApiMangaRef? novel;

  const ApiBookmarkItem({
    this.mangaSlug,
    this.novelSlug,
    this.chapterId,
    required this.updatedAt,
    this.manga,
    this.novel,
  });

  factory ApiBookmarkItem.fromJson(Map<String, dynamic> json) {
    return ApiBookmarkItem(
      mangaSlug: json['mangaSlug']?.toString(),
      novelSlug: json['novelSlug']?.toString(),
      chapterId: int.tryParse(json['chapterId']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      manga: json['manga'] != null ? ApiMangaRef.fromJson(json['manga'] as Map<String, dynamic>) : null,
      novel: json['novel'] != null ? ApiMangaRef.fromJson(json['novel'] as Map<String, dynamic>) : null,
    );
  }
}
