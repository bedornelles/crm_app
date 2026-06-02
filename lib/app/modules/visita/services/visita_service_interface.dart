import 'package:crm_app/app/shared/service/base_service_interface.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

abstract class IVisitaService implements IService<VisitaEntity> {
  Future<List<VisitaEntity>> getAllNaoSincronizadas();
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario);

  Future<List<String>> getEnderecos(String logradouro);
  Future<List<String>> getCidades(String cidade);
  Future<String> getLastCidade();
}