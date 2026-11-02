// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get newList => 'New list';

  @override
  String get addItemPlaceholder => 'Add an item…';

  @override
  String get historyTooltip => 'History';

  @override
  String get deleteListTooltip => 'Delete list';

  @override
  String get listPageTitleFallback => 'List';

  @override
  String get listNotFound => 'This list no longer exists.';

  @override
  String get nothingHereYet =>
      'Nothing here yet. Add items below — tap one to mark it collected.';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get newListDialogTitle => 'New list';

  @override
  String get newListDialogDescription => 'Give your grocery list a name.';

  @override
  String get newListPlaceholder => 'e.g. Weekly groceries';

  @override
  String get newListIconLabel => 'Icon (optional)';

  @override
  String get save => 'Save';

  @override
  String get changeListIconTooltip => 'Change icon';

  @override
  String get changeListIconDialogTitle => 'Choose an icon';

  @override
  String get changeListIconDialogDescription =>
      'Tap the selected icon again to remove it.';

  @override
  String chooseListTitle(String itemName) {
    return 'Add \"$itemName\" to…';
  }

  @override
  String get chooseListDescription => 'Choose a list for this item.';

  @override
  String get deleteListDialogTitle => 'Delete this list?';

  @override
  String deleteListDialogDescription(String listName) {
    return 'This will permanently delete \"$listName\" and all of its items and history.';
  }

  @override
  String get delete => 'Delete';

  @override
  String historyPageTitle(String listName) {
    return '$listName · History';
  }

  @override
  String get nothingCollectedYet => 'Nothing collected yet.';

  @override
  String addedToListSnackbar(String itemName, String listName) {
    return 'Added \"$itemName\" to $listName';
  }

  @override
  String itemAlreadyExistsSnackbar(String itemName, String listName) {
    return '\"$itemName\" is already on $listName';
  }

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get tilesPerRow => 'Tiles per row';

  @override
  String get listsOverviewLabel => 'Lists overview';

  @override
  String get itemsInAListLabel => 'Items in a list';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get colorThemeLabel => 'Color theme';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorRed => 'Red';

  @override
  String get colorRose => 'Rose';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorZinc => 'Zinc';

  @override
  String get colorSlate => 'Slate';

  @override
  String get colorStone => 'Stone';

  @override
  String get colorGray => 'Gray';

  @override
  String get colorNeutral => 'Neutral';

  @override
  String get appIconLabel => 'App icon';

  @override
  String get appIconMidnight => 'Midnight';

  @override
  String get appIconLight => 'Light';

  @override
  String get appIconGreen => 'Green';

  @override
  String get appIconChangeFailed => 'Couldn\'t change the app icon.';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageLabel => 'App language';
}
