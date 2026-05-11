import '../api_client.dart';

/// Model for a single novel fetched from the backend API.
class ApiNovelModel {
  final String id;
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
    return ApiNovelModel(
      id:          json['id'] as String,
      slug:        json['slug'] as String,
      title:       json['title'] as String,
      author:      json['author'] as String? ?? 'Unknown',
      cover:       _fixUrl(json['cover'] as String?),
      pdfUrl:      _fixUrl(json['pdfUrl'] as String?) ?? '',
      description: json['description'] as String?,
      createdAt:   DateTime.parse(json['createdAt'] as String),
    );
  }
}
