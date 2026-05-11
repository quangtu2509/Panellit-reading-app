/// API model cho kết quả tìm kiếm từ OTruyen.
class ApiSearchResult {
  final String title;
  final String slug;
  final String cover;
  final String status;
  final List<String> categories;
  final bool isNovel;

  const ApiSearchResult({
    required this.title,
    required this.slug,
    required this.cover,
    required this.status,
    required this.categories,
    this.isNovel = false,
  });

  factory ApiSearchResult.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    return ApiSearchResult(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      categories: rawCategories
          .map((e) => e?.toString())
          .whereType<String>()
          .toList(),
      isNovel: json['isNovel'] == true,
    );
  }
}

/// Wrapper chứa danh sách kết quả tìm kiếm + metadata phân trang.
class ApiSearchResponse {
  final int totalItems;
  final int currentPage;
  final List<ApiSearchResult> items;

  const ApiSearchResponse({
    required this.totalItems,
    required this.currentPage,
    required this.items,
  });

  factory ApiSearchResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return ApiSearchResponse(
      totalItems: (json['totalItems'] as num?)?.toInt() ?? rawItems.length,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map((e) => ApiSearchResult.fromJson(e))
          .toList(),
    );
  }
}
