import 'package:flutter/foundation.dart';

enum MessageAuthor { user, jarvis }

@immutable
class ChatMessage {
  const ChatMessage({required this.author, required this.text});

  final MessageAuthor author;
  final String text;
}
