import 'package:dio/dio.dart';
import '../api_client.dart';
import '../models/bookmark_api_model.dart';

class BookmarkApiService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> toggleBookmark({
    required String mangaSlug,
    int? chapterId,
    required String mangaTitle,
    required String coverUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/api/bookmarks/toggle',
        data: {
          'mangaSlug':  mangaSlug,
          'chapterId':  chapterId,
          'mangaTitle': mangaTitle,
          'coverUrl':   coverUrl,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return {'isSaved': false};
    }
  }

  Future<List<ApiBookmarkItem>> getMyBookmarks() async {
    try {
      final response = await _dio.get('/api/bookmarks/me');
      final rawList = response.data as List<dynamic>? ?? [];
      return rawList.map((e) => ApiBookmarkItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteBookmark(String mangaSlug) async {
    try {
      await _dio.delete('/api/bookmarks/$mangaSlug');
    } catch (_) {
      // Ignore failures
    }
  }
}
