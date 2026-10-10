import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_settings.dart';

/// Танзимоти JARVIS. Ҳоло ҳолат дар хотираи барнома нигоҳ дошта мешавад.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void changeVoice(VoiceType voice) {
    state = state.copyWith(voice: voice);
  }

  void changeLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }

  void changeSpeechSpeed(double speed) {
    // clamp() намуди num медиҳад; toDouble() типи double-ро нигоҳ медорад.
    state = state.copyWith(speechSpeed: speed.clamp(0.5, 1.5).toDouble());
  }

  void changeTheme(ThemeModeSetting mode) {
    state = state.copyWith(themeMode: mode);
  }

  void changeWakeWordSettings({required bool enabled}) {
    state = state.copyWith(wakeWordEnabled: enabled);
  }
}

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
