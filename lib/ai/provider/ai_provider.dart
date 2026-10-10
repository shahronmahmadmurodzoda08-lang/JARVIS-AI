import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Xatoi AI provider (masalan, quota tamom shud).
class AiProviderException implements Exception {
  const AiProviderException(this.message);

  final String message;
}

/// AI provider modular ast: baʼdan Gemini/Groq va ғайра ivaz meshavad.
abstract interface class AiProvider {
  Future<String> reply(String userText);
}

/// Provideri muvaqqati: AI hanuz pajvast nashudaast.
class OfflineAiProvider implements AiProvider {
  const OfflineAiProvider();

  @override
  Future<String> reply(String userText) async => AppStrings.aiNotConnected;
}
