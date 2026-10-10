import 'package:jarvis_ai/ai/tools/jarvis_tool.dart';
import 'package:jarvis_ai/core/constants/app_strings.dart';
import 'package:jarvis_ai/features/settings/application/settings_gateway.dart';
import 'package:jarvis_ai/features/settings/domain/app_settings.dart';

class ChangeThemeTool implements JarvisTool {
  const ChangeThemeTool(this._settings);

  final SettingsGateway _settings;

  @override
  String get name => 'changeTheme';

  @override
  String get description => 'Мавзӯъро иваз мекунад: dark, light ё system.';

  @override
  Set<ToolPermission> get requiredPermissions => const {};

  @override
  Future<ToolResult> execute(Map<String, Object?> args) async {
    final mode = ThemeModeSetting.values.asNameMap()[args['mode']];
    if (mode == null) return const ToolResult.failure(AppStrings.actionFailed);
    _settings.changeTheme(mode);
    return const ToolResult.success(AppStrings.actionDone);
  }
}

class ChangeVoiceTool implements JarvisTool {
  const ChangeVoiceTool(this._settings);

  final SettingsGateway _settings;

  @override
  String get name => 'changeVoice';

  @override
  String get description => 'Овозро иваз мекунад: male ё female.';

  @override
  Set<ToolPermission> get requiredPermissions => const {};

  @override
  Future<ToolResult> execute(Map<String, Object?> args) async {
    final voice = VoiceType.values.asNameMap()[args['voice']];
    if (voice == null) return const ToolResult.failure(AppStrings.actionFailed);
    _settings.changeVoice(voice);
    return const ToolResult.success(AppStrings.actionDone);
  }
}

class ChangeLanguageTool implements JarvisTool {
  const ChangeLanguageTool(this._settings);

  final SettingsGateway _settings;

  @override
  String get name => 'changeLanguage';

  @override
  String get description => 'Забони JARVIS-ро иваз мекунад.';

  @override
  Set<ToolPermission> get requiredPermissions => const {};

  @override
  Future<ToolResult> execute(Map<String, Object?> args) async {
    final language = AppLanguage.values.asNameMap()[args['language']];
    if (language == null) {
      return const ToolResult.failure(AppStrings.actionFailed);
    }
    _settings.changeLanguage(language);
    return const ToolResult.success(AppStrings.actionDone);
  }
}

class ChangeSpeechSpeedTool implements JarvisTool {
  const ChangeSpeechSpeedTool(this._settings);

  final SettingsGateway _settings;

  @override
  String get name => 'changeSpeechSpeed';

  @override
  String get description => 'Суръати овозро бо delta (масалан -0.1) тағйир медиҳад.';

  @override
  Set<ToolPermission> get requiredPermissions => const {};

  @override
  Future<ToolResult> execute(Map<String, Object?> args) async {
    final delta = args['delta'];
    if (delta is! num) return const ToolResult.failure(AppStrings.actionFailed);
    final next = _settings.current.speechSpeed + delta;
    _settings.changeSpeechSpeed((next * 10).round() / 10);
    return const ToolResult.success(AppStrings.actionDone);
  }
}
