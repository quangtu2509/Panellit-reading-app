import '../entities/ai_result.dart';
import '../repositories/ai_repository.dart';

class AskAi {
  final AiRepository repository;

  AskAi(this.repository);

  Future<AiResult> call({required String prompt}) {
    return repository.askAi(prompt: prompt);
  }
}
