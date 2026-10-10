# Ислоҳи JARVIS AI — дастур ба забони тоҷикӣ

Ин баста барои репозитории `shahronmahmadmurodzoda08-lang/JARVIS-AI` омода шудааст.

## Чӣ ислоҳ мешавад

1. Ду файли logo/icon илова мешаванд; дар репозиторӣ ин файлҳо набуданд, дар ҳоле ки `pubspec.yaml` ва `setup-platforms.yml` ба онҳо ишора мекарданд.
2. `pubspec.yaml` logo-ро ҳамчун asset сабт мекунад ва танзимоти `flutter_launcher_icons`-ро барои Android, iOS, Web, Windows ва macOS нигоҳ медорад.
3. Дар `local_intent_parser.dart` фармонҳои тағйирдиҳандаи танзим танҳо вақте амал мекунанд, ки корбар фармонро бо `JARVIS` оғоз кунад.
4. Дар Home Screen logo нишон дода мешавад.
5. `settings_controller.dart` натиҷаи `clamp()`-ро ба `double` табдил медиҳад.
6. Workflow-и `setup-platforms.yml` ҳамаи папкаҳои платформа ва нишонаҳои мувофиқро месозад ва ба GitHub commit мекунад.

## Файлҳоро дар ҳамин роҳҳо гузоред

- `assets/icon/app_icon.png`
- `assets/icon/app_icon_foreground.png`
- `pubspec.yaml`
- `lib/ai/intent/local_intent_parser.dart`
- `lib/features/chat/presentation/home_screen.dart`
- `lib/features/settings/application/settings_controller.dart`
- `.github/workflows/setup-platforms.yml`

Ҳар файлро дар ҳамон роҳи дар боло навишташуда ҷойгир кунед. Файлҳои мавҷудаи Dart/YAML бояд пурра иваз шаванд; ду файли PNG нав мебошанд.

## Пас аз commit кардан

1. Дар GitHub ба бахши **Actions** дароед.
2. Workflow-и **Setup all platforms and app icons**-ро интихоб кунед.
3. **Run workflow**-ро пахш кунед ва branch-и `main`-ро интихоб кунед.
4. Workflow папкаҳои `android/`, `ios/`, `windows/`, `macos/`, `linux/`, `web/`-ро месозад, нишонаҳоро насб мекунад ва тағйиротро commit мекунад.
5. Баъд workflow-и **Build JARVIS AI** худкор оғоз мешавад. Натиҷаро дар Actions бинед.

## Маҳдудият

Ин баста Flutter/Dart-ро дар ин муҳит build карда наметавонист, зеро Flutter SDK насб нашудааст. Аммо CI-и охирини худи репозиторӣ дар GitHub барои analyze/test ва build-и платформаҳо муваффақ буд. Пас аз гузоштани файлҳо, GitHub Actions санҷиши ниҳоиро иҷро мекунад.
