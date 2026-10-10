import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_ai/ai/agent/agent_providers.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';
import 'package:jarvis_ai/features/chat/domain/chat_message.dart';

/// Holati suhbat. UI -> Controller -> Agent -> Tool.
class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => const [
        ChatMessage(author: MessageAuthor.jarvis, text: AppStrings.greeting),
      ];

  Future<void> sendText(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = [
      ...state,
      ChatMessage(author: MessageAuthor.user, text: trimmed),
    ];

    final reply = await ref.read(agentProvider).handle(trimmed);

    state = [
      ...state,
      ChatMessage(author: MessageAuthor.jarvis, text: reply.text),
    ];
  }
}

final chatProvider =
    NotifierProvider<ChatController, List<ChatMessage>>(ChatController.new);
