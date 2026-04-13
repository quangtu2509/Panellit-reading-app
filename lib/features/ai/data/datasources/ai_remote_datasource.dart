import '../models/ai_request.dart';
import '../models/ai_response.dart';

abstract class AiRemoteDataSource {
  Future<AiResponse> ask(AiRequest request);
}
