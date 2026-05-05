import 'dart:convert'; //json decode
import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:crm_app/app/shared/services/base_service.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';

class VisitaService extends BaseService<VisitaEntity, IVisitaRepository> implements IVisitaService {
  
  final ICrmApi _api;
  final ICache _cache;

  VisitaService(super.repository, this._api, this._cache);

  @override
  Future<List<VisitaEntity>> getByApi(int limit, int offset) async {
    //buscando o ususario que esta logado no cache
    final jsonUsuario = _cache.getString(cacheUsuarioKey);
    print('1json do cache: $jsonUsuario');

    if (jsonUsuario == null) {
      throw Exception('usuario nao encontrado no cache para realziar busca');
    }

    final mapUsuario = jsonDecode(jsonUsuario);
    final usuarioLogado = UsuarioEntity.fromJson(mapUsuario);

    print('2 id exraido do usuario ${usuarioLogado.id}');
    final String idLogado = usuarioLogado.id;

    //envia o idusuario como um parametro no filtro
    print('3 chamando api na rota');
    final response = await _api.getAll(
        uri: '/visita/usuario/$idLogado',
    );
    print('id logado $idLogado');
    print('4. Tipo de dados recebido da API: ${response.runtimeType}');
    print('5. Resposta da API: $response');

    return response.map((json) {
      print('6. Convertendo visita: $json');
      return VisitaEntity.fromApiMap(json);
    }).toList();
  }

  @override
  Future<void> buscarVisitasDaApiESalvarLocal() async {
    try {
      //limpar o banco de dados antes do GET
      print('limoando visitas antigas para o novo login');
      await limparTabelaDoBancoLocal();
      //busca vivistas da api
      print('Buscando visitas da api');
      final visitasDaApi = await getByApi(100, 0);

      //salva visita no banco local
      for (var visita in visitasDaApi) {
        //salva local
        await super.saveOrUpdate(visita);
        //marca como sincornizada
        await repository.marcarComoSincronizada(visita.base.id);
      }
      print('${visitasDaApi.length} visitas baixadas e salvas no banco');
    }catch (e) {
      print ('erro ao sincornizar visias na api $e');
    }
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
        //le o cache para ver se tem alguem logado
        final jsonUsuario = _cache.getString(cacheUsuarioKey);

        if (jsonUsuario == null) {
          throw Exception('nenhum usuario logado no cache. nao envou a visita');
        }

        //transforma o texto em map e depois em usuarioentity (para ler e decodificar o token)
        final mapUsuario = jsonDecode(jsonUsuario);
        final usuarioLogado = UsuarioEntity.fromJson(mapUsuario);

        //pega o id usando getter do jwt
        String idUsuarioLogado = usuarioLogado.id;

        //passa o ID para o payload
        final payload = visita.toApiMap(idUsuarioLogado);

        print('=== dados enviados a api ===');
        print(payload);
        print('=======');

        ///caminho
        await _api.post(uri: '/visita/create', data: payload);

        //se API responder sucesso, atualiza o banco local
        await repository.marcarComoSincronizada(visita.base.id);
        print('Visita enviada a api e marcada sincronizada no banco');

      } catch (e) {
        //se a API falhar a visita continua salva no local como pendente
        print('Erro ao enviar para api, visita pendente. erro: $e');
      }
    } catch (e) {
      //erro no sqlite
      throw Exception('Erro ao salvar visita no banco local: $e');
    }
  }
}