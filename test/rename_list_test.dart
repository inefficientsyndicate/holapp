import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:holapp/locator.dart';
import 'package:holapp/main.dart';
import 'package:holapp/manager/grocery_manager.dart';
import 'package:holapp/models/grocery_item.dart';
import 'package:holapp/models/grocery_list.dart';

const _carrot = 'lucide:carrot';

void main() {
  tearDown(() => di.reset());

  test('GroceryManager persists a renamed list and keeps its contents', () async {
    SharedPreferences.setMockInitialValues({});
    final manager = await GroceryManager().init();

    final id = manager.createList('Weekly', icon: _carrot);
    manager.addItem(id, 'Milk');

    manager.renameList(id, '  Monthly ');
    manager.renameList(id, '   ');

    final reloaded = (await GroceryManager().init()).listById(id)!;
    expect(reloaded.name, 'Monthly');
    expect(reloaded.icon, _carrot);
    expect(reloaded.items.single.name, 'Milk');
  });

  Future<void> pumpApp(WidgetTester tester) async {
    final list = GroceryList(
      id: '1',
      name: 'Weekly',
      items: [GroceryItem(id: 'a', name: 'Milk', addedAt: DateTime(2026))],
      createdAt: DateTime(2026),
    );
    SharedPreferences.setMockInitialValues({
      'groceries.lists': jsonEncode([list.toJson()]),
    });
    configureDependencies();
    await tester.pumpWidget(const GroceriesApp());
    for (var i = 0; i < 10 && find.text('hol.').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  // The quick-add field on the page behind the dialog comes first.
  Finder dialogField() => find.byType(EditableText).last;

  testWidgets('long-pressing a tile renames the list', (tester) async {
    await pumpApp(tester);

    await tester.longPress(find.text('Weekly'));
    await tester.pumpAndSettle();

    final field = tester.widget<EditableText>(dialogField());
    expect(field.controller.text, 'Weekly');
    expect(field.controller.selection, const TextSelection(baseOffset: 0, extentOffset: 6));

    await tester.enterText(dialogField(), 'Monthly');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Weekly'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
  });

  testWidgets('cancelling keeps the old name', (tester) async {
    await pumpApp(tester);

    await tester.longPress(find.text('Weekly'));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField(), 'Monthly');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Monthly'), findsNothing);
  });

  testWidgets('saving an empty name keeps the old one', (tester) async {
    await pumpApp(tester);

    await tester.longPress(find.text('Weekly'));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField(), '   ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Weekly'), findsOneWidget);
    expect(di<GroceryManager>().listById('1')!.name, 'Weekly');
  });
}
