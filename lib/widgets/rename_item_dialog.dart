import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../models/grocery_item.dart';
import '../models/grocery_list.dart';
import 'app_toast.dart';
import 'rename_dialog.dart';

/// Shows a dialog for renaming [item] and saves the new name unless the user
/// cancelled or [list] already has another item with that name.
Future<void> showRenameItemDialog(
  BuildContext context,
  GroceryList list,
  GroceryItem item,
) async {
  final l10n = AppLocalizations.of(context);
  final name = await showRenameDialog(
    context,
    title: l10n.renameItemDialogTitle,
    placeholder: l10n.renameItemPlaceholder,
    initialName: item.name,
  );
  if (name == null) return;

  final manager = di<GroceryManager>();
  if (manager.hasItem(list.id, name, exceptItemId: item.id)) {
    if (context.mounted) {
      showAppToast(context, l10n.itemAlreadyExistsSnackbar(name, list.name));
    }
  } else {
    manager.renameItem(list.id, item.id, name);
  }
}
