import '../entities/ai_result.dart';
import '../repositories/ai_repository.dart';

class SummarizeText {
  final AiRepository repository;

  SummarizeText(this.repository);

  Future<AiResult> call({required String input}) {
    return repository.summarizeText(input: input);
  }
}
