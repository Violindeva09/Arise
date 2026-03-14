import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_arise/main.dart';
import 'package:flutter_arise/providers/system_provider.dart';

void main() {
  testWidgets('Arise System initial load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: AriseApp uses SystemProvider, so we need to ensure it's provided if the test builds AriseApp directly.
    // Since main() in main.dart already provides it, building AriseApp should work if it mimics the main structure.

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SystemProvider(),
        child: AriseApp(),
      ),
    );

    // Verify that our Login Screen appears (Hunter Identification text).
    expect(find.text('HUNTER IDENTIFICATION'), findsOneWidget);
    expect(find.text('AUTHENTICATE'), findsOneWidget);

    // Verify the counter logic (which no longer exists) is gone.
    expect(find.text('0'), findsNothing);
  });
}
