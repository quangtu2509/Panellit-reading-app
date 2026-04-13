import 'package:flutter/foundation.dart';

import '../../domain/entities/ai_result.dart';
import '../../domain/usecases/ask_ai.dart';
import '../../domain/usecases/summarize_text.dart';
import '../../domain/usecases/translate_text.dart';

class AiController extends ChangeNotifier {
  final AskAi askAiUseCase;
  final TranslateText translateTextUseCase;
  final SummarizeText summarizeTextUseCase;

  AiController({
    required this.askAiUseCase,
    required this.translateTextUseCase,
    required this.summarizeTextUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  AiResult? _lastResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AiResult? get lastResult => _lastResult;

  Future<void> ask(String prompt) async {
    await _run(() => askAiUseCase(prompt: prompt));
  }

  Future<void> translate({
    required String input,
    required String from,
    required String to,
  }) async {
    await _run(() => translateTextUseCase(input: input, from: from, to: to));
  }

  Future<void> summarize(String input) async {
    await _run(() => summarizeTextUseCase(input: input));
  }

  Future<void> _run(Future<AiResult> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastResult = await action();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
