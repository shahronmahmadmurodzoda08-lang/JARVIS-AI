
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

/// Танзимоти JARVIS-ро идора ва дар телефон нигоҳ медорад.
class SettingsController extends Notifier<AppSettings> {
  bool _changedBeforeRestore = false;

  @override
  AppSettings build() {
    unawaited(_restoreSettings());
    return const AppSettings();
  }

  T _readEnum<T extends Enum>(
    List<T> values,
    String? savedValue,
    T fallback,
  ) {
    for (final value in values) {
      if (value.name == savedValue) return value;
    }
    return fallback;
  }

  Future<void> _restoreSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Агар корбар аллакай танзимотро иваз карда бошад,
      // маълумоти кӯҳна набояд онро баргардонад.
      if (_changedBeforeRestore) return;

      state = AppSettings(
        voice: _readEnum(
          VoiceType.values,
          prefs.getString('jarvis_voice'),
          VoiceType.male,
        ),
        language: _readEnum(
          AppLanguage.values,
          prefs.getString('jarvis_language'),
          AppLanguage.tajik,
        ),
        themeMode: _readEnum(
          ThemeModeSetting.values,
          prefs.getString('jarvis_theme'),
          ThemeModeSetting.dark,
        ),
        speechSpeed: (prefs.getDouble('jarvis_speed') ?? 1.0)
            .clamp(0.5, 1.5)
            .toDouble(),
        wakeWordEnabled:
            prefs.getBool('jarvis_wake_word') ?? false,
      );
    } catch (_) {
      // Агар нигоҳдорӣ дастнорас бошад, барнома бо
      // танзимоти пешфарз кор карданро идома медиҳад.
    }
  }

  void changeVoice(VoiceType voice) {
    _changedBeforeRestore = true;
    state = state.copyWith(voice: voice);
    unawaited(_saveSettings());
  }

  void changeLanguage(AppLanguage language) {
    _changedBeforeRestore = true;
    state = state.copyWith(language: language);
    unawaited(_saveSettings());
  }

  void changeSpeechSpeed(double speed) {
    _changedBeforeRestore = true;
    state = state.copyWith(
      speechSpeed: speed.clamp(0.5, 1.5).toDouble(),
    );
    unawaited(_saveSettings());
  }

  void changeTheme(ThemeModeSetting mode) {
    _changedBeforeRestore = true;
    state = state.copyWith(themeMode: mode);
    unawaited(_saveSettings());
  }

  void changeWakeWordSettings({required bool enabled}) {
    _changedBeforeRestore = true;
    state = state.copyWith(wakeWordEnabled: enabled);
    unawaited(_saveSettings());
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = state;

      await prefs.setString(
        'jarvis_voice',
        current.voice.name,
      );
      await prefs.setString(
        'jarvis_language',
        current.language.name,
      );
      await prefs.setString(
        'jarvis_theme',
        current.themeMode.name,
      );
      await prefs.setDouble(
        'jarvis_speed',
        current.speechSpeed,
      );
      await prefs.setBool(
        'jarvis_wake_word',
        current.wakeWordEnabled,
      );
    } catch (_) {
      // Нокомии нигоҳдорӣ набояд барномаро қатъ кунад.
    }
  }
}

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
