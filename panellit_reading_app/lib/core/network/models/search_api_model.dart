/// API model cho kết quả tìm kiếm từ OTruyen.
class ApiSearchResult {
  final String title;
  final String slug;
  final String cover;
  final String status;
  final List<String> categories;

  const ApiSearchResult({
    required this.title,
    required this.slug,
    required this.cover,
    required this.status,
    required this.categories,
  });

  factory ApiSearchResult.fromJson(Map<String, dynamic> json) {
    return ApiSearchResult(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      categories: List<String>.from(json['categories'] as List? ?? []),
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
          .map((e) => ApiSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
