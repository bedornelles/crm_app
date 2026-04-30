import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/services/base_service.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';

class VisitaService extends BaseService<VisitaEntity, IVisitaRepository> implements IVisitaService {
  
  final ICrmApi _api;

  VisitaService(super.repository, this._api);

  @override
  Future<List<VisitaEntity>> getByApi(int limit, int offset) async {
    final response = await _api.getAll(
        uri: '/visitas',
        queryParameters:{'limit': limit, 'offset': offset});
    return response.map((json) => VisitaEntity.fromMap(json)).toList();
  }

  @override
  Future<List<VisitaEntity>> getAllNaoSincronizadas() async {
    return await repository.getAllNaoSincronizadas();
  }

  @override
  Future<void> limparTabelaDoBancoLocal() async {
    await repository.limparTabelaDoBancoLocal();
  }
}