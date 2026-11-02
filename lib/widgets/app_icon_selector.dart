import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_icon_variant.dart';

/// Lets the user pick the app's home screen icon from a row of previews.
class AppIconSelector extends StatelessWidget {
  const AppIconSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppIconVariant value;
  final ValueChanged<AppIconVariant> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = ShadTheme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final option in AppIconVariant.values)
          _Preview(
            asset: option.previewAsset,
            label: option.label(l10n),
            selected: option == value,
            borderColor: option == value
                ? theme.colorScheme.primary
                : theme.colorScheme.border,
            onTap: () => onChanged(option),
          ),
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.asset,
    required this.label,
    required this.selected,
    required this.borderColor,
    required this.onTap,
  });

  static const _radius = BorderRadius.all(Radius.circular(14));

  final String asset;
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
          borderRadius: _radius,
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: _radius,
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(asset, excludeFromSemantics: true),
            ),
          ),
        ),
      ),
    );
  }
}
