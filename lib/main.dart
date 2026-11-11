import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'l10n/generated/app_localizations.dart';
import 'locator.dart';
import 'manager/grocery_manager.dart';
import 'pages/lists_overview_page.dart';
import 'theme/app_color_theme.dart';

// Merged over shadcn's defaults (14px text, 8px vertical padding).
const _inputTheme = ShadInputTheme(
  style: TextStyle(fontSize: 16),
  placeholderStyle: TextStyle(fontSize: 16),
  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const GroceriesApp());
}

class GroceriesApp extends WatchingWidget {
  const GroceriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ready = allReady();
    // Only watched once the manager is ready, since it isn't registered
    // yet on the first (splash) build; these are the last watch calls
    // here and always run together, so their relative order stays fixed.
    final themeMode = ready ? watchValue((GroceryManager m) => m.themeMode) : ThemeMode.system;
    final locale = ready ? watchValue((GroceryManager m) => m.locale) : null;
    final colorTheme =
        ready ? watchValue((GroceryManager m) => m.colorTheme) : AppColorTheme.green;
    return ShadApp(
      debugShowCheckedModeBanner: false,
      title: 'Groceries',
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: colorTheme.light(),
        inputTheme: _inputTheme,
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: colorTheme.dark(),
        inputTheme: _inputTheme,
      ),
      themeMode: themeMode,
      // Flutter only drops text focus on outside taps for mouse/stylus on
      // mobile; make touch taps anywhere else close the keyboard too. Taps
      // inside the field's TapRegion group (see groupId) don't count.
      actions: {
        ...WidgetsApp.defaultActions,
        EditableTextTapOutsideIntent: CallbackAction<EditableTextTapOutsideIntent>(
          onInvoke: (intent) => intent.focusNode.unfocus(),
        ),
      },
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // top is left to each Scaffold's AppBar, which already insets for the
      // status bar; SafeArea here just guards the edges AppBar doesn't.
      // ShadApp builds on WidgetsApp rather than MaterialApp, so it doesn't
      // provide a ScaffoldMessenger itself — add one so SnackBars work.
      builder: (context, child) => ScaffoldMessenger(
        child: SafeArea(top: false, child: child!),
      ),
      home: ready ? const ListsOverviewPage() : const _Splash(),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
