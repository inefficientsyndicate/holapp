import '../l10n/generated/app_localizations.dart';

/// The home screen icons the user can pick from in Settings. The names are
/// shared with the native side of the `holapp/app_icon` channel.
enum AppIconVariant { midnight, light, green }

extension AppIconVariantX on AppIconVariant {
  String get previewAsset => 'assets/icon/previews/$name.png';

  String label(AppLocalizations l10n) {
    switch (this) {
      case AppIconVariant.midnight:
        return l10n.appIconMidnight;
      case AppIconVariant.light:
        return l10n.appIconLight;
      case AppIconVariant.green:
        return l10n.appIconGreen;
    }
  }
}
