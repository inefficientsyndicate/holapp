import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_color_theme.dart';

/// Lets the user pick the app's accent color scheme as a row of swatches.
class ColorThemeSelector extends StatelessWidget {
  const ColorThemeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppColorTheme value;
  final ValueChanged<AppColorTheme> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = ShadTheme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final option in AppColorTheme.values)
          _Swatch(
            color: option.light().primary,
            label: option.label(l10n),
            selected: option == value,
            borderColor: theme.colorScheme.border,
            onTap: () => onChanged(option),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.borderColor,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? color : borderColor,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6)]
                  : null,
            ),
            alignment: Alignment.center,
            child: selected
                ? Icon(LucideIcons.check, size: 16, color: _onColor(color))
                : null,
          ),
        ),
      ),
    );
  }

  Color _onColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
