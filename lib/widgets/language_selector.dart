import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// Lets the user pick the app's language: follow the system, or force
/// English or German. Each language's own name is shown untranslated, as
/// is conventional, so it stays findable regardless of the current
/// language.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.locale,
    required this.onChanged,
    super.key,
  });

  final Locale? locale;
  final ValueChanged<Locale?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = <(Locale?, String)>[
      (null, l10n.themeSystem),
      (const Locale('en'), 'English'),
      (const Locale('de'), 'Deutsch'),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (value, label) in options)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: value == locale
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
