import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_ai/features/settings/application/settings_controller.dart';
import 'package:jarvis_ai/features/settings/domain/app_settings.dart';

/// Rohi yagonai tools baroi taghiri tanzimot (AI Core ba UI vobasta nest).
abstract interface class SettingsGateway {
  AppSettings get current;

  void changeVoice(VoiceType voice);
  void changeLanguage(AppLanguage language);
  void changeSpeechSpeed(double speed);
  void changeTheme(ThemeModeSetting mode);
}

class RiverpodSettingsGateway implements SettingsGateway {
  RiverpodSettingsGateway(this._ref);

  final Ref _ref;

  @override
  AppSettings get current => _ref.read(settingsProvider);

  @override
  void changeVoice(VoiceType voice) =>
      _ref.read(settingsProvider.notifier).changeVoice(voice);

  @override
  void changeLanguage(AppLanguage language) =>
      _ref.read(settingsProvider.notifier).changeLanguage(language);

  @override
  void changeSpeechSpeed(double speed) =>
      _ref.read(settingsProvider.notifier).changeSpeechSpeed(speed);

  @override
  void changeTheme(ThemeModeSetting mode) =>
      _ref.read(settingsProvider.notifier).changeTheme(mode);
}

final settingsGatewayProvider = Provider<SettingsGateway>(
  (ref) => RiverpodSettingsGateway(ref),
);
