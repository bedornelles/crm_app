import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'base_store.g.dart';

class BaseStore = _BaseStoreBase with _$BaseStore;

abstract class BaseStoreFactory {
  static BaseStore fromEntity(BaseEntity base) => BaseStore(
    id: base.id,
    dataHoraCriado: base.dataHoraCriado,
    dataHoraUltimaAlteracao: base.dataHoraUltimaAlteracao,
    dataHoraDeletado: base.dataHoraDeletado,
  );

  static BaseStore novo() => BaseStore(
    id: const Uuid().v4(),
    dataHoraCriado: null,
    dataHoraUltimaAlteracao: null,
    dataHoraDeletado: null,
  );
}

abstract class _BaseStoreBase with Store {
  @observable
  String id;

  @observable
  DateTime? dataHoraCriado;

  @observable
  DateTime? dataHoraUltimaAlteracao;

  @observable
  DateTime? dataHoraDeletado;

  bool get deletado => dataHoraDeletado != null;

  _BaseStoreBase({
    required this.id,
    required this.dataHoraCriado,
    required this.dataHoraUltimaAlteracao,
    required this.dataHoraDeletado,
});

  BaseEntity toEntity() => BaseEntity(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraUltimaAlteracao,
    dataHoraDeletado: dataHoraDeletado,
  );

  BaseStore clone () => BaseStore(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraUltimaAlteracao,
    dataHoraDeletado: dataHoraDeletado,
  );
}

