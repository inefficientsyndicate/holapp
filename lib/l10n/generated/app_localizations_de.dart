// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get newList => 'Neue Liste';

  @override
  String get addItemPlaceholder => 'Artikel hinzufügen …';

  @override
  String get historyTooltip => 'Verlauf';

  @override
  String get deleteListTooltip => 'Liste löschen';

  @override
  String get listPageTitleFallback => 'Liste';

  @override
  String get listNotFound => 'Diese Liste existiert nicht mehr.';

  @override
  String get nothingHereYet =>
      'Noch nichts hier. Füge unten Artikel hinzu — tippe einen an, um ihn als erledigt zu markieren.';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get newListDialogTitle => 'Neue Liste';

  @override
  String get newListDialogDescription =>
      'Gib deiner Einkaufsliste einen Namen.';

  @override
  String get newListPlaceholder => 'z. B. Wocheneinkauf';

  @override
  String chooseListTitle(String itemName) {
    return '„$itemName“ hinzufügen zu…';
  }

  @override
  String get chooseListDescription => 'Wähle eine Liste für diesen Artikel.';

  @override
  String get deleteListDialogTitle => 'Diese Liste löschen?';

  @override
  String deleteListDialogDescription(String listName) {
    return '„$listName“ und alle zugehörigen Artikel und der Verlauf werden dauerhaft gelöscht.';
  }

  @override
  String get delete => 'Löschen';

  @override
  String historyPageTitle(String listName) {
    return '$listName · Verlauf';
  }

  @override
  String get nothingCollectedYet => 'Noch nichts gesammelt.';

  @override
  String addedToListSnackbar(String itemName, String listName) {
    return '„$itemName“ zu $listName hinzugefügt';
  }

  @override
  String itemAlreadyExistsSnackbar(String itemName, String listName) {
    return '„$itemName“ ist bereits auf $listName';
  }

  @override
  String get settingsPageTitle => 'Einstellungen';

  @override
  String get tilesPerRow => 'Kacheln pro Zeile';

  @override
  String get listsOverviewLabel => 'Listenübersicht';

  @override
  String get itemsInAListLabel => 'Artikel in einer Liste';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get themeLabel => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get colorThemeLabel => 'Farbthema';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorRed => 'Rot';

  @override
  String get colorRose => 'Rosé';

  @override
  String get colorViolet => 'Violett';

  @override
  String get colorYellow => 'Gelb';

  @override
  String get colorZinc => 'Zink';

  @override
  String get colorSlate => 'Schiefer';

  @override
  String get colorStone => 'Stein';

  @override
  String get colorGray => 'Grau';

  @override
  String get colorNeutral => 'Neutral';

  @override
  String get languageSectionTitle => 'Sprache';

  @override
  String get languageLabel => 'App-Sprache';
}
