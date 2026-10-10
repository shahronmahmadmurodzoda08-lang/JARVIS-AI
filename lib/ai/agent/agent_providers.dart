import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_ai/ai/agent/jarvis_agent.dart';
import 'package:jarvis_ai/ai/intent/local_intent_parser.dart';
import 'package:jarvis_ai/ai/provider/ai_provider.dart';
import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/ai/tools/settings_tools.dart';
import 'package:jarvis_ai/features/settings/application/settings_gateway.dart';
import 'package:jarvis_ai/security/safety_filter.dart';

final agentProvider = Provider<JarvisAgent>((ref) {
  final settings = ref.watch(settingsGatewayProvider);

  return JarvisAgent(
    safetyFilter: const KeywordSafetyFilter(),
    parser: const LocalIntentParser(),
    tools: ToolRegistry([
      ChangeThemeTool(settings),
      ChangeVoiceTool(settings),
      ChangeLanguageTool(settings),
      ChangeSpeechSpeedTool(settings),
    ]),
    permissions: const NoPermissionsGate(),
    aiProvider: const OfflineAiProvider(),
  );
});
