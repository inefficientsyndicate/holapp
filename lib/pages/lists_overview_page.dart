import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../widgets/app_toast.dart';
import '../widgets/choose_list_dialog.dart';
import '../widgets/create_list_dialog.dart';
import '../widgets/grocery_list_tile.dart';
import 'settings_page.dart';

class ListsOverviewPage extends WatchingWidget {
  const ListsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quickAddController = createOnce(() => TextEditingController());
    final lists = watchValue((GroceryManager m) => m.lists);
    final columns = watchValue((GroceryManager m) => m.listsColumns);
    final theme = ShadTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // App name/wordmark, not translated.
        title: const Text('hol.'),
        actions: [
          IconButton(
            tooltip: l10n.settingsTooltip,
            icon: const Icon(LucideIcons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ShadButton(
              width: double.infinity,
              leading: const Icon(LucideIcons.plus),
              onPressed: () => showCreateListDialog(context),
              child: Text(l10n.newList),
            ),
          ),
          Expanded(
            child: lists.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.noListsYet,
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
                    itemCount: lists.length,
                    itemBuilder: (context, index) => GroceryListTile(list: lists[index]),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ShadInput(
              controller: quickAddController,
              placeholder: Text(l10n.addItemPlaceholder),
              leading: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(LucideIcons.plus),
              ),
              onSubmitted: (value) => _handleQuickAdd(context, value, quickAddController),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _handleQuickAdd(
  BuildContext context,
  String rawValue,
  TextEditingController controller,
) async {
  final value = rawValue.trim();
  if (value.isEmpty) return;

  final manager = di<GroceryManager>();
  final lists = manager.lists.value;
  String? targetListId;
  if (lists.isEmpty) {
    targetListId = await showCreateListDialog(context);
  } else if (lists.length == 1) {
    targetListId = lists.single.id;
  } else {
    targetListId = await showChooseListDialog(context, lists: lists, itemName: value);
  }

  if (targetListId != null) {
    if (manager.hasItem(targetListId, value)) {
      if (context.mounted) {
        final listName = manager.listById(targetListId)?.name ?? '';
        final l10n = AppLocalizations.of(context);
        showAppToast(context, l10n.itemAlreadyExistsSnackbar(value, listName));
      }
    } else {
      manager.addItem(targetListId, value);
    }
  }
  controller.clear();
}
