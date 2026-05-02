import 'package:holapp/data/model/persistence/groceries_list/persistence_groceries_list.dart';
import 'package:holapp/data/model/persistence/groceries_list/persistence_groceries_list_id.dart';
import 'package:holapp/data/repositories/base/gateway.dart';

class GroceriesListsSqliteRepository
    extends Gateway<PersistenceGroceriesListId, PersistenceGroceriesList> {
  static final instance = GroceriesListsSqliteRepository();

  @override
  List<PersistenceGroceriesList> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  PersistenceGroceriesList? findByIdOrNull(PersistenceGroceriesListId id) {
    // TODO: implement findByIdOrNull
    throw UnimplementedError();
  }

  @override
  PersistenceGroceriesList save(PersistenceGroceriesList entity) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
