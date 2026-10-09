import 'package:flutter/foundation.dart';

/// Намуди овоз.
enum VoiceType { male, female }

/// 12 забони дастгирӣшаванда (мувофиқи ТЗ).
enum AppLanguage {
  tajik('tg', 'Тоҷикӣ'),
  russian('ru', 'Русский'),
  english('en', 'English'),
  german('de', 'Deutsch'),
  arabic('ar', 'العربية'),
  spanish('es', 'Español'),
  portuguese('pt', 'Português (Brasil)'),
  korean('ko', '한국어'),
  chinese('zh', '中文'),
  japanese('ja', '日本語'),
  italian('it', 'Italiano'),
  turkish('tr', 'Türkçe');

  const AppLanguage(this.code, this.nativeName);

  final String code;
  final String nativeName;
}

/// Танзимоти JARVIS (immutable).
@immutable
class AppSettings {
  const AppSettings({
    this.voice = VoiceType.male,
    this.language = AppLanguage.tajik,
    this.speechSpeed = 1.0,
    this.themeMode = ThemeModeSetting.dark,
    this.wakeWordEnabled = false,
  });

  final VoiceType voice;
  final AppLanguage language;

  /// 0.5 .. 1.5, 1.0 = муқаррарӣ.
  final double speechSpeed;
  final ThemeModeSetting themeMode;
  final bool wakeWordEnabled;

  AppSettings copyWith({
    VoiceType? voice,
    AppLanguage? language,
    double? speechSpeed,
    ThemeModeSetting? themeMode,
    bool? wakeWordEnabled,
  }) {
    return AppSettings(
      voice: voice ?? this.voice,
      language: language ?? this.language,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      themeMode: themeMode ?? this.themeMode,
      wakeWordEnabled: wakeWordEnabled ?? this.wakeWordEnabled,
    );
  }
}

/// Мустақил аз Flutter UI: dark / light / system.
enum ThemeModeSetting { dark, light, system }
