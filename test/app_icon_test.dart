import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:holapp/locator.dart';
import 'package:holapp/main.dart';
import 'package:holapp/manager/grocery_manager.dart';
import 'package:holapp/theme/app_icon_variant.dart';

const _channel = MethodChannel('holapp/app_icon');

Future<void> _openSettings(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  configureDependencies();
  await tester.pumpWidget(const GroceriesApp());
  for (var i = 0; i < 10 && find.text('hol.').evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.tap(find.byTooltip('Settings'));
  await tester.pumpAndSettle();
}

void _mockChannel(Future<Object?> Function(MethodCall call) handler) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, handler);
}

void main() {
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
    return di.reset();
  });

  testWidgets('hides the setting when the platform has no icon channel',
      (WidgetTester tester) async {
    await _openSettings(tester);

    expect(find.text('Color theme'), findsOneWidget);
    expect(find.text('App icon'), findsNothing);
  });

  testWidgets('hides the setting when the platform reports no support',
      (WidgetTester tester) async {
    _mockChannel((call) async => null);
    await _openSettings(tester);

    expect(find.text('App icon'), findsNothing);
  });

  testWidgets('starts on the icon the OS reports and changes it',
      (WidgetTester tester) async {
    final calls = <MethodCall>[];
    _mockChannel((call) async {
      calls.add(call);
      return call.method == 'getIcon' ? 'light' : null;
    });
    await _openSettings(tester);

    expect(find.text('App icon'), findsOneWidget);
    expect(di<GroceryManager>().appIcon.value, AppIconVariant.light);

    // .last: the color theme selector has a "Green" swatch as well.
    await tester.ensureVisible(find.byTooltip('Green').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Green').last);
    await tester.pumpAndSettle();

    expect(calls.last.method, 'setIcon');
    expect(calls.last.arguments, 'green');
    expect(di<GroceryManager>().appIcon.value, AppIconVariant.green);
  });

  testWidgets('keeps the selection and tells the user when the OS refuses',
      (WidgetTester tester) async {
    _mockChannel((call) async {
      if (call.method == 'getIcon') return 'midnight';
      throw PlatformException(code: 'set_failed');
    });
    await _openSettings(tester);

    await tester.ensureVisible(find.byTooltip('Midnight'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Light'));
    await tester.pump();

    expect(di<GroceryManager>().appIcon.value, AppIconVariant.midnight);
    expect(find.text("Couldn't change the app icon."), findsOneWidget);
  });
}
