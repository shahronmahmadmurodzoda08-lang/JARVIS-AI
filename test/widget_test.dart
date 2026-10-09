import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/app.dart';

void main() {
  testWidgets('Home screen shows title and can open settings', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JarvisApp()));
    await tester.pump();

    expect(find.text('JARVIS AI'), findsOneWidget);

    await tester.tap(find.byTooltip('Танзимот'));
    await tester.pumpAndSettle();

    expect(find.text('Танзимот'), findsOneWidget);
  });
}
