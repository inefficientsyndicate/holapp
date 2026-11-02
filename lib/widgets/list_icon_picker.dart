import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/list_icons.dart';

/// A scrollable grid of [listIcons]. Tapping the selected icon clears it, so
/// [onChanged] receives `null` when no icon is selected.
class ListIconPicker extends StatefulWidget {
  const ListIconPicker({required this.onChanged, this.initialIcon, super.key});

  final String? initialIcon;
  final ValueChanged<String?> onChanged;

  @override
  State<ListIconPicker> createState() => _ListIconPickerState();
}

class _ListIconPickerState extends State<ListIconPicker> {
  late String? _selected = widget.initialIcon;

  void _select(String key) {
    setState(() => _selected = key == _selected ? null : key);
    widget.onChanged(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ConstrainedBox(
      // Cuts through a row of icons to hint that the grid scrolls.
      constraints: const BoxConstraints(maxHeight: 166),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final MapEntry(:key, :value) in listIcons.entries)
              Semantics(
                selected: key == _selected,
                child: Material(
                  color: key == _selected ? theme.colorScheme.primary : Colors.transparent,
                  borderRadius: theme.radius,
                  child: InkWell(
                    borderRadius: theme.radius,
                    onTap: () => _select(key),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Icon(
                        value,
                        size: 20,
                        color: key == _selected
                            ? theme.colorScheme.primaryForeground
                            : theme.colorScheme.foreground,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
