import 'dart:async';
import 'dart:convert';

import 'package:crm_app/app/modules/visita/enum/filtro_data.dart';
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
  Timer? _debounceTimer;

  _HomeControllerBase(this._service, this._cache) {
    _sincronizacaoSubscription = Modular.get<AppController>()
        .sincronizacaoStream
        .listen((value) {
      load();
    });
  }

  void dispose(){
    _debounceTimer?.cancel();
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

  @observable
  bool pesquisando = false;

  @observable
  String termoPesquisa = '';

  @action
  void addVisita(VisitaEntity visita) {
    visitas.add(visita);
  }

  @action
  void iniciarPesquisa() {
    pesquisando = true;
  }

  @action
  void encerrarPesquisa() {
    pesquisando = false;
    termoPesquisa = '';
  }

  @action
  void atualizarPesquisa(String termo) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300),(){
      termoPesquisa = termo;
    });
  }

  @observable
  FiltroData filtroData = FiltroData.hoje;

  @observable
  DateTime? dataInicio;

  @observable
  DateTime? dataFim;

  @action
  void aplicarFiltroData(FiltroData filtro, {DateTime? inicio, DateTime? fim}) {
    filtroData = filtro;
    dataInicio = inicio;
    dataFim = fim;
  }

  @action
  void limparFiltroData() {
    filtroData = FiltroData.hoje;
    dataInicio = null;
    dataFim = null;
  }


  @computed
  List<VisitaEntity> get visitasFiltradas {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month,agora.day);
    final ontem = hoje.subtract(const Duration(days: 1));

    // 1. filtra por data
    final filtradosPorData = visitas.where((v) {
      final diaVisita = DateTime(
        v.dataVisita.year,
        v.dataVisita.month,
        v.dataVisita.day,
      );

      switch (filtroData) {
        case FiltroData.hoje:
          return diaVisita == hoje;
        case FiltroData.ontem:
          return diaVisita == ontem;
        case FiltroData.personalisado:
          if (dataInicio == null || dataFim == null) return false;
          final inicio = DateTime(dataInicio!.year, dataInicio!.month, dataInicio!.day);
          final fim = DateTime(dataFim!.year, dataFim!.month, dataFim!.day);
          return !diaVisita.isBefore(inicio) && !diaVisita.isAfter(fim);
      }
    }).toList();

    if (termoPesquisa.isEmpty) return filtradosPorData;
    final termo = termoPesquisa.toLowerCase();
    return filtradosPorData.where((v) =>
    v.nomeEmpresa.toLowerCase().contains(termo) ||
        v.nomeContatoEmpresa.toLowerCase().contains(termo)
    ).toList();
  }

  @computed
  bool get filtroDataAtivo => filtroData != FiltroData.hoje;

  @action
  Future<void> desconectar() async {
    try {
      print('iniciando o logout');

      await _cache.remove(cacheUsuarioKey);

      Modular.to.navigate('/login');

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

          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = parts[1];

            final String normalizedPayload = base64Url.normalize(payload);

            final String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

            final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

            nomeUsuario = payloadMap['nome'] ?? 'Usuário';

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

      await carregarDadosUsuario();

      if (idUsuarioLogado.isNotEmpty) {
        final lista = await _service.getVisitasPorUsuario(idUsuarioLogado);
        visitas = ObservableList.of(lista);
      } else {
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

