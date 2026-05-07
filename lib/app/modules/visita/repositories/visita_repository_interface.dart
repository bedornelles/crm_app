import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/shared/repositories/repository_interface.dart';

abstract class IVisitaRepository implements IRepository<VisitaEntity> {
  Future<List<VisitaEntity>> getAllNaoSincronizadas();
  Future<void> marcarComoSincronizada(String id);
  Future<void> limparTabelaDoBancoLocal();
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario);
}