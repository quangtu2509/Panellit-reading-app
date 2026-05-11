import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:panellit_reading_app/core/network/api_client.dart';
import 'package:panellit_reading_app/core/network/models/home_feed_model.dart';

/// Service for Home Feed API calls.
class HomeFeedService {
  final Dio _dio = ApiClient().dio;

  /// Fetch home feed — newly updated manga list from OTruyen.
  /// Calls: GET /api/manga/home?page={page}
  Future<List<ApiHomeFeedItem>> getHomeFeed({int page = 1}) async {
    try {
      final response = await _dio.get('/api/manga/home', queryParameters: {'page': page});
      final data = response.data;
      if (data is! List) {
        debugPrint('[HomeFeedService] Unexpected response type: ${data.runtimeType}');
        return [];
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => ApiHomeFeedItem.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('[HomeFeedService] getHomeFeed failed: $e');
      return [];
    }
  }
}
