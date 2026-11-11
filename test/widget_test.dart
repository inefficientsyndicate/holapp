import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:holapp/locator.dart';
import 'package:holapp/main.dart';

void main() {
  // Deliberately not in setUp(): that callback runs outside the async test
  // zone testWidgets() uses for its body, so a Future started there never
  // gets ticked forward by tester.pump() and the test hangs waiting on it.
  tearDown(() => di.reset());

  testWidgets('shows the lists overview once ready', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    configureDependencies();

    await tester.pumpWidget(const GroceriesApp());
    // The splash screen shows an indeterminate spinner, so pumpAndSettle
    // would never settle; pump a few frames for the async init to finish.
    for (var i = 0; i < 10 && find.text('hol.').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('hol.'), findsOneWidget);
    expect(find.text('New list'), findsOneWidget);
  });
}
