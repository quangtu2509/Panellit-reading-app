import 'package:dio/dio.dart';
import '../api_client.dart';
import '../models/history_api_model.dart';

/// Service for reading history API endpoints.
///
/// All endpoints require a Bearer token — it is attached automatically by
/// [ApiClient]'s interceptor, so no manual token handling is needed here.
class HistoryApiService {
  final Dio _dio = ApiClient().dio;

  // ── Sync ───────────────────────────────────────────────────────────────────

  /// Fire-and-forget: record which chapter the user is currently reading.
  ///
  /// [mangaSlug]    — the OTruyen slug (e.g. "one-piece")
  /// [chapterId]    — the chapter_api_data URL / ID from OTruyen
  /// [mangaTitle]   — display title saved with the Manga record
  /// [coverUrl]     — absolute cover image URL
  /// [lastPageIndex] — zero-based page within the chapter (default 0)
  Future<void> syncProgress({
    required String mangaSlug,
    required String chapterId,
    required String mangaTitle,
    required String coverUrl,
    int lastPageIndex = 0,
  }) async {
    try {
      await _dio.post(
        '/api/history/sync',
        data: {
          'mangaSlug':     mangaSlug,
          'chapterId':     chapterId,
          'mangaTitle':    mangaTitle,
          'coverUrl':      coverUrl,
          'lastPageIndex': lastPageIndex,
        },
      );
    } catch (_) {
      // Fire-and-forget: silently ignore failures so the UI is never blocked.
    }
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────

  /// Returns the user's full reading history, ordered newest-first.
  /// Returns an empty list on failure (network error / not logged in).
  Future<List<ApiHistoryItem>> getMyHistory() async {
    try {
      final response = await _dio.get('/api/history/me');
      final rawList  = response.data as List<dynamic>? ?? [];
      return rawList
          .map((e) => ApiHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
