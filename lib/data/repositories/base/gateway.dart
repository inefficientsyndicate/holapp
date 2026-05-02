import 'package:holapp/data/model/persistence/entity/entity.dart';
import 'package:holapp/data/model/persistence/entity/id.dart';

abstract class Gateway<
  ID extends PersistenceId,
  ENTITY extends PersistenceEntity
> {
  ENTITY save(ENTITY entity);

  ENTITY? findByIdOrNull(ID id);

  List<ENTITY> findAll();
}
