import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Сатҳи ҳозираи садоро мегӯяд.
class GetVolumeTool extends BridgeTool {
  const GetVolumeTool(super.bridge);

  @override
  String get name => 'getVolume';

  @override
  String get description => 'Сатҳи ҳозираи садоро бо фоиз мегӯяд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    final data = await bridge.call('getVolume');
    final percent = data['percent'];
    if (percent is! int) {
      return const ToolResult.failure(AppStrings.actionFailed);
    }
    return ToolResult.success('Садо: $percent%.');
  }
}
