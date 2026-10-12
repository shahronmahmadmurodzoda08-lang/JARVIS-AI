import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Танзимоти худи JARVIS-ро дар Android мекушояд (иҷозатҳо, огоҳиномаҳо).
class OpenApplicationSettingsTool extends BridgeTool {
  const OpenApplicationSettingsTool(super.bridge);

  @override
  String get name => 'openApplicationSettings';

  @override
  String get description => 'Танзимоти системавии барномаи JARVIS-ро мекушояд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    await bridge.call('openApplicationSettings');
    return const ToolResult.success(AppStrings.appSettingsOpened);
  }
}
