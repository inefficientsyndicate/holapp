import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/grocery_item.dart';
import '../models/grocery_list.dart';
import '../models/history_entry.dart';
import '../theme/app_color_theme.dart';
import '../theme/app_icon_variant.dart';

/// Holds all grocery lists, the removal history and the grid-size
/// preferences, and persists them to [SharedPreferences].
class GroceryManager {
  static const _listsKey = 'groceries.lists';
  static const _historyKey = 'groceries.history';
  static const _listsColumnsKey = 'groceries.listsColumns';
  static const _itemsColumnsKey = 'groceries.itemsColumns';
  static const _themeModeKey = 'groceries.themeMode';
  static const _localeKey = 'groceries.locale';
  static const _colorThemeKey = 'groceries.colorTheme';
  static const _appIconChannel = MethodChannel('holapp/app_icon');

  late SharedPreferences _prefs;
  int _idCounter = 0;

  final _lists = ValueNotifier<List<GroceryList>>(const []);
  ValueListenable<List<GroceryList>> get lists => _lists;

  final _history = ValueNotifier<List<HistoryEntry>>(const []);
  ValueListenable<List<HistoryEntry>> get history => _history;

  final _listsColumns = ValueNotifier<int>(2);
  ValueListenable<int> get listsColumns => _listsColumns;

  final _itemsColumns = ValueNotifier<int>(2);
  ValueListenable<int> get itemsColumns => _itemsColumns;

  final _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  ValueListenable<ThemeMode> get themeMode => _themeMode;

  /// `null` means follow the system language.
  final _locale = ValueNotifier<Locale?>(null);
  ValueListenable<Locale?> get locale => _locale;

  final _colorTheme = ValueNotifier<AppColorTheme>(AppColorTheme.green);
  ValueListenable<AppColorTheme> get colorTheme => _colorTheme;

  /// `null` means this platform can't change its icon. The OS remembers the
  /// choice, so unlike the other settings it isn't kept in [SharedPreferences].
  final _appIcon = ValueNotifier<AppIconVariant?>(null);
  ValueListenable<AppIconVariant?> get appIcon => _appIcon;

  Future<GroceryManager> init() async {
    _prefs = await SharedPreferences.getInstance();

    final listsJson = _prefs.getString(_listsKey);
    if (listsJson != null) {
      final decoded = jsonDecode(listsJson) as List;
      _lists.value = decoded
          .map((e) => GroceryList.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final historyJson = _prefs.getString(_historyKey);
    if (historyJson != null) {
      final decoded = jsonDecode(historyJson) as List;
      _history.value = decoded
          .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Lists overview only offers 2-3 columns; clamp any older saved value.
    _listsColumns.value = (_prefs.getInt(_listsColumnsKey) ?? 2).clamp(2, 3);
    _itemsColumns.value = _prefs.getInt(_itemsColumnsKey) ?? 2;
    final themeModeIndex = _prefs.getInt(_themeModeKey);
    if (themeModeIndex != null && themeModeIndex < ThemeMode.values.length) {
      _themeMode.value = ThemeMode.values[themeModeIndex];
    }
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode != null && languageCode.isNotEmpty) {
      _locale.value = Locale(languageCode);
    }
    final colorThemeName = _prefs.getString(_colorThemeKey);
    if (colorThemeName != null) {
      _colorTheme.value = AppColorTheme.values.firstWhere(
        (value) => value.name == colorThemeName,
        orElse: () => AppColorTheme.green,
      );
    }
    // Not awaited: the splash screen shouldn't wait on a setting only Settings
    // shows, which stays hidden until this completes.
    unawaited(_loadAppIcon());
    return this;
  }

  Future<void> _loadAppIcon() async {
    try {
      final name = await _appIconChannel.invokeMethod<String>('getIcon');
      _appIcon.value = AppIconVariant.values.asNameMap()[name];
    } on MissingPluginException {
      // This platform has no native side, so the setting stays hidden.
    } on PlatformException {
      // Likewise: without a known current icon there's nothing to show.
    }
  }

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  GroceryList? listById(String id) {
    for (final list in _lists.value) {
      if (list.id == id) return list;
    }
    return null;
  }

  /// Whether [listId] already has an item named [name] (case-insensitive).
  bool hasItem(String listId, String name) {
    final key = name.trim().toLowerCase();
    final list = listById(listId);
    if (list == null) return false;
    return list.items.any((item) => item.name.toLowerCase() == key);
  }

  /// Creates a new named list and returns its id.
  String createList(String name, {String? icon}) {
    final trimmed = name.trim();
    final list = GroceryList(
      id: _newId(),
      name: trimmed,
      items: const [],
      createdAt: DateTime.now(),
      icon: icon,
    );
    _lists.value = [..._lists.value, list];
    _persistLists();
    return list.id;
  }

  /// Sets [listId]'s icon. Pass `null` to remove it.
  void setListIcon(String listId, String? icon) {
    _lists.value = [
      for (final list in _lists.value)
        if (list.id == listId) list.copyWith(icon: () => icon) else list,
    ];
    _persistLists();
  }

  /// Deletes [listId] and its history.
  void deleteList(String listId) {
    _lists.value = _lists.value.where((list) => list.id != listId).toList();
    _persistLists();

    final remainingHistory =
        _history.value.where((entry) => entry.listId != listId).toList();
    if (remainingHistory.length != _history.value.length) {
      _history.value = remainingHistory;
      _persistHistory();
    }
  }

  void addItem(String listId, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final item = GroceryItem(id: _newId(), name: trimmed, addedAt: DateTime.now());
    _lists.value = [
      for (final list in _lists.value)
        if (list.id == listId)
          list.copyWith(items: [...list.items, item])
        else
          list,
    ];
    _persistLists();
  }

  /// Adds [name] back to [listId] and clears it out of that list's history,
  /// since it's active on the list again rather than collected.
  void addItemFromHistory(String listId, String name) {
    addItem(listId, name);
    final key = name.trim().toLowerCase();
    final before = _history.value.length;
    _history.value = _history.value
        .where((entry) => entry.listId != listId || entry.itemName.toLowerCase() != key)
        .toList();
    if (_history.value.length != before) {
      _persistHistory();
    }
  }

  void removeItem(String listId, String itemId) {
    GroceryItem? removed;
    var listName = '';
    final updatedLists = <GroceryList>[];
    for (final list in _lists.value) {
      if (list.id != listId) {
        updatedLists.add(list);
        continue;
      }
      listName = list.name;
      final remaining = <GroceryItem>[];
      for (final item in list.items) {
        if (item.id == itemId && removed == null) {
          removed = item;
        } else {
          remaining.add(item);
        }
      }
      updatedLists.add(list.copyWith(items: remaining));
    }
    _lists.value = updatedLists;
    _persistLists();

    if (removed != null) {
      final entry = HistoryEntry(
        id: _newId(),
        listId: listId,
        itemName: removed.name,
        listName: listName,
        removedAt: DateTime.now(),
      );
      _history.value = [entry, ..._history.value];
      _persistHistory();
    }
  }

  /// Unique item names from [listId]'s history matching [query], most
  /// recent first.
  List<String> historySuggestions(String listId, String query, {int limit = 8}) {
    final q = query.trim().toLowerCase();
    final seen = <String>{};
    final result = <String>[];
    for (final entry in _history.value) {
      if (entry.listId != listId) continue;
      final key = entry.itemName.toLowerCase();
      if (seen.contains(key)) continue;
      if (q.isNotEmpty && !key.contains(q)) continue;
      seen.add(key);
      result.add(entry.itemName);
      if (result.length >= limit) break;
    }
    return result;
  }

  void setListsColumns(int columns) {
    _listsColumns.value = columns;
    _prefs.setInt(_listsColumnsKey, columns);
  }

  void setItemsColumns(int columns) {
    _itemsColumns.value = columns;
    _prefs.setInt(_itemsColumnsKey, columns);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _prefs.setInt(_themeModeKey, mode.index);
  }

  /// Pass `null` to follow the system language.
  void setLocale(Locale? locale) {
    _locale.value = locale;
    _prefs.setString(_localeKey, locale?.languageCode ?? '');
  }

  void setColorTheme(AppColorTheme theme) {
    _colorTheme.value = theme;
    _prefs.setString(_colorThemeKey, theme.name);
  }

  /// Returns whether the OS accepted the change; the selection only moves if
  /// it did.
  Future<bool> setAppIcon(AppIconVariant icon) async {
    if (icon == _appIcon.value) return true;
    try {
      await _appIconChannel.invokeMethod<void>('setIcon', icon.name);
    } on PlatformException {
      return false;
    }
    _appIcon.value = icon;
    return true;
  }

  void _persistLists() {
    _prefs.setString(
      _listsKey,
      jsonEncode(_lists.value.map((e) => e.toJson()).toList()),
    );
  }

  void _persistHistory() {
    _prefs.setString(
      _historyKey,
      jsonEncode(_history.value.map((e) => e.toJson()).toList()),
    );
  }
}
