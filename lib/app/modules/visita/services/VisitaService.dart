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

  @override
  Future<void> salvarEEnviar(VisitaEntity visita) async {
    try {
      //salva no banco local
      await super.saveOrUpdate(visita);
      print('Visita salva no banco local');

      //tenta enviar a API
      try {
        String idUsuarioLogado = "8f245833-d5bd-4c68-bb98-92e7ddde0819";
        //print para ver o erro
        final payload = visita.toApiMap(idUsuarioLogado);
        print('=== dados enviados a api ===');
        print(payload);
        print('=======');

        await _api.post(uri: '/visita', data: payload);

        //se API responder sucesso, atualiza o banco local
        await repository.marcarComoSincronizada(visita.base.id);
        print('Visita enviada a api e marcada sincronizada no banco');

      } catch (e) {
        //se aAPI falhar a visita continua salva no local como pendente
        print('Erro ao enviar para api, visita pendente. erro: $e');
      }
    } catch (e) {
      //erro no sqlite
      throw Exception('Erro ao salvar visita no banco local: $e');
    }
  }
}