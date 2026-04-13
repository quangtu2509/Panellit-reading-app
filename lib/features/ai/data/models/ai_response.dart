class AiResponse {
  final String text;
  final String? detectedLanguage;
  final String? model;

  const AiResponse({required this.text, this.detectedLanguage, this.model});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'detected_language': detectedLanguage,
      'model': model,
    };
  }

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      text: json['text'] as String? ?? '',
      detectedLanguage: json['detected_language'] as String?,
      model: json['model'] as String?,
    );
  }
}
