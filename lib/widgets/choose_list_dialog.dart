import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/grocery_list.dart';

/// Shows a dialog letting the user pick which list an item should be
/// saved to. Returns the chosen list's id, or `null` if cancelled.
Future<String?> showChooseListDialog(
  BuildContext context, {
  required List<GroceryList> lists,
  required String itemName,
}) {
  return showShadDialog<String>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return ShadDialog(
        title: Text(l10n.chooseListTitle(itemName)),
        description: Text(l10n.chooseListDescription),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final list in lists)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ShadButton.outline(
                      onPressed: () => Navigator.of(context).pop(list.id),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(list.name),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
