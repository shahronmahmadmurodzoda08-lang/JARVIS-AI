import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';

/// Маълумоти асосии дастгоҳ: истеҳсолкунанда, модел, версияи Android.
class GetDeviceInfoTool extends BridgeTool {
  const GetDeviceInfoTool(super.bridge);

  @override
  String get name => 'getDeviceInfo';

  @override
  String get description => 'Маълумоти асосии дастгоҳро мегӯяд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    final data = await bridge.call('getDeviceInfo');
    return ToolResult.success(
      'Дастгоҳ: ${data['manufacturer']} ${data['model']}. '
      'Android ${data['androidVersion']} (API ${data['sdk']}).',
    );
  }
}
