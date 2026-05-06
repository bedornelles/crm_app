import 'dart:convert';

import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final IVisitaService _service;
  final ICache _cache;

  _HomeControllerBase(this._service, this._cache);

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @observable
  ObservableList<VisitaEntity> visitas = ObservableList<VisitaEntity>();

  // @action
  // Future <void> load() async {
  //   try {
  //     _loading = true;
  //     final lista = await _service.getAll();
  //     visitas = ObservableList.of(lista);
  //   }finally{
  //     _loading = false;
  //   }
  // }

  @action
  void addVisita(VisitaEntity visita) {
    visitas.add(visita);
  }

  @action
  Future<void> desconectar() async {
    try {
      print('iniciando o logout');

      //limpa o banco local
      await _service.limparTabelaDoBancoLocal();

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

            // 5. Tenta pegar o nome. Geralmente fica em 'name', 'sub', 'unique_name' ou 'username'
            // Troque o 'name' abaixo pela chave correta que aparecer no print acima!
            nomeUsuario = payloadMap['nome'] ?? 'Usuário';

            List<String> nomes = nomeUsuario.trim().split(' ');
            if (nomes.length > 1) {
              iniciaisUsuario = (nomes.first[0] + nomes.last[0]).toUpperCase();
            } else {
              iniciaisUsuario = nomes.first[0].toUpperCase();
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

      await Future.wait([
        carregarDadosUsuario(),
        _service.getAll().then((lista) => visitas = ObservableList.of(lista)),
      ]);
    } finally {
      _loading = false;
    }
  }
}

