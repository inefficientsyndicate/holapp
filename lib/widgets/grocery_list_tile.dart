import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/grocery_list.dart';
import '../pages/list_detail_page.dart';

class GroceryListTile extends StatelessWidget {
  const GroceryListTile({required this.list, super.key});

  final GroceryList list;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: theme.radius,
      child: InkWell(
        borderRadius: theme.radius,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ListDetailPage(listId: list.id)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: theme.radius,
            border: Border.all(color: theme.colorScheme.border),
            color: theme.colorScheme.card,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                list.name,
                style: theme.textTheme.p,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                AppLocalizations.of(context).itemCount(list.items.length),
                style: theme.textTheme.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
