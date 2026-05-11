import 'package:flutter/foundation.dart';
import '../api_client.dart';
import '../models/novel_api_model.dart';

class NovelApiService {
  final _dio = ApiClient().dio;

  /// Fetches all novels from the backend.
  Future<List<ApiNovelModel>> getNovels() async {
    try {
      final response = await _dio.get('/api/novels');
      final data = response.data;
      if (data is! List) {
        debugPrint('[NovelApiService] getNovels: unexpected response type ${data.runtimeType}');
        return [];
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => ApiNovelModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('[NovelApiService] getNovels failed: $e');
      return [];
    }
  }

  /// Fetches a single novel by its slug.
  Future<ApiNovelModel> getNovelBySlug(String slug) async {
    final response = await _dio.get('/api/novels/$slug');
    return ApiNovelModel.fromJson(response.data as Map<String, dynamic>);
  }
}
