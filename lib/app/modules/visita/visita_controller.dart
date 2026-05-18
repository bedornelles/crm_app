import 'package:crm_app/app/modules/visita/services/localizacao_service_interface.dart';
import 'package:crm_app/app/modules/visita/store/visita_store.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';

part 'visita_controller.g.dart';

class VisitaController = _VisitaControllerBase with _$VisitaController;

abstract class _VisitaControllerBase with Store {

  final IVisitaService _visitaService;
  final ILocalizacaoService _localizacaoService;
  final ICache _cache;

  //construtor que vai pedir o repositorio para o modular
  _VisitaControllerBase(this._visitaService, this._localizacaoService, this._cache);

  @observable
  bool saving = false;

  //store da visita que esta sendo criada
  @observable
  VisitaStore visita = VisitaStoreFactory.novo('');

  //inicialuza o store com id do usuario logado
  //chama assim que a tela abre
  @action
  void init(String idUsuario) {
    visita = VisitaStoreFactory.novo(idUsuario);
  }

  @action
  Future<VisitaEntity?> salvar() async {
    if (saving) return null;
    saving = true;

    try {

      final localizacao = await _localizacaoService.obterLocalizacaoAtual();

      final entity = visita.toEntity();
      entity.localizacao = localizacao;

      await _visitaService.saveOrUpdate(entity);
      return entity;
    } finally {
      saving = false;
    }
  }

  @action
  Future<bool> deveExibirPermissaoLocalizacao() async {
    // busca no cache se já solicitou permissão antes
    final jaSolicitou = await _cache.getString(cachePermissaoLocalizacaoKey);

    if (jaSolicitou == null) {
      // primeira vez — registra no cache para não perguntar de novo
      await _cache.setString(cachePermissaoLocalizacaoKey, 'true');
      return true; // sinaliza para a página que deve abrir o modal
    }

    return false; // já perguntou antes, não exibe mais
  }

  @action
  Future<void> obterLocalizacao() async {
    await _localizacaoService.obterLocalizacaoAtual();
  }

}