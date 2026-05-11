import 'package:dio/dio.dart';
import 'package:panellit_reading_app/core/network/api_client.dart';
import 'package:panellit_reading_app/core/network/models/manga_api_model.dart';

/// Service layer for all Manga-related API calls to the Panellit Backend.
class MangaApiService {
  final Dio _dio = ApiClient().dio;

  /// Fetch manga metadata by slug.
  /// Calls: GET /api/manga/{slug}
  Future<ApiMangaDetail> getMangaDetail(String slug) async {
    try {
      final response = await _dio.get('/api/manga/$slug');
      return ApiMangaDetail.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e, 'getMangaDetail($slug)');
    }
  }

  /// Fetch novel metadata by slug.
  /// Calls: GET /api/novels/{slug}
  Future<ApiMangaDetail> getNovelDetail(String slug) async {
    try {
      final response = await _dio.get('/api/novels/$slug');
      final data = response.data as Map<String, dynamic>;
      final rawCover = data['cover']?.toString() ?? '';
      final fixedCover = rawCover.replaceFirst('http://localhost:3000', ApiClient.baseUrl);
      
      final rawPdf = data['pdfUrl']?.toString() ?? '';
      final fixedPdf = rawPdf.replaceFirst('http://localhost:3000', ApiClient.baseUrl);

      return ApiMangaDetail(
        title:      data['title']?.toString() ?? '',
        slug:       data['slug']?.toString() ?? slug,
        cover:      fixedCover,
        author:     data['author']?.toString() ?? 'Unknown',
        status:     'Light Novel',
        summary:    data['description']?.toString() ?? '',
        categories: ['Light Novel'],
        pdfUrl:     fixedPdf,
        chapters:   [
          const ApiChapter(
            chapterName: '1',
            chapterTitle: 'Full Volume',
            chapterApiData: '',
          )
        ], // Novels use PDF reader, provide one dummy chapter for the UI
      );
    } on DioException catch (e) {
      throw _handleError(e, 'getNovelDetail($slug)');
    }
  }

  /// Fetch chapter images by chapter ID.
  /// The chapter ID is extracted from the chapter_api_data URL.
  /// Calls: GET /api/manga/chapter/{chapterId}
  Future<ApiChapterImages> getChapterImages(String chapterId) async {
    try {
      final response = await _dio.get('/api/manga/chapter/$chapterId');
      return ApiChapterImages.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e, 'getChapterImages($chapterId)');
    }
  }

  /// Fetch a paginated list of manga for a given category slug.
  /// Calls: GET /api/manga/category/{slug}?page={page}
  Future<ApiCategoryResult> getCategoryManga(String slug, {int page = 1}) async {
    try {
      final response = await _dio.get('/api/manga/category/$slug', queryParameters: {'page': page});
      return ApiCategoryResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e, 'getCategoryManga($slug)');
    }
  }

  /// Extract the chapter ID from a chapter_api_data URL.
  /// Example: "https://sv1.otruyencdn.com/v1/api/chapter/6568621ae120ddf21985fed6"
  /// → returns "6568621ae120ddf21985fed6"
  static String extractChapterId(String chapterApiDataUrl) {
    return chapterApiDataUrl.split('/').last;
  }

  // ── Private Helpers ──────────────────────────────────────────────────────

  Exception _handleError(DioException e, String context) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['error']?.toString() ?? e.message;
    return Exception('[$context] Error $statusCode: $message');
  }
}
