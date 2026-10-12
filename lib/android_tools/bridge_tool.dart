import 'package:flutter/services.dart';
import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/android_tools/platform_bridge.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';

/// Асоси ҳамаи tool-ҳое, ки ба Android муроҷиат мекунанд.
/// Хатогиро якҷоя идора мекунад: дар платформаи ғайриAndroid паёми равшан медиҳад.
abstract class BridgeTool implements JarvisTool {
  const BridgeTool(this.bridge);

  final PlatformBridge bridge;

  @override
  Set<ToolPermission> get requiredPermissions => const {};

  Future<ToolResult> run(Map<String, Object?> args);

  @override
  Future<ToolResult> execute(Map<String, Object?> args) async {
    try {
      return await run(args);
    } on PlatformUnavailableException {
      return const ToolResult.failure(AppStrings.androidOnly);
    } on PlatformException {
      return const ToolResult.failure(AppStrings.actionFailed);
    }
  }
}
