import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/ai/intent/local_intent_parser.dart';

void main() {
  const parser = LocalIntentParser();

  test('theme command is parsed', () {
    final call = parser.parse('JARVIS, theme-ро dark кун');
    expect(call?.name, 'changeTheme');
    expect(call?.args['mode'], 'dark');
  });

  test('language command is parsed', () {
    final call = parser.parse('JARVIS, забонро ба русӣ иваз кун');
    expect(call?.name, 'changeLanguage');
    expect(call?.args['language'], 'russian');
  });

  test('female voice command is parsed', () {
    final call = parser.parse('JARVIS, овозатро занона кун');
    expect(call?.name, 'changeVoice');
    expect(call?.args['voice'], 'female');
  });

  test('speech speed command is parsed', () {
    final call = parser.parse('JARVIS, суръати овозатро кам кун');
    expect(call?.name, 'changeSpeechSpeed');
    expect(call?.args['delta'], -0.1);
  });

  test('a question is conversation, not an action', () {
    expect(parser.parse('WhatsApp чист?'), isNull);
    expect(parser.parse('theme чист?'), isNull);
  });
}
