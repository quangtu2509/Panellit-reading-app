import 'package:dio/dio.dart';
import 'package:panellit_reading_app/core/network/api_client.dart';
import 'package:panellit_reading_app/core/network/models/search_api_model.dart';

/// Service gọi endpoint tìm kiếm truyện từ Backend.
class SearchApiService {
  final Dio _dio = ApiClient().dio;

  /// Tìm kiếm truyện theo từ khóa.
  /// Gọi: GET /api/manga/search?keyword={keyword}&page={page}
  Future<ApiSearchResponse> searchManga({
    required String keyword,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/api/manga/search',
        queryParameters: {
          'keyword': keyword,
          'page': page,
        },
      );
      return ApiSearchResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message =
          e.response?.data?['error']?.toString() ?? e.message ?? 'Unknown error';
      throw Exception('[SearchApiService] Error $statusCode: $message');
    }
  }
}
