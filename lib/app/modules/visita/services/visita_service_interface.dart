import 'package:crm_app/app/shared/services/base_service_interface.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

abstract class IVisitaService implements IService<VisitaEntity> {
  Future<void> limparTabelaDoBancoLocal();

  Future<List<VisitaEntity>> getByApi(int limit, int offset);
  Future<List<VisitaEntity>> getAllNaoSincronizadas();
  Future<void> salvarEEnviar(VisitaEntity visita);
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario);
  // Future<void> buscarVisitasDaApiESalvarLocal();
}