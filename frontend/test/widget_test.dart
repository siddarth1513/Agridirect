import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_app/main.dart';

void main() {
  testWidgets('AgriDirect app renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
