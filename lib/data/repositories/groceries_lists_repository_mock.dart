import 'package:holapp/domain/models/entity/id.dart';
import 'package:holapp/domain/models/groceries/item/groceries_item.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list_id.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

class GroceriesListRepositoryMock {
  static final instance = GroceriesListRepositoryMock();

  final List<GroceriesList> _lists = [
    PersistentGroceriesList.init("Rewe"),
    DisposableGroceriesList.init("Birthdaypardaaayy"),
    PersistentGroceriesList.init("Lidl"),
    PersistentGroceriesList(
      id: GroceriesListId(value: Id.empty()),
      name: "Aldi",
      date: DateTime.now(),
      groceries: [GroceriesItem.onePiece("item")],
      icon: LucideIcons.list,
    ),
  ];

  Future<List<GroceriesList>> getAll() async {
    return List.unmodifiable(_lists);
  }

  Future<void> add(GroceriesList list) async {
    _lists.add(list);
  }

  Future<void> remove(GroceriesList list) async {
    _lists.remove(list);
  }

  Future<GroceriesList?> findByIdOrNull(Id id) async {
    return _lists.firstWhere((it) => it.id == id);
  }
}
