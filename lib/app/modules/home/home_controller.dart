import 'dart:async';
import 'dart:convert';

import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/app_controller.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final IVisitaService _service;
  final ICache _cache;

  StreamSubscription? _sincronizacaoSubscription;

  _HomeControllerBase(this._service, this._cache) {
    _sincronizacaoSubscription = Modular.get<AppController>()
        .sincronizacaoStream
        .listen((_) {
      load();
    });
  }

  void dispose(){
    _sincronizacaoSubscription?.cancel();
  }

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @observable
  ObservableList<VisitaEntity> visitas = ObservableList<VisitaEntity>();

  @observable
  String idUsuarioLogado = '';

  @action
  void addVisita(VisitaEntity visita) {
    visitas.add(visita);
  }

  @action
  Future<void> desconectar() async {
    try {
      print('iniciando o logout');

      //limpar o cache
      await _cache.remove(cacheUsuarioKey);

      //redireciona e destroi a home
      Modular.to.navigate('/');

      print('logou concluido');
    } catch (e) {
      print('erro ao deslogar: $e');
    }
  }


  @observable
  String nomeUsuario = '...';

  @observable
  String iniciaisUsuario = '';

  @action
  Future<void> carregarDadosUsuario() async {
    try{
      final userJson = await _cache.getString(cacheUsuarioKey);
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        final String? token = userMap['accessToken'];

        //descodificando o token
        if (token != null) {
          // 1. O JWT tem 3 partes separadas por ponto. O Payload é a parte do meio (índice 1).
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = parts[1];

            // 2. O Dart precisa que o Base64 esteja perfeitamente alinhado, então normaliza
            final String normalizedPayload = base64Url.normalize(payload);

            // 3. Descodifica de Base64 para String (JSON)
            final String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

            // 4. Transforma a String num Map para poder ler as chaves
            final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

            // chaves exatas que o back-end colocou dentro do Token
            print('Conteúdo de dentro do Token: $payloadMap');

            nomeUsuario = payloadMap['nome'] ?? 'Usuário';

            //extrai o id do usuario do token
            idUsuarioLogado = payloadMap['id_usuario'] ?? '';

            List<String> nomes = nomeUsuario.trim().split(' ');
            if (nomes.isNotEmpty && nomes.first.isNotEmpty) {
              if (nomes.length > 1) {
                iniciaisUsuario = (nomes.first[0] + nomes.last[0]).toUpperCase();
              } else {
                iniciaisUsuario = nomes.first[0].toUpperCase();
              }

            }
          }
        }
      }
    } catch (e) {
      print('Erro ao carregae as iniciais do usuario: $e');
    }
  }
  @action
  Future<void> load() async {
    try {
      _loading = true;

      // 1. Primeiro, carrega os dados do usuário (Nome, Iniciais e ID) do cache/token.
      // Precisa esperar isso terminar para ter o 'idUsuarioLogado' preenchido.
      await carregarDadosUsuario();

      // 2. Agora que tem o ID, chama o novo metodo filtrado.
      if (idUsuarioLogado.isNotEmpty) {
        final lista = await _service.getVisitasPorUsuario(idUsuarioLogado);
        visitas = ObservableList.of(lista);
      } else {
        // Caso não encontre o ID (ex: erro no token), limpa a lista
        visitas = ObservableList<VisitaEntity>();
        print('Aviso: Nenhum ID de usuário encontrado para filtrar as visitas.');
      }

    } catch (e) {
      print('Erro ao carregar dados da Home: $e');
    } finally {
      _loading = false;
    }
  }

}

