import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_ai/ai/agent/jarvis_agent.dart';
import 'package:jarvis_ai/ai/intent/local_intent_parser.dart';
import 'package:jarvis_ai/ai/provider/ai_provider.dart';
import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/ai/tools/settings_tools.dart';
import 'package:jarvis_ai/android_tools/platform_bridge.dart';
import 'package:jarvis_ai/android_tools/tools/get_battery_status_tool.dart';
import 'package:jarvis_ai/android_tools/tools/get_device_info_tool.dart';
import 'package:jarvis_ai/android_tools/tools/get_network_status_tool.dart';
import 'package:jarvis_ai/android_tools/tools/get_volume_tool.dart';
import 'package:jarvis_ai/android_tools/tools/open_application_settings_tool.dart';
import 'package:jarvis_ai/android_tools/tools/open_system_settings_tool.dart';
import 'package:jarvis_ai/android_tools/tools/set_volume_tool.dart';
import 'package:jarvis_ai/features/settings/application/settings_gateway.dart';
import 'package:jarvis_ai/security/safety_filter.dart';

final agentProvider = Provider<JarvisAgent>((ref) {
  final settings = ref.watch(settingsGatewayProvider);
  final bridge = ref.watch(platformBridgeProvider);

  return JarvisAgent(
    safetyFilter: const KeywordSafetyFilter(),
    parser: const LocalIntentParser(),
    tools: ToolRegistry([
      // Танзимоти худи JARVIS
      ChangeThemeTool(settings),
      ChangeVoiceTool(settings),
      ChangeLanguageTool(settings),
      ChangeSpeechSpeedTool(settings),
      // Android tools
      GetBatteryStatusTool(bridge),
      SetVolumeTool(bridge),
      GetVolumeTool(bridge),
      GetDeviceInfoTool(bridge),
      GetNetworkStatusTool(bridge),
      OpenSystemSettingsTool(bridge),
      OpenApplicationSettingsTool(bridge),
    ]),
    permissions: const NoPermissionsGate(),
    aiProvider: const OfflineAiProvider(),
  );
});
