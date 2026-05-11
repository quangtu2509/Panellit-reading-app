/// Model representing a chapter returned from the Panellit Backend.
class ApiChapter {
  final String chapterName;
  final String chapterTitle;
  final String chapterApiData; // Full URL to fetch images

  const ApiChapter({
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ApiChapter.fromJson(Map<String, dynamic> json) {
    return ApiChapter(
      chapterName: json['chapter_name']?.toString() ?? '',
      chapterTitle: json['chapter_title']?.toString() ?? '',
      chapterApiData: json['chapter_api_data']?.toString() ?? '',
    );
  }
}

/// Model representing manga details returned from the Panellit Backend.
class ApiMangaDetail {
  final String title;
  final String slug;
  final String cover;
  final String author;
  final String status;
  final String summary;
  final List<String> categories;
  final List<ApiChapter> chapters;
  final String? pdfUrl;

  const ApiMangaDetail({
    required this.title,
    required this.slug,
    required this.cover,
    required this.author,
    required this.status,
    required this.summary,
    required this.categories,
    required this.chapters,
    this.pdfUrl,
  });

  factory ApiMangaDetail.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'] as List<dynamic>? ?? [];
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    final rawAuthor = json['author'];
    return ApiMangaDetail(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      author: rawAuthor is List
          ? rawAuthor.map((e) => e?.toString() ?? '').join(', ')
          : rawAuthor?.toString() ?? 'Unknown',
      status: json['status']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      categories: rawCategories
          .map((e) => e?.toString())
          .whereType<String>()
          .toList(),
      chapters: rawChapters
          .whereType<Map<String, dynamic>>()
          .map((c) => ApiChapter.fromJson(c))
          .toList(),
    );
  }
}

/// Model representing chapter images returned from the Panellit Backend.
class ApiChapterImages {
  final String chapterId;
  final List<String> images;

  const ApiChapterImages({
    required this.chapterId,
    required this.images,
  });

  factory ApiChapterImages.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>? ?? [];
    return ApiChapterImages(
      chapterId: json['chapterId']?.toString() ?? '',
      images: rawImages
          .map((e) => e?.toString())
          .whereType<String>()
          .toList(),
    );
  }
}

/// One manga item from a category listing.
class ApiCategoryItem {
  final String title;
  final String slug;
  final String cover;
  final String status;
  final List<String> categories;
  final String latestChapterName;

  const ApiCategoryItem({
    required this.title,
    required this.slug,
    required this.cover,
    required this.status,
    required this.categories,
    required this.latestChapterName,
  });

  factory ApiCategoryItem.fromJson(Map<String, dynamic> json) {
    final chapters = json['chaptersLatest'] as List<dynamic>? ?? [];
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    return ApiCategoryItem(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      categories: rawCategories
          .map((e) => e?.toString())
          .whereType<String>()
          .toList(),
      latestChapterName: chapters.isNotEmpty && chapters.first is Map
          ? (chapters.first['chapterName']?.toString() ?? '')
          : '',
    );
  }
}

/// Paginated result from GET /api/manga/category/:slug
class ApiCategoryResult {
  final String categoryName;
  final int totalItems;
  final int currentPage;
  final List<ApiCategoryItem> items;

  const ApiCategoryResult({
    required this.categoryName,
    required this.totalItems,
    required this.currentPage,
    required this.items,
  });

  factory ApiCategoryResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return ApiCategoryResult(
      categoryName: json['categoryName']?.toString() ?? '',
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      items: rawItems
          .map((e) => ApiCategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
