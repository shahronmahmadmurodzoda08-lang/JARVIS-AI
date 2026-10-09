import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(AppStrings.voice),
          SegmentedButton<VoiceType>(
            segments: const [
              ButtonSegment(
                value: VoiceType.male,
                label: Text(AppStrings.voiceMale),
              ),
              ButtonSegment(
                value: VoiceType.female,
                label: Text(AppStrings.voiceFemale),
              ),
            ],
            selected: {settings.voice},
            onSelectionChanged: (s) => controller.changeVoice(s.first),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(AppStrings.language),
          DropdownButton<AppLanguage>(
            value: settings.language,
            isExpanded: true,
            items: [
              for (final lang in AppLanguage.values)
                DropdownMenuItem(value: lang, child: Text(lang.nativeName)),
            ],
            onChanged: (lang) {
              if (lang != null) controller.changeLanguage(lang);
            },
          ),
          const SizedBox(height: 24),
          const _SectionTitle(AppStrings.speechSpeed),
          Slider(
            value: settings.speechSpeed,
            min: 0.5,
            max: 1.5,
            divisions: 10,
            label: '${settings.speechSpeed.toStringAsFixed(1)}x',
            onChanged: controller.changeSpeechSpeed,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(AppStrings.theme),
          SegmentedButton<ThemeModeSetting>(
            segments: const [
              ButtonSegment(
                value: ThemeModeSetting.dark,
                label: Text(AppStrings.themeDark),
              ),
              ButtonSegment(
                value: ThemeModeSetting.light,
                label: Text(AppStrings.themeLight),
              ),
              ButtonSegment(
                value: ThemeModeSetting.system,
                label: Text(AppStrings.themeSystem),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (s) => controller.changeTheme(s.first),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(AppStrings.wakeWord),
            subtitle: const Text(AppStrings.wakeWordHint),
            value: settings.wakeWordEnabled,
            onChanged: (v) => controller.changeWakeWordSettings(enabled: v),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
