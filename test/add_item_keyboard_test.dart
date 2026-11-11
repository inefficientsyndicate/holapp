import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:holapp/locator.dart';
import 'package:holapp/main.dart';
import 'package:holapp/manager/grocery_manager.dart';
import 'package:holapp/models/grocery_list.dart';
import 'package:holapp/models/history_entry.dart';

void main() {
  tearDown(() => di.reset());

  Future<void> openList(WidgetTester tester) async {
    final list = GroceryList(id: '1', name: 'Weekly', items: const [], createdAt: DateTime(2026));
    final entry = HistoryEntry(
      id: 'h',
      listId: '1',
      itemName: 'Butter',
      listName: 'Weekly',
      removedAt: DateTime(2026),
    );
    SharedPreferences.setMockInitialValues({
      'groceries.lists': jsonEncode([list.toJson()]),
      'groceries.history': jsonEncode([entry.toJson()]),
    });
    configureDependencies();
    await tester.pumpWidget(const GroceriesApp());
    for (var i = 0; i < 10 && find.text('hol.').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
  }

  bool fieldHasFocus(WidgetTester tester) =>
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus;

  List<String> itemNames() =>
      di<GroceryManager>().listById('1')!.items.map((item) => item.name).toList();

  testWidgets('adding items keeps the keyboard open and the field empty', (tester) async {
    await openList(tester);

    for (final name in ['Milk', 'Eggs']) {
      await tester.enterText(find.byType(EditableText), name);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(fieldHasFocus(tester), isTrue);
      expect(tester.testTextInput.isVisible, isTrue);
      expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, isEmpty);
    }

    expect(itemNames(), ['Milk', 'Eggs']);
  });

  testWidgets('a refused duplicate keeps the keyboard open too', (tester) async {
    await openList(tester);

    for (var i = 0; i < 2; i++) {
      await tester.enterText(find.byType(EditableText), 'Milk');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
    }

    expect(fieldHasFocus(tester), isTrue);
    expect(itemNames(), ['Milk']);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('adding from a suggestion keeps the keyboard open', (tester) async {
    await openList(tester);

    await tester.enterText(find.byType(EditableText), 'But');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Butter'));
    await tester.pumpAndSettle();

    expect(itemNames(), ['Butter']);
    expect(fieldHasFocus(tester), isTrue);
  });

  testWidgets('submitting an empty field closes the keyboard', (tester) async {
    await openList(tester);

    await tester.enterText(find.byType(EditableText), '  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(fieldHasFocus(tester), isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(itemNames(), isEmpty);
  });

  testWidgets('tapping outside the field closes the keyboard', (tester) async {
    await openList(tester);

    await tester.showKeyboard(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(fieldHasFocus(tester), isTrue);

    await tester.tapAt(const Offset(200, 200));
    await tester.pumpAndSettle();

    expect(fieldHasFocus(tester), isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('tapping outside the quick-add field closes the keyboard', (tester) async {
    await openList(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.showKeyboard(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(fieldHasFocus(tester), isTrue);

    await tester.tap(find.text('hol.'));
    await tester.pumpAndSettle();

    expect(fieldHasFocus(tester), isFalse);
  });
}
