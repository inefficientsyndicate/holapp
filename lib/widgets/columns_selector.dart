import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Lets the user pick a tile grid density from [options] (2-4 columns).
class ColumnsSelector extends StatelessWidget {
  const ColumnsSelector({
    required this.columns,
    required this.onChanged,
    this.options = const [2, 3, 4],
    super.key,
  });

  final int columns;
  final ValueChanged<int> onChanged;
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: SizedBox(
              width: 36,
              height: 32,
              child: option == columns
                  ? ShadButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => onChanged(option),
                      child: Text('$option'),
                    )
                  : ShadButton.outline(
                      padding: EdgeInsets.zero,
                      onPressed: () => onChanged(option),
                      child: Text('$option'),
                    ),
            ),
          ),
      ],
    );
  }
}
