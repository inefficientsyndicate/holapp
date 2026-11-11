import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../models/grocery_list.dart';
import 'rename_dialog.dart';

/// Shows a dialog for renaming [list] and saves the new name unless the user
/// cancelled.
Future<void> showRenameListDialog(BuildContext context, GroceryList list) async {
  final l10n = AppLocalizations.of(context);
  final name = await showRenameDialog(
    context,
    title: l10n.renameListDialogTitle,
    placeholder: l10n.newListPlaceholder,
    initialName: list.name,
  );
  if (name != null) {
    di<GroceryManager>().renameList(list.id, name);
  }
}
