import '../api_client.dart';
import '../models/novel_api_model.dart';

class NovelApiService {
  final _dio = ApiClient().dio;

  /// Fetches all novels from the backend.
  Future<List<ApiNovelModel>> getNovels() async {
    final response = await _dio.get('/api/novels');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => ApiNovelModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single novel by its slug.
  Future<ApiNovelModel> getNovelBySlug(String slug) async {
    final response = await _dio.get('/api/novels/$slug');
    return ApiNovelModel.fromJson(response.data as Map<String, dynamic>);
  }
}
