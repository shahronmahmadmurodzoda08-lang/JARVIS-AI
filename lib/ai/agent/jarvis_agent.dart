import 'package:jarvis_ai/ai/intent/local_intent_parser.dart';
import 'package:jarvis_ai/ai/models/ai_models.dart';
import 'package:jarvis_ai/ai/provider/ai_provider.dart';
import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';
import 'package:jarvis_ai/security/safety_filter.dart';

/// Magzi JARVIS:
/// Safety -> Intent -> Tool -> Permission -> Result, ё suhbat bo AiProvider.
class JarvisAgent {
  const JarvisAgent({
    required SafetyFilter safetyFilter,
    required LocalIntentParser parser,
    required ToolRegistry tools,
    required PermissionGate permissions,
    required AiProvider aiProvider,
  })  : _safety = safetyFilter,
        _parser = parser,
        _tools = tools,
        _permissions = permissions,
        _ai = aiProvider;

  final SafetyFilter _safety;
  final LocalIntentParser _parser;
  final ToolRegistry _tools;
  final PermissionGate _permissions;
  final AiProvider _ai;

  Future<AgentReply> handle(String text) async {
    if (!_safety.check(text).allowed) {
      return const AgentReply(AppStrings.blockedRequest);
    }

    final call = _parser.parse(text);
    if (call != null) return _runTool(call);

    try {
      return AgentReply(await _ai.reply(text));
    } on AiProviderException catch (e) {
      return AgentReply(e.message);
    }
  }

  Future<AgentReply> _runTool(ToolCall call) async {
    final tool = _tools.find(call.name);
    if (tool == null) return const AgentReply(AppStrings.actionFailed);

    final granted = await _permissions.isGranted(tool.requiredPermissions);
    if (!granted) {
      return const AgentReply(AppStrings.permissionMissing, isAction: true);
    }

    final result = await tool.execute(call.args);
    return AgentReply(result.message, isAction: true);
  }
}
