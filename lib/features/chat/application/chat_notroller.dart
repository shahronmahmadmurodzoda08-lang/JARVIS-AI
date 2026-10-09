import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../domain/chat_message.dart';

/// Ҳолати сӯҳбат. Ҳоло ҷавоби муваққатӣ медиҳад;
/// дар қадамҳои оянда ба AI Agent пайваст мешавад (UI → Controller → Agent).
class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => const [
        ChatMessage(author: MessageAuthor.jarvis, text: AppStrings.greeting),
      ];

  void sendText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    state = [
      ...state,
      ChatMessage(author: MessageAuthor.user, text: trimmed),
      const ChatMessage(
        author: MessageAuthor.jarvis,
        text: AppStrings.aiNotConnected,
      ),
    ];
  }
}

final chatProvider =
    NotifierProvider<ChatController, List<ChatMessage>>(ChatController.new);
