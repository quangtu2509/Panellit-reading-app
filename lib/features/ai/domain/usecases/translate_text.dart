import '../entities/ai_result.dart';
import '../repositories/ai_repository.dart';

class TranslateText {
  final AiRepository repository;

  TranslateText(this.repository);

  Future<AiResult> call({
    required String input,
    required String from,
    required String to,
  }) {
    return repository.translateText(input: input, from: from, to: to);
  }
}
