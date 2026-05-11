/// Một mục trong danh sách Home Feed từ API OTruyen.
class ApiHomeFeedItem {
  final String title;
  final String slug;
  final String cover;
  final String status;
  final List<String> categories;
  final String updatedAt;
  final List<ApiLatestChapter> chaptersLatest;

  const ApiHomeFeedItem({
    required this.title,
    required this.slug,
    required this.cover,
    required this.status,
    required this.categories,
    required this.updatedAt,
    required this.chaptersLatest,
  });

  factory ApiHomeFeedItem.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chaptersLatest'] as List<dynamic>? ?? [];
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    return ApiHomeFeedItem(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      categories: rawCategories
          .map((e) => e?.toString())
          .whereType<String>()
          .toList(),
      updatedAt: json['updatedAt']?.toString() ?? '',
      chaptersLatest: rawChapters
          .whereType<Map<String, dynamic>>()
          .map((c) => ApiLatestChapter.fromJson(c))
          .toList(),
    );
  }
}

class ApiLatestChapter {
  final String chapterName;
  final String chapterApiData;

  const ApiLatestChapter({
    required this.chapterName,
    required this.chapterApiData,
  });

  factory ApiLatestChapter.fromJson(Map<String, dynamic> json) {
    return ApiLatestChapter(
      chapterName: json['chapterName']?.toString() ?? '',
      chapterApiData: json['chapterApiData']?.toString() ?? '',
    );
  }
}
