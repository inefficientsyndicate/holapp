import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import 'list_icon_picker.dart';

/// Shows a dialog asking for a new list name, creates the list and
/// returns its id, or `null` if the user cancelled.
Future<String?> showCreateListDialog(BuildContext context) async {
  final controller = TextEditingController();
  String? icon;
  final confirmed = await showShadDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return ShadDialog(
        title: Text(l10n.newListDialogTitle),
        description: Text(l10n.newListDialogDescription),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ShadButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.create),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadInput(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                placeholder: Text(l10n.newListPlaceholder),
                autofocus: true,
                onSubmitted: (_) => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: 12),
              Text(l10n.newListIconLabel, style: ShadTheme.of(context).textTheme.muted),
              const SizedBox(height: 8),
              ListIconPicker(onChanged: (value) => icon = value),
            ],
          ),
        ),
      );
    },
  );

  final name = controller.text.trim();
  controller.dispose();

  if (confirmed == true && name.isNotEmpty) {
    return di<GroceryManager>().createList(name, icon: icon);
  }
  return null;
}
