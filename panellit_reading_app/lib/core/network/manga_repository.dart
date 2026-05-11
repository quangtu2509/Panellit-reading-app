import 'package:panellit_reading_app/core/network/api_client.dart';
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

  Future<ApiMangaDetail> getNovelDetail({
    required String slug,
  }) async {
    try {
      return await _api.getNovelDetail(slug);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch chapter images by the chapter API data URL.
  /// Returns proxy URLs that route through our backend to bypass CDN hotlink protection.
  /// Returns an empty list on failure.
  Future<List<String>> getChapterImages(String chapterApiDataUrl) async {
    try {
      final chapterId = MangaApiService.extractChapterId(chapterApiDataUrl);
      final result = await _api.getChapterImages(chapterId);

      // Rewrite direct CDN URLs to proxy through our backend
      return result.images.map((cdnUrl) {
        final encodedUrl = Uri.encodeComponent(cdnUrl);
        return '${ApiClient.baseUrl}/api/manga/image-proxy?url=$encodedUrl';
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetch paginated manga list for a category/genre slug.
  /// Returns an empty result on failure.
  Future<ApiCategoryResult> getCategoryManga(String slug, {int page = 1}) async {
    try {
      return await _api.getCategoryManga(slug, page: page);
    } catch (_) {
      return ApiCategoryResult(
        categoryName: slug,
        totalItems: 0,
        currentPage: page,
        items: const [],
      );
    }
  }
}

