import 'package:jarvis_ai/ai/models/ai_models.dart';
import 'package:jarvis_ai/features/settings/domain/app_settings.dart';

/// Parser-и фармонҳои маҳаллӣ, ки бе интернет кор мекунад.
/// Барои тағйир додани танзимот корбар бояд фармонро бо номи JARVIS оғоз кунад.
class LocalIntentParser {
  const LocalIntentParser();

  static final RegExp _wakePrefix =
      RegExp(r'^\s*jarvis\b[\s,:!.]*', caseSensitive: false);

  /// Фақат фармонҳои равшанро ба ToolCall табдил медиҳад.
  static final RegExp _verb = RegExp(
    r'(кун|гузор|иваз|set|change|switch|make|поставь|измени|сделай|переключи)',
    caseSensitive: false,
  );

  static const Map<AppLanguage, List<String>> _languageWords = {
    AppLanguage.tajik: ['тоҷикӣ', 'тоҷики', 'таджик', 'tajik'],
    AppLanguage.russian: ['русӣ', 'руси', 'русск', 'russian'],
    AppLanguage.english: ['english', 'англис', 'инглис', 'английск'],
    AppLanguage.german: ['deutsch', 'german', 'немецк', 'олмон'],
    AppLanguage.arabic: ['العربية', 'arabic', 'арабск', 'арабӣ'],
    AppLanguage.spanish: ['español', 'spanish', 'испанск', 'испанӣ'],
    AppLanguage.portuguese: ['português', 'portuguese', 'португальск', 'португал'],
    AppLanguage.korean: ['한국어', 'korean', 'корейск', 'кореягӣ'],
    AppLanguage.chinese: ['中文', 'chinese', 'китайск', 'хитоӣ'],
    AppLanguage.japanese: ['日本語', 'japanese', 'японск', 'ёпунӣ'],
    AppLanguage.italian: ['italiano', 'italian', 'итальянск', 'итальянӣ'],
    AppLanguage.turkish: ['türkçe', 'turkish', 'турецк', 'туркӣ'],
  };

  ToolCall? parse(String input) {
    // Бе wake word, матн сӯҳбат ҳисоб мешавад, на фармон.
    if (!_wakePrefix.hasMatch(input)) return null;

    final text = input.toLowerCase().replaceFirst(_wakePrefix, '').trim();
    if (text.isEmpty || !_verb.hasMatch(text)) return null;

    return _theme(text) ?? _language(text) ?? _speed(text) ?? _voice(text);
  }

  bool _hasAny(String text, List<String> words) =>
      words.any((word) => text.contains(word));

  ToolCall? _theme(String text) {
    if (!_hasAny(text, ['theme', 'мавзӯъ', 'мавзуъ', 'тему'])) return null;
    if (_hasAny(text, ['dark', 'торик', 'тёмн', 'темн'])) {
      return const ToolCall('changeTheme', {'mode': 'dark'});
    }
    if (_hasAny(text, ['light', 'равшан', 'светл'])) {
      return const ToolCall('changeTheme', {'mode': 'light'});
    }
    if (_hasAny(text, ['system', 'система'])) {
      return const ToolCall('changeTheme', {'mode': 'system'});
    }
    return null;
  }

  ToolCall? _language(String text) {
    if (!_hasAny(text, ['забон', 'language', 'язык'])) return null;
    for (final entry in _languageWords.entries) {
      if (_hasAny(text, entry.value)) {
        return ToolCall('changeLanguage', {'language': entry.key.name});
      }
    }
    return null;
  }

  ToolCall? _speed(String text) {
    if (!_hasAny(text, ['суръат', 'speed', 'скорост'])) return null;
    if (_hasAny(text, ['кам', 'slower', 'медленн', 'decrease', 'reduce'])) {
      return const ToolCall('changeSpeechSpeed', {'delta': -0.1});
    }
    if (_hasAny(text, ['зиёд', 'тез', 'faster', 'быстр', 'increase'])) {
      return const ToolCall('changeSpeechSpeed', {'delta': 0.1});
    }
    return null;
  }

  ToolCall? _voice(String text) {
    if (!_hasAny(text, ['овоз', 'voice', 'голос'])) return null;
    if (_hasAny(text, ['занона', 'female', 'женск'])) {
      return const ToolCall('changeVoice', {'voice': 'female'});
    }
    if (_hasAny(text, ['мардона', 'male', 'мужск'])) {
      return const ToolCall('changeVoice', {'voice': 'male'});
    }
    return null;
  }
}
