import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/shared/repository/repository_interface.dart';

abstract class IVisitaRepository implements IRepository<VisitaEntity> {
  Future<List<VisitaEntity>> getAllNaoSincronizadas();
  Future<void> marcarComoSincronizada(String id);
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario);
}