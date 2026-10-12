import 'package:jarvis_ai/android_tools/platform_bridge.dart';

/// Пули санҷишӣ: ҷавобҳоро аз рӯйхат медиҳад ва қайд мекунад, кадом метод даъват шуд.
class FakePlatformBridge implements PlatformBridge {
  FakePlatformBridge([this.responses = const {}]);

  final Map<String, Map<String, Object?>> responses;
  final List<String> calls = [];
  Map<String, Object?> lastArgs = const {};

  @override
  Future<Map<String, Object?>> call(
    String method, [
    Map<String, Object?> args = const <String, Object?>{},
  ]) async {
    calls.add(method);
    lastArgs = args;
    return responses[method] ?? const <String, Object?>{};
  }
}

/// Пули санҷишӣ, ки гӯё дар платформаи ғайриAndroid аст.
class UnavailableBridge implements PlatformBridge {
  const UnavailableBridge();

  @override
  Future<Map<String, Object?>> call(
    String method, [
    Map<String, Object?> args = const <String, Object?>{},
  ]) async {
    throw const PlatformUnavailableException();
  }
}
