import '../entities/ai_result.dart';

abstract class AiRepository {
  Future<AiResult> translateText({
    required String input,
    required String from,
    required String to,
  });

  Future<AiResult> summarizeText({required String input});

  Future<AiResult> askAi({required String prompt});
}
