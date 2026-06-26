import 'package:crm_app/app/modules/visita/store/visita_store.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/geolocator/localizacao/service/geolocalizacao_service_interface.dart';
import 'package:crm_app/app/shared/geolocator/permissao/service/permissao_localizacao_service_interface.dart';

part 'visita_controller.g.dart';

class VisitaController = _VisitaControllerBase with _$VisitaController;

abstract class _VisitaControllerBase with Store {

  final IVisitaService _visitaService;
  final IGeolocalizacaoService _geolocalizacaoService;
  final IPermissaoLocalizacaoService _permissaoLocalizacaoService;

  //construtor que vai pedir o repositorio para o modular
  _VisitaControllerBase(
      this._visitaService,
      this._geolocalizacaoService,
      this._permissaoLocalizacaoService,
      );

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
      print('1. iniciando - ${DateTime.now()}');
      final localizacao = await _geolocalizacaoService.obterLocalizacaoAtual();
      print('2. localizacao obtida - ${DateTime.now()}');
      final entity = visita.toEntity();
      entity.localizacao = localizacao;

      await _visitaService.saveOrUpdate(entity);
      print('3. salvo no banco - ${DateTime.now()}');

      return entity;
    } finally {
      saving = false;
    }
  }

  @action
  Future<bool> deveExibirPermissaoLocalizacao() async {
    return await _permissaoLocalizacaoService.deveExibirModal();
  }

  @action
  Future<void> obterLocalizacao() async {
    await _permissaoLocalizacaoService.solicitarPermissao();
  }

  Future<List<String>> getEnderecos(String logradouro) async {
    return await _visitaService.getEnderecos(logradouro);
  }

  Future<List<String>> getCidades(String cidade) async {
    return await _visitaService.getCidades(cidade);
  }

  Future<String> getLastCidade() async {
    return await _visitaService.getLastCidade();
  }
}