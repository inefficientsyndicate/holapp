import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// Lets the user pick the app's theme: follow the system, or force light
/// or dark.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = [
      (ThemeMode.system, l10n.themeSystem),
      (ThemeMode.light, l10n.themeLight),
      (ThemeMode.dark, l10n.themeDark),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (value, label) in options)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: value == mode
                ? ShadButton(
                    onPressed: () => onChanged(value),
                    child: Text(label),
                  )
                : ShadButton.outline(
                    onPressed: () => onChanged(value),
                    child: Text(label),
                  ),
          ),
      ],
    );
  }
}
