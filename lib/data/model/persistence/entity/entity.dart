import 'package:holapp/data/model/persistence/entity/id.dart';

abstract class PersistenceEntity {
  PersistenceId id;

  PersistenceEntity({required this.id});
}
