import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// Asks for a new name, starting from [initialName] with all of it selected.
/// Returns the trimmed name, or `null` if the user cancelled or left it empty.
Future<String?> showRenameDialog(
  BuildContext context, {
  required String title,
  required String placeholder,
  required String initialName,
}) async {
  final controller = TextEditingController(text: initialName)
    ..selection = TextSelection(baseOffset: 0, extentOffset: initialName.length);
  final confirmed = await showShadDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return ShadDialog(
        title: Text(title),
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
          child: ShadInput(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            placeholder: Text(placeholder),
            autofocus: true,
            onSubmitted: (_) => Navigator.of(context).pop(true),
          ),
        ),
      );
    },
  );

  final name = controller.text.trim();
  controller.dispose();

  return confirmed == true && name.isNotEmpty ? name : null;
}
