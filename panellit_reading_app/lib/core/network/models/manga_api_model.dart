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
  final List<ApiChapter> chapters;

  const ApiMangaDetail({
    required this.title,
    required this.slug,
    required this.cover,
    required this.author,
    required this.status,
    required this.summary,
    required this.chapters,
  });

  factory ApiMangaDetail.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'] as List<dynamic>? ?? [];
    return ApiMangaDetail(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      author: (json['author'] as List<dynamic>?)?.join(', ') ?? 'Unknown',
      status: json['status']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      chapters: rawChapters.map((c) => ApiChapter.fromJson(c as Map<String, dynamic>)).toList(),
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
    return ApiChapterImages(
      chapterId: json['chapterId']?.toString() ?? '',
      images: List<String>.from(json['images'] as List? ?? []),
    );
  }
}
