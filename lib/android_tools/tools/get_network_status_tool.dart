import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/bridge_tool.dart';

/// Ҳолати интернетро мегӯяд: Wi-Fi, мобилӣ ё қатъ.
class GetNetworkStatusTool extends BridgeTool {
  const GetNetworkStatusTool(super.bridge);

  @override
  String get name => 'getNetworkStatus';

  @override
  String get description => 'Ҳолати пайвастшавӣ ба интернетро мегӯяд.';

  @override
  Future<ToolResult> run(Map<String, Object?> args) async {
    final data = await bridge.call('getNetworkStatus');
    if (data['connected'] != true) {
      return const ToolResult.success('Интернет нест.');
    }

    final label = switch (data['type']) {
      'wifi' => 'Wi-Fi',
      'cellular' => 'интернети мобилӣ',
      'ethernet' => 'Ethernet',
      _ => 'шабака',
    };
    return ToolResult.success('Интернет: $label.');
  }
}
