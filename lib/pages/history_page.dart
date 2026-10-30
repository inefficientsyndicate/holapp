import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../models/history_entry.dart';
import '../widgets/app_toast.dart';

/// Keeps only the most recent entry per item name (entries are already
/// ordered newest first).
List<HistoryEntry> _dedupeByName(Iterable<HistoryEntry> entries) {
  final seen = <String>{};
  final result = <HistoryEntry>[];
  for (final entry in entries) {
    if (seen.add(entry.itemName.toLowerCase())) {
      result.add(entry);
    }
  }
  return result;
}

/// Shows the items that have been collected (tapped) from a single list.
/// Tapping an entry adds that item back to the list.
class HistoryPage extends WatchingWidget {
  const HistoryPage({required this.listId, required this.listName, super.key});

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context) {
    final allHistory = watchValue((GroceryManager m) => m.history);
    final history = _dedupeByName(
      allHistory.where((entry) => entry.listId == listId),
    );
    final lists = watchValue((GroceryManager m) => m.lists);
    final theme = ShadTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('MMM d, HH:mm', l10n.localeName);

    var currentItemNames = const <String>{};
    for (final list in lists) {
      if (list.id == listId) {
        currentItemNames = list.items.map((item) => item.name.toLowerCase()).toSet();
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(l10n.historyPageTitle(listName))),
      body: history.isEmpty
          ? Center(
              child: Text(l10n.nothingCollectedYet, style: theme.textTheme.muted),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: ShadSeparator.horizontal(),
              ),
              itemBuilder: (context, index) {
                final entry = history[index];
                final alreadyOnList = currentItemNames.contains(entry.itemName.toLowerCase());
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(LucideIcons.check, color: theme.colorScheme.foreground),
                  title: Text(entry.itemName),
                  subtitle: Text(dateFormat.format(entry.removedAt)),
                  trailing: alreadyOnList
                      ? Icon(LucideIcons.listChecks, color: theme.colorScheme.mutedForeground)
                      : Icon(LucideIcons.plus, color: theme.colorScheme.foreground),
                  enabled: !alreadyOnList,
                  onTap: alreadyOnList
                      ? null
                      : () {
                          di<GroceryManager>().addItemFromHistory(listId, entry.itemName);
                          showAppToast(
                            context,
                            l10n.addedToListSnackbar(entry.itemName, listName),
                            aboveInputBar: false,
                          );
                        },
                );
              },
            ),
    );
  }
}
