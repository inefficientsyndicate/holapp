import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:holapp/locator.dart';
import 'package:holapp/main.dart';
import 'package:holapp/manager/grocery_manager.dart';
import 'package:holapp/models/grocery_list.dart';

const _carrot = 'lucide:carrot';

void main() {
  tearDown(() => di.reset());

  group('GroceryList', () {
    final createdAt = DateTime(2026);

    test('round-trips its icon through JSON', () {
      final list = GroceryList(id: '1', name: 'a', items: const [], createdAt: createdAt, icon: _carrot);
      expect(GroceryList.fromJson(list.toJson()).icon, _carrot);
    });

    test('reads lists saved before icons existed', () {
      final list = GroceryList(id: '1', name: 'a', items: const [], createdAt: createdAt);
      expect(list.toJson().containsKey('icon'), isFalse);
      expect(GroceryList.fromJson(list.toJson()).icon, isNull);
    });

    test('copyWith keeps the icon unless told otherwise', () {
      final list = GroceryList(id: '1', name: 'a', items: const [], createdAt: createdAt, icon: _carrot);
      expect(list.copyWith(name: 'b').icon, _carrot);
      expect(list.copyWith(icon: () => null).icon, isNull);
    });
  });

  test('GroceryManager persists icon changes and keeps them across item edits', () async {
    SharedPreferences.setMockInitialValues({});
    final manager = await GroceryManager().init();

    final id = manager.createList('Weekly', icon: _carrot);
    manager.addItem(id, 'Milk');
    expect(manager.listById(id)!.icon, _carrot);

    manager.setListIcon(id, 'lucide:apple');
    final reloaded = await GroceryManager().init();
    expect(reloaded.listById(id)!.icon, 'lucide:apple');

    manager.setListIcon(id, null);
    expect(manager.listById(id)!.icon, isNull);
    final prefs = await SharedPreferences.getInstance();
    expect((jsonDecode(prefs.getString('groceries.lists')!) as List).single, isNot(contains('icon')));
  });

  Future<void> pumpApp(WidgetTester tester, Map<String, Object> prefs) async {
    SharedPreferences.setMockInitialValues(prefs);
    configureDependencies();
    await tester.pumpWidget(const GroceriesApp());
    for (var i = 0; i < 10 && find.text('hol.').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('picks an icon when creating a list and changes it later', (tester) async {
    await pumpApp(tester, {});

    await tester.tap(find.text('New list'));
    await tester.pumpAndSettle();
    // The quick-add field on the page behind the dialog comes first.
    await tester.enterText(find.byType(EditableText).last, 'Weekly');
    await tester.tap(find.byIcon(LucideIcons.carrot));
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.carrot), findsOneWidget);

    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Change icon'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(LucideIcons.carrot).last);
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.imagePlus), findsOneWidget);
    expect(find.byIcon(LucideIcons.carrot), findsNothing);
  });

  testWidgets('a list with an icon fits the default phone-width grid', (tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final list = GroceryList(
      id: '1',
      name: 'A rather long grocery list name that wraps',
      items: const [],
      createdAt: DateTime(2026),
      icon: _carrot,
    );
    await pumpApp(tester, {
      'groceries.lists': jsonEncode([list.toJson()]),
    });

    expect(find.byIcon(LucideIcons.carrot), findsOneWidget);
    expect(
      tester.getCenter(find.byIcon(LucideIcons.carrot)).dx,
      lessThan(tester.getCenter(find.text('0 items')).dx),
    );
    expect(tester.takeException(), isNull);
  });
}
