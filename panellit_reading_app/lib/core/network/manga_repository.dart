import 'package:panellit_reading_app/core/data/mock_database.dart';
import 'package:panellit_reading_app/core/network/models/manga_api_model.dart';
import 'package:panellit_reading_app/core/network/services/manga_api_service.dart';

/// Result type for safe data loading — either [ApiMangaDetail] or a fallback [MockTitle].
class MangaResult {
  final ApiMangaDetail? apiData;
  final MockTitle? mockData;
  final bool isFromApi;
  final String? errorMessage;

  const MangaResult.api(ApiMangaDetail data)
      : apiData = data,
        mockData = null,
        isFromApi = true,
        errorMessage = null;

  const MangaResult.mock(MockTitle data, {String? error})
      : apiData = null,
        mockData = data,
        isFromApi = false,
        errorMessage = error;
}

/// Repository that mediates between the remote API and local Mock Data.
///
/// Strategy:
/// 1. Try to fetch real data from the Panellit Backend (OTruyen integration).
/// 2. If the request fails (network error, backend offline), fall back to MockDatabase.
class MangaRepository {
  final MangaApiService _api = MangaApiService();

  /// Fetch manga detail by its OTruyen slug.
  /// Falls back to mock data using the [mockId] if the API call fails.
  Future<MangaResult> getMangaDetail({
    required String slug,
    required String mockId,
  }) async {
    try {
      final data = await _api.getMangaDetail(slug);
      return MangaResult.api(data);
    } catch (e) {
      // Graceful fallback to local MockDatabase
      final mockFallback = MockDatabase.titles.firstWhere(
        (t) => t.id == mockId,
        orElse: () => MockDatabase.titles.first,
      );
      return MangaResult.mock(mockFallback, error: e.toString());
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
