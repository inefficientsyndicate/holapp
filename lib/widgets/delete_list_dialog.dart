import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// Asks the user to confirm deleting [listName]. Returns true if confirmed.
Future<bool> showDeleteListDialog(BuildContext context, String listName) async {
  final confirmed = await showShadDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return ShadDialog.alert(
        title: Text(l10n.deleteListDialogTitle),
        description: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(l10n.deleteListDialogDescription(listName)),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ShadButton.destructive(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
