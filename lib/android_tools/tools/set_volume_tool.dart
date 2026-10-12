import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Садои медиаро (мусиқӣ, видео) ба фоизи додашуда мегузорад.
class SetVolumeTool extends BridgeTool {
  const SetVolumeTool(super.bridge);

  @override
  String get name => 'setVolume';

  @override
  String get description => 'Садоро ба фоизи додашуда (0-100) мегузорад.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    final raw = args['percent'];
    if (raw is! num) return const ToolResult.failure(AppStrings.actionFailed);

    final percent = raw.round().clamp(0, 100).toInt();
    await bridge.call('setVolume', {'percent': percent});
    return ToolResult.success('Садо: $percent%.');
  }
}
