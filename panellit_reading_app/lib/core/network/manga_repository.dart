import 'package:panellit_reading_app/core/network/models/manga_api_model.dart';
import 'package:panellit_reading_app/core/network/services/manga_api_service.dart';

/// Repository that handles data loading from the remote API.
class MangaRepository {
  final MangaApiService _api = MangaApiService();

  /// Fetch manga detail by its OTruyen slug.
  Future<ApiMangaDetail> getMangaDetail({
    required String slug,
  }) async {
    try {
      return await _api.getMangaDetail(slug);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch chapter images by the chapter API data URL.
  /// Returns an empty list on failure.
  Future<List<String>> getChapterImages(String chapterApiDataUrl) async {
    try {
      final chapterId = MangaApiService.extractChapterId(chapterApiDataUrl);
      final result = await _api.getChapterImages(chapterId);
      return result.images;
    } catch (_) {
      return [];
    }
  }
}
