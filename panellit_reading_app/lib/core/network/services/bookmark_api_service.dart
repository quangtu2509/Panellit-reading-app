import 'package:dio/dio.dart';
import '../api_client.dart';
import '../models/bookmark_api_model.dart';

class BookmarkApiService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> toggleBookmark({
    String? mangaSlug,
    String? novelSlug,
    int? chapterId,
    String? mangaTitle,
    String? novelTitle,
    String? coverUrl,
    List<String>? genres,
  }) async {
    try {
      final data = <String, dynamic>{
        'chapterId': chapterId,
        'coverUrl': coverUrl,
      };
      if (mangaSlug != null) data['mangaSlug'] = mangaSlug;
      if (novelSlug != null) data['novelSlug'] = novelSlug;
      if (mangaTitle != null) data['mangaTitle'] = mangaTitle;
      if (novelTitle != null) data['novelTitle'] = novelTitle;
      if (genres != null) data['genres'] = genres;

      final response = await _dio.post('/api/bookmarks/toggle', data: data);
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
