import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/ai/agent/agent_providers.dart';
import 'package:jarvis_ai/features/settings/application/settings_controller.dart';
import 'package:jarvis_ai/features/settings/domain/app_settings.dart';

void main() {
  test('voice command changes the real settings', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final reply = await container
        .read(agentProvider)
        .handle('JARVIS, овозатро занона кун');

    expect(reply.isAction, isTrue);
    expect(container.read(settingsProvider).voice, VoiceType.female);
  });

  test('a question does not change settings', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final reply =
        await container.read(agentProvider).handle('WhatsApp чист?');

    expect(reply.isAction, isFalse);
    expect(container.read(settingsProvider).voice, VoiceType.male);
  });

  test('blocked content is refused', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final reply = await container.read(agentProvider).handle('porn');

    expect(reply.isAction, isFalse);
  });
}
