import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/shared/repository/repository_interface.dart';

abstract class IVisitaRepository implements IRepository<VisitaEntity> {
  Future<List<VisitaEntity>> getAllNaoSincronizadas();
  Future<void> marcarComoSincronizada(String id);
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario);
  Future<void> marcarComoErro(String id, String mensagemErro);
  Future<void> marcarComoFalhou(String id, String mensagemErro);
  Future<void> resetarParaPendente(String id);

  Future<List<String>> getEnderecos(String logradouro);
  Future<List<String>> getCidades(String cidade);
  Future<String> getLastCidade();
}