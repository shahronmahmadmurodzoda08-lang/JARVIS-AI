import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/ai/agent/agent_providers.dart';
import 'package:jarvis_ai/ai/intent/local_intent_parser.dart';
import 'package:jarvis_ai/android_tools/platform_bridge.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

import '../helpers/fake_platform_bridge.dart';

void main() {
  group('LocalIntentParser: Android commands', () {
    const parser = LocalIntentParser();

    test('set volume', () {
      final call = parser.parse('JARVIS, садоро 50 фоиз кун');
      expect(call?.name, 'setVolume');
      expect(call?.args['percent'], 50);
    });

    test('volume above 100 is limited to 100', () {
      final call = parser.parse('JARVIS, садоро 150 фоиз кун');
      expect(call?.args['percent'], 100);
    });

    test('get volume', () {
      final call = parser.parse('JARVIS, садо чанд фоиз аст, бигӯ');
      expect(call?.name, 'getVolume');
    });

    test('battery', () {
      final call = parser.parse('JARVIS, заряди батареяро нишон деҳ');
      expect(call?.name, 'getBatteryStatus');
    });

    test('network', () {
      final call = parser.parse('JARVIS, интернетро санҷ');
      expect(call?.name, 'getNetworkStatus');
    });

    test('device info', () {
      final call = parser.parse('JARVIS, маълумоти дастгоҳро нишон деҳ');
      expect(call?.name, 'getDeviceInfo');
    });

    test('phone settings', () {
      final call = parser.parse('JARVIS, танзимоти телефонро кушо');
      expect(call?.name, 'openSystemSettings');
    });

    test('application settings', () {
      final call = parser.parse('JARVIS, танзимоти барнома кушо');
      expect(call?.name, 'openApplicationSettings');
    });

    test('without wake word nothing is executed', () {
      expect(parser.parse('садоро 50 фоиз кун'), isNull);
    });

    test('a question is conversation, not an action', () {
      expect(parser.parse('JARVIS, батарея чист?'), isNull);
    });
  });

  group('JarvisAgent with Android tools', () {
    ProviderContainer containerWith(PlatformBridge bridge) {
      final container = ProviderContainer(
        overrides: [platformBridgeProvider.overrideWithValue(bridge)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('volume command calls the platform with the percent', () async {
      final bridge = FakePlatformBridge();
      final container = containerWith(bridge);

      final reply = await container
          .read(agentProvider)
          .handle('JARVIS, садоро 50 фоиз кун');

      expect(bridge.calls, ['setVolume']);
      expect(bridge.lastArgs['percent'], 50);
      expect(reply.isAction, isTrue);
      expect(reply.text, contains('50%'));
    });

    test('battery command reads the platform answer', () async {
      final bridge = FakePlatformBridge({
        'getBatteryStatus': {'percent': 85, 'charging': true},
      });
      final container = containerWith(bridge);

      final reply = await container
          .read(agentProvider)
          .handle('JARVIS, заряди батареяро нишон деҳ');

      expect(reply.isAction, isTrue);
      expect(reply.text, contains('85%'));
    });

    test('network command reports Wi-Fi', () async {
      final bridge = FakePlatformBridge({
        'getNetworkStatus': {'connected': true, 'type': 'wifi'},
      });
      final container = containerWith(bridge);

      final reply = await container
          .read(agentProvider)
          .handle('JARVIS, интернетро санҷ');

      expect(reply.text, contains('Wi-Fi'));
    });

    test('a question does not call the platform', () async {
      final bridge = FakePlatformBridge();
      final container = containerWith(bridge);

      final reply =
          await container.read(agentProvider).handle('JARVIS, батарея чист?');

      expect(bridge.calls, isEmpty);
      expect(reply.isAction, isFalse);
    });

    test('outside Android the user gets a clear message', () async {
      final container = containerWith(const UnavailableBridge());

      final reply = await container
          .read(agentProvider)
          .handle('JARVIS, заряди батареяро нишон деҳ');

      expect(reply.text, AppStrings.androidOnly);
    });
  });
}
