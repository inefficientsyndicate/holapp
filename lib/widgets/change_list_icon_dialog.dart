import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../models/grocery_list.dart';
import 'list_icon_picker.dart';

/// Shows a dialog for changing or removing [list]'s icon and saves the result
/// unless the user cancelled.
Future<void> showChangeListIconDialog(BuildContext context, GroceryList list) async {
  var icon = list.icon;
  final confirmed = await showShadDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return ShadDialog(
        title: Text(l10n.changeListIconDialogTitle),
        description: Text(l10n.changeListIconDialogDescription),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ShadButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.save),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListIconPicker(
            initialIcon: icon,
            onChanged: (value) => icon = value,
          ),
        ),
      );
    },
  );

  if (confirmed == true) {
    di<GroceryManager>().setListIcon(list.id, icon);
  }
}
