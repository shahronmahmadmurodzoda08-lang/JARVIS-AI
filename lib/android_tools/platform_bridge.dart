import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Платформа (Android) дастрас нест: масалан, дар Windows, Web ё iPhone.
class PlatformUnavailableException implements Exception {
  const PlatformUnavailableException();
}

/// Пули байни Dart ва Android (Kotlin). Tool-ҳо танҳо ба ин интерфейс вобастаанд,
/// бинобар ин онҳоро бе телефон бо Fake санҷидан мумкин аст.
abstract interface class PlatformBridge {
  Future<Map<String, Object?>> call(
    String method, [
    Map<String, Object?> args = const <String, Object?>{},
  ]);
}

/// Иҷрогари воқеӣ: MethodChannel ба MainActivity.kt.
class MethodChannelPlatformBridge implements PlatformBridge {
  const MethodChannelPlatformBridge();

  static const MethodChannel _channel =
      MethodChannel('com.jarvis.jarvis_ai/tools');

  @override
  Future<Map<String, Object?>> call(
    String method, [
    Map<String, Object?> args = const <String, Object?>{},
  ]) async {
    try {
      final result =
          await _channel.invokeMapMethod<String, Object?>(method, args);
      return result ?? const <String, Object?>{};
    } on MissingPluginException {
      throw const PlatformUnavailableException();
    }
  }
}

final platformBridgeProvider = Provider<PlatformBridge>(
  (ref) => const MethodChannelPlatformBridge(),
);
