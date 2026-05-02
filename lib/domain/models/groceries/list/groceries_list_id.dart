import 'package:holapp/domain/models/entity/id.dart';

class GroceriesListId extends Id {
  GroceriesListId({required super.value}) : super();

  GroceriesListId.init({required super.value}) {
    value = Id.empty();
  }
}
