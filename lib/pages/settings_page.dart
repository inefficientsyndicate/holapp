import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../manager/grocery_manager.dart';
import '../theme/app_icon_variant.dart';
import '../widgets/app_icon_selector.dart';
import '../widgets/app_toast.dart';
import '../widgets/color_theme_selector.dart';
import '../widgets/columns_selector.dart';
import '../widgets/language_selector.dart';
import '../widgets/theme_mode_selector.dart';

class SettingsPage extends WatchingWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listsColumns = watchValue((GroceryManager m) => m.listsColumns);
    final itemsColumns = watchValue((GroceryManager m) => m.itemsColumns);
    final mode = watchValue((GroceryManager m) => m.themeMode);
    final colorTheme = watchValue((GroceryManager m) => m.colorTheme);
    final locale = watchValue((GroceryManager m) => m.locale);
    final appIcon = watchValue((GroceryManager m) => m.appIcon);
    final theme = ShadTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(l10n.settingsPageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.tilesPerRow, style: theme.textTheme.h4),
          const SizedBox(height: 16),
          _SettingRow(
            label: l10n.listsOverviewLabel,
            child: ColumnsSelector(
              columns: listsColumns,
              options: const [2, 3],
              onChanged: (value) => di<GroceryManager>().setListsColumns(value),
            ),
          ),
          const SizedBox(height: 16),
          _SettingRow(
            label: l10n.itemsInAListLabel,
            child: ColumnsSelector(
              columns: itemsColumns,
              onChanged: (value) => di<GroceryManager>().setItemsColumns(value),
            ),
          ),
          const SizedBox(height: 32),
          const ShadSeparator.horizontal(),
          const SizedBox(height: 32),
          Text(l10n.appearance, style: theme.textTheme.h4),
          const SizedBox(height: 16),
          _SettingRow(
            label: l10n.themeLabel,
            child: ThemeModeSelector(
              mode: mode,
              onChanged: (value) => di<GroceryManager>().setThemeMode(value),
            ),
          ),
          const SizedBox(height: 16),
          _SettingRow(
            label: l10n.colorThemeLabel,
            child: ColorThemeSelector(
              value: colorTheme,
              onChanged: (value) => di<GroceryManager>().setColorTheme(value),
            ),
          ),
          if (appIcon != null) ...[
            const SizedBox(height: 16),
            _SettingRow(
              label: l10n.appIconLabel,
              child: AppIconSelector(
                value: appIcon,
                onChanged: (value) => _changeAppIcon(context, value),
              ),
            ),
          ],
          const SizedBox(height: 32),
          const ShadSeparator.horizontal(),
          const SizedBox(height: 32),
          Text(l10n.languageSectionTitle, style: theme.textTheme.h4),
          const SizedBox(height: 16),
          _SettingRow(
            label: l10n.languageLabel,
            child: LanguageSelector(
              locale: locale,
              onChanged: (value) => di<GroceryManager>().setLocale(value),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeAppIcon(BuildContext context, AppIconVariant icon) async {
    final message = AppLocalizations.of(context).appIconChangeFailed;
    final changed = await di<GroceryManager>().setAppIcon(icon);
    if (!changed && context.mounted) {
      showAppToast(context, message, aboveInputBar: false);
    }
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.p),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
