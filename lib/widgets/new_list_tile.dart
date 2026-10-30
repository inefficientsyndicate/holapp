import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// A tile matching [GroceryListTile]'s shape, appended as the last item of
/// the lists grid to create a new list.
class NewListTile extends StatelessWidget {
  const NewListTile({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: theme.radius,
      child: InkWell(
        borderRadius: theme.radius,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: theme.radius,
            border: Border.all(color: theme.colorScheme.primary),
            color: theme.colorScheme.card,
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.plus, color: theme.colorScheme.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).newList,
                style: theme.textTheme.p.copyWith(color: theme.colorScheme.primary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
