import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Сатҳи заряди батареяро мегӯяд.
class GetBatteryStatusTool extends BridgeTool {
  const GetBatteryStatusTool(super.bridge);

  @override
  String get name => 'getBatteryStatus';

  @override
  String get description => 'Сатҳи заряди батареяро мегӯяд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    final data = await bridge.call('getBatteryStatus');
    final percent = data['percent'];
    if (percent is! int || percent < 0) {
      return const ToolResult.failure(AppStrings.actionFailed);
    }
    final charging = data['charging'] == true;
    return ToolResult.success(
      charging ? 'Заряд: $percent%, дар ҳоли заряд.' : 'Заряд: $percent%.',
    );
  }
}
