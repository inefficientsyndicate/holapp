import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/grocery_item.dart';

/// A tappable tile for a single item. Tapping it marks the item as
/// collected, which removes it from the list; long-pressing it renames it.
class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({
    required this.item,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final GroceryItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: theme.radius,
      child: InkWell(
        borderRadius: theme.radius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: theme.radius,
            border: Border.all(color: theme.colorScheme.border),
            color: theme.colorScheme.card,
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            item.name,
            style: theme.textTheme.p,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
