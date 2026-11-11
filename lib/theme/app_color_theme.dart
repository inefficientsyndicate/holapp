import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// The accent color schemes the user can pick from in Settings.
enum AppColorTheme {
  green,
  blue,
  orange,
  red,
  rose,
  violet,
  yellow,
  zinc,
  slate,
  stone,
  gray,
  neutral,
}

extension AppColorThemeX on AppColorTheme {
  ShadColorScheme light() {
    switch (this) {
      case AppColorTheme.green:
        return const ShadGreenColorScheme.light();
      case AppColorTheme.blue:
        return const ShadBlueColorScheme.light();
      case AppColorTheme.orange:
        return const ShadOrangeColorScheme.light();
      case AppColorTheme.red:
        return const ShadRedColorScheme.light();
      case AppColorTheme.rose:
        return const ShadRoseColorScheme.light();
      case AppColorTheme.violet:
        return const ShadVioletColorScheme.light();
      case AppColorTheme.yellow:
        return const ShadYellowColorScheme.light();
      case AppColorTheme.zinc:
        return const ShadZincColorScheme.light();
      case AppColorTheme.slate:
        return const ShadSlateColorScheme.light();
      case AppColorTheme.stone:
        return const ShadStoneColorScheme.light();
      case AppColorTheme.gray:
        return const ShadGrayColorScheme.light();
      case AppColorTheme.neutral:
        return const ShadNeutralColorScheme.light();
    }
  }

  ShadColorScheme dark() {
    switch (this) {
      case AppColorTheme.green:
        return const ShadGreenColorScheme.dark();
      case AppColorTheme.blue:
        return const ShadBlueColorScheme.dark();
      case AppColorTheme.orange:
        return const ShadOrangeColorScheme.dark();
      case AppColorTheme.red:
        return const ShadRedColorScheme.dark();
      case AppColorTheme.rose:
        return const ShadRoseColorScheme.dark();
      case AppColorTheme.violet:
        return const ShadVioletColorScheme.dark();
      case AppColorTheme.yellow:
        return const ShadYellowColorScheme.dark();
      case AppColorTheme.zinc:
        return const ShadZincColorScheme.dark();
      case AppColorTheme.slate:
        return const ShadSlateColorScheme.dark();
      case AppColorTheme.stone:
        return const ShadStoneColorScheme.dark();
      case AppColorTheme.gray:
        return const ShadGrayColorScheme.dark();
      case AppColorTheme.neutral:
        return const ShadNeutralColorScheme.dark();
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case AppColorTheme.green:
        return l10n.colorGreen;
      case AppColorTheme.blue:
        return l10n.colorBlue;
      case AppColorTheme.orange:
        return l10n.colorOrange;
      case AppColorTheme.red:
        return l10n.colorRed;
      case AppColorTheme.rose:
        return l10n.colorRose;
      case AppColorTheme.violet:
        return l10n.colorViolet;
      case AppColorTheme.yellow:
        return l10n.colorYellow;
      case AppColorTheme.zinc:
        return l10n.colorZinc;
      case AppColorTheme.slate:
        return l10n.colorSlate;
      case AppColorTheme.stone:
        return l10n.colorStone;
      case AppColorTheme.gray:
        return l10n.colorGray;
      case AppColorTheme.neutral:
        return l10n.colorNeutral;
    }
  }
}
