import '../../domain/entities/ai_result.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_datasource.dart';
import '../models/ai_request.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;

  AiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AiResult> askAi({required String prompt}) async {
    final response = await remoteDataSource.ask(AiRequest(prompt: prompt));
    return AiResult(content: response.text, source: 'ai');
  }

  @override
  Future<AiResult> summarizeText({required String input}) async {
    final response = await remoteDataSource.ask(
      AiRequest(prompt: 'Summarize this text', sourceText: input),
    );
    return AiResult(content: response.text, source: 'summary');
  }

  @override
  Future<AiResult> translateText({
    required String input,
    required String from,
    required String to,
  }) async {
    final response = await remoteDataSource.ask(
      AiRequest(
        prompt: 'Translate text',
        sourceText: input,
        sourceLanguage: from,
        targetLanguage: to,
      ),
    );

    return AiResult(content: response.text, source: 'translation');
  }
}
