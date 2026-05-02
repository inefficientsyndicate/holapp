import 'package:holapp/domain/models/entity/id.dart';

abstract class Entity<ID extends Id> {
  ID id;

  Entity({required this.id});
}
