class AiRequest {
  final String prompt;
  final String? sourceText;
  final String? sourceLanguage;
  final String? targetLanguage;

  const AiRequest({
    required this.prompt,
    this.sourceText,
    this.sourceLanguage,
    this.targetLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'source_text': sourceText,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
    };
  }

  factory AiRequest.fromJson(Map<String, dynamic> json) {
    return AiRequest(
      prompt: json['prompt'] as String? ?? '',
      sourceText: json['source_text'] as String?,
      sourceLanguage: json['source_language'] as String?,
      targetLanguage: json['target_language'] as String?,
    );
  }
}
