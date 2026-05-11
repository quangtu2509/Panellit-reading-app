import '../api_client.dart';

/// Model for a single novel fetched from the backend API.
class ApiNovelModel {
  final String id; // may be absent in list response — falls back to slug
  final String slug;
  final String title;
  final String author;
  final String? cover;
  final String pdfUrl;
  final String? description;
  final DateTime createdAt;

  const ApiNovelModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.author,
    this.cover,
    required this.pdfUrl,
    this.description,
    required this.createdAt,
  });

  static String? _fixUrl(String? url) {
    if (url == null) return null;
    return url.replaceFirst('http://localhost:3000', ApiClient.baseUrl);
  }

  factory ApiNovelModel.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['createdAt']?.toString();
    final slug = json['slug']?.toString() ?? '';
    return ApiNovelModel(
      id:          json['id']?.toString() ?? slug,
      slug:        slug,
      title:       json['title']?.toString() ?? 'Untitled',
      author:      json['author']?.toString() ?? 'Unknown',
      cover:       _fixUrl(json['cover']?.toString()),
      pdfUrl:      _fixUrl(json['pdfUrl']?.toString()) ?? '',
      description: json['description']?.toString(),
      createdAt:   rawCreatedAt != null
          ? DateTime.tryParse(rawCreatedAt) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
