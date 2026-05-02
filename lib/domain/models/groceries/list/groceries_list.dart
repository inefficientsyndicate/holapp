import 'package:holapp/domain/models/entity/entity.dart';
import 'package:holapp/domain/models/entity/id.dart';
import 'package:holapp/domain/models/groceries/item/groceries_item.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list_id.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

typedef GroceriesListFactory = GroceriesList Function({required String name});

sealed class GroceriesList extends Entity<GroceriesListId> {
  @override
  GroceriesListId id;
  String name;
  DateTime date;
  List<GroceriesItem> groceries;
  IconData icon;

  GroceriesList({
    required this.id,
    required this.name,
    required this.date,
    required this.groceries,
    required this.icon,
  }) : super(id: id);

  static final Map<Type, GroceriesListFactory> _registry = {};

  static void register(Type type, GroceriesListFactory groceriesListFactory) {
    _registry[type] = groceriesListFactory;
  }

  static List<Type> get types => _registry.keys.toList();

  static GroceriesList create(Type type, {required String name}) {
    final factory =
        _registry[type] ??
        (throw Exception("GroceriesList type not registered: $type"));

    return factory(name: name);
  }

  static void provideFactoryRegistry() {
    DisposableGroceriesList.register();
    PersistentGroceriesList.register();
  }
}

enum GroceriesListSortableProperty { name, count, date }

extension GroceriesListSortablePropertyExt on GroceriesListSortableProperty {
  String displayName() => switch (this) {
    GroceriesListSortableProperty.name => "name",
    GroceriesListSortableProperty.count => "count",
    GroceriesListSortableProperty.date => "date",
  };
}

class DisposableGroceriesList extends GroceriesList {
  DisposableGroceriesList({
    required super.id,
    required super.name,
    required super.date,
    required super.groceries,
    required super.icon,
  });

  factory DisposableGroceriesList.init(String name) {
    return DisposableGroceriesList(
      id: GroceriesListId(value: Id.empty()),
      name: name,
      date: DateTime.now(),
      groceries: [],
      icon: LucideIcons.list,
    );
  }

  static void register() {
    GroceriesList.register(
      DisposableGroceriesList,
      ({required String name}) => DisposableGroceriesList.init(name),
    );
  }
}

class PersistentGroceriesList extends GroceriesList {
  List<GroceriesItem> history = [];

  PersistentGroceriesList({
    required super.id,
    required super.name,
    required super.date,
    required super.groceries,
    required super.icon,
  });

  factory PersistentGroceriesList.init(String name) {
    return PersistentGroceriesList(
      id: GroceriesListId(value: Id.empty()),
      name: name,
      date: DateTime.now(),
      groceries: [],
      icon: LucideIcons.list,
    );
  }

  static void register() {
    GroceriesList.register(
      PersistentGroceriesList,
      ({required String name}) => PersistentGroceriesList.init(name),
    );
  }
}
