
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/chat_controller.dart';
import '../domain/chat_message.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _speechAvailable = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          setState(() => _isListening = status == 'listening');
        },
        onError: (error) {
          if (!mounted) return;
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Хатои микрофон: ${error.errorMsg}'),
            ),
          );
        },
      );

      if (mounted) {
        setState(() => _speechAvailable = available);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _speechAvailable = false);
      }
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _textController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendText(text);
    _textController.clear();
  }

  Future<void> _onMicPressed() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() => _isListening = false);
      }
      return;
    }

    if (!_speechAvailable) {
      await _initializeSpeech();
      if (!_speechAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Шинохти овоз дастрас нест. '
              'Иҷозати микрофон ва интернетро санҷ.',
            ),
          ),
        );
        return;
      }
    }

    final language = ref.read(settingsProvider).language;

    try {
      await _speech.listen(
        localeId: _localeFor(language),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
        onResult: (result) {
          if (!mounted) return;

          setState(() {
            _textController.text = result.recognizedWords;
            _isListening = !result.finalResult;
          });

          _textController.selection = TextSelection.collapsed(
            offset: _textController.text.length,
          );
        },
      );

      if (mounted) {
        setState(() => _isListening = true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Микрофонро оғоз карда натавонистам.'),
        ),
      );
    }
  }

  String _localeFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.tajik:
        return 'tg-TJ';
      case AppLanguage.russian:
        return 'ru-RU';
      case AppLanguage.english:
        return 'en-US';
      case AppLanguage.german:
        return 'de-DE';
      case AppLanguage.arabic:
        return 'ar-SA';
      case AppLanguage.spanish:
        return 'es-ES';
      case AppLanguage.portuguese:
        return 'pt-BR';
      case AppLanguage.korean:
        return 'ko-KR';
      case AppLanguage.chinese:
        return 'zh-CN';
      case AppLanguage.japanese:
        return 'ja-JP';
      case AppLanguage.italian:
        return 'it-IT';
      case AppLanguage.turkish:
        return 'tr-TR';
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: AppStrings.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Image(
                image: AssetImage('assets/icon/app_icon.png'),
                width: 156,
                height: 156,
                fit: BoxFit.contain,
                semanticLabel: 'JARVIS AI logo',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) =>
                    _MessageBubble(message: messages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton.filled(
                    tooltip: _isListening
                        ? 'Қатъ кардани микрофон'
                        : 'Микрофон',
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                    ),
                    onPressed: _onMicPressed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Гӯш карда истодаам...'
                            : AppStrings.typeMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Фиристодан',
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.author == MessageAuthor.user;

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.blue.withValues(alpha: 0.3)
              : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUser ? AppColors.blue : AppColors.metal,
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
