import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Саҳифаи асосии танзимоти Android-ро мекушояд.
class OpenSystemSettingsTool extends BridgeTool {
  const OpenSystemSettingsTool(super.bridge);

  @override
  String get name => 'openSystemSettings';

  @override
  String get description => 'Танзимоти телефонро мекушояд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    await bridge.call('openSystemSettings');
    return const ToolResult.success(AppStrings.systemSettingsOpened);
  }
}
