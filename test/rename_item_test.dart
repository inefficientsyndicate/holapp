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

void main() {
  tearDown(() => di.reset());

  test('GroceryManager persists a renamed item and keeps its identity', () async {
    SharedPreferences.setMockInitialValues({});
    final manager = await GroceryManager().init();

    final listId = manager.createList('Weekly');
    manager.addItem(listId, 'Milk');
    manager.addItem(listId, 'Eggs');
    final milk = manager.listById(listId)!.items.first;

    manager.renameItem(listId, milk.id, '  Oat milk ');

    final reloaded = await GroceryManager().init();
    final items = reloaded.listById(listId)!.items;
    expect(items.map((item) => item.name), ['Oat milk', 'Eggs']);
    expect(items.first.id, milk.id);
    expect(items.first.addedAt, milk.addedAt);
  });

  test('hasItem can leave out the item being renamed', () async {
    SharedPreferences.setMockInitialValues({});
    final manager = await GroceryManager().init();

    final listId = manager.createList('Weekly');
    manager.addItem(listId, 'Milk');
    final milk = manager.listById(listId)!.items.single;

    expect(manager.hasItem(listId, 'MILK'), isTrue);
    expect(manager.hasItem(listId, 'MILK', exceptItemId: milk.id), isFalse);
  });

  Future<void> openList(WidgetTester tester) async {
    final list = GroceryList(
      id: '1',
      name: 'Weekly',
      items: [
        GroceryItem(id: 'a', name: 'Milk', addedAt: DateTime(2026)),
        GroceryItem(id: 'b', name: 'Eggs', addedAt: DateTime(2026)),
      ],
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
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
  }

  Finder dialogField() => find.byType(EditableText).last;

  testWidgets('long-pressing a tile renames the item', (tester) async {
    await openList(tester);

    await tester.longPress(find.text('Milk'));
    await tester.pumpAndSettle();

    final field = tester.widget<EditableText>(dialogField());
    expect(field.controller.text, 'Milk');
    expect(field.controller.selection, const TextSelection(baseOffset: 0, extentOffset: 4));

    await tester.enterText(dialogField(), 'Oat milk');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Oat milk'), findsOneWidget);
    expect(find.text('Milk'), findsNothing);
    expect(find.text('Eggs'), findsOneWidget);
    expect(di<GroceryManager>().history.value, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelling keeps the old name', (tester) async {
    await openList(tester);

    await tester.longPress(find.text('Milk'));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField(), 'Oat milk');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Oat milk'), findsNothing);
  });

  testWidgets('refuses a name another item already has', (tester) async {
    await openList(tester);

    await tester.longPress(find.text('Milk'));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField(), 'eggs');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('"eggs" is already on Weekly'), findsOneWidget);
    expect(di<GroceryManager>().listById('1')!.items.first.name, 'Milk');
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('allows changing only the case of a name', (tester) async {
    await openList(tester);

    await tester.longPress(find.text('Milk'));
    await tester.pumpAndSettle();
    await tester.enterText(dialogField(), 'MILK');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('MILK'), findsOneWidget);
  });
}
