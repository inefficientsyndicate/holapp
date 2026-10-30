import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../models/grocery_list.dart';
import '../widgets/app_toast.dart';
import '../widgets/delete_list_dialog.dart';
import '../widgets/grocery_item_tile.dart';
import 'history_page.dart';

class ListDetailPage extends WatchingWidget {
  const ListDetailPage({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context) {
    final addController = createOnce(() => TextEditingController());
    final query = createOnce(() => ValueNotifier<String>(''));
    final lists = watchValue((GroceryManager m) => m.lists);
    final columns = watchValue((GroceryManager m) => m.itemsColumns);
    final queryText = watch(query).value;
    final theme = ShadTheme.of(context);
    final l10n = AppLocalizations.of(context);

    GroceryList? list;
    for (final candidate in lists) {
      if (candidate.id == listId) {
        list = candidate;
        break;
      }
    }

    if (list == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.listPageTitleFallback)),
        body: Center(child: Text(l10n.listNotFound, style: theme.textTheme.muted)),
      );
    }

    final existingNames = list.items.map((item) => item.name.toLowerCase()).toSet();
    final suggestions = di<GroceryManager>()
        .historySuggestions(listId, queryText)
        .where((name) => !existingNames.contains(name.toLowerCase()))
        .toList();

    void addItem(String name) {
      final manager = di<GroceryManager>();
      if (manager.hasItem(listId, name)) {
        showAppToast(context, l10n.itemAlreadyExistsSnackbar(name.trim(), list!.name));
      } else {
        manager.addItem(listId, name);
      }
      addController.clear();
      query.value = '';
    }

    void addFromSuggestion(String name) {
      di<GroceryManager>().addItemFromHistory(listId, name);
      addController.clear();
      query.value = '';
    }

    Future<void> deleteList() async {
      final confirmed = await showDeleteListDialog(context, list!.name);
      if (!confirmed) return;
      di<GroceryManager>().deleteList(listId);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(list.name),
        actions: [
          IconButton(
            tooltip: l10n.historyTooltip,
            icon: const Icon(LucideIcons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryPage(listId: listId, listName: list!.name),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.deleteListTooltip,
            icon: const Icon(LucideIcons.trash2),
            onPressed: deleteList,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: list.items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.nothingHereYet,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.muted,
                      ),
                    ),
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: list.items.length,
                    itemBuilder: (context, index) {
                      final item = list!.items[index];
                      return GroceryItemTile(
                        item: item,
                        onTap: () => di<GroceryManager>().removeItem(listId, item.id),
                      );
                    },
                  ),
          ),
          if (queryText.trim().isNotEmpty && suggestions.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ShadButton.outline(
                    onPressed: () => addFromSuggestion(suggestion),
                    leading: const Icon(LucideIcons.history, size: 14),
                    child: Text(suggestion),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ShadInput(
              controller: addController,
              placeholder: Text(l10n.addItemPlaceholder),
              leading: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(LucideIcons.plus),
              ),
              onChanged: (value) => query.value = value,
              onSubmitted: (value) {
                final trimmed = value.trim();
                if (trimmed.isEmpty) return;
                addItem(trimmed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
