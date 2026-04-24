import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/services/base_service.dart';
// TODO: Importar a API quando estiver pronta
// import 'package:crm_app/app/shared/api/crm_api_interface.dart';

class VisitaService extends BaseService<VisitaEntity, IVisitaRepository> implements IVisitaService {
  
  //final ICrmApi _api; //descomentar quando tiver API
  
  // VisitaService(super.repository);
  VisitaService(super.respository);

  @override
  Future<List<VisitaEntity>> getByApi(int limit, int offset) async {
    // TODO: implement a chamada da api
    //final response = await _api.getAll(uri: '/visitas', queryParameter:{'limit': limit, 'offset': offset});
    // return response.map((json) => VisitaEntity.fromMap(json)).toList();
    return [];
  }

  @override
  Future<List<VisitaEntity>> getAllNaoSincronizadas() async {
    // Exigirá que esse metodo exista lá no seu IVisitaRepository!
    // return await repository.getAllNaoSincronizadas();
    return []; // Retorno vazio temporário
  }

  @override
  Future<void> limparTabelaDoBancoLocal() async {
    // Exigirá que esse metodo exista lá no seu IVisitaRepository!
    // await repository.limparTabelaDoBancoLocal();
  }
  
  
}