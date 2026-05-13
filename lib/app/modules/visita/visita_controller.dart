import 'package:crm_app/app/modules/visita/store/visita_store.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';

part 'visita_controller.g.dart';

class VisitaController = _VisitaControllerBase with _$VisitaController;

abstract class _VisitaControllerBase with Store {
  //variavel para guardar o repositorio
  final IVisitaService _visitaService;
  //construtor que vai pedir o repositorio para o modular
  _VisitaControllerBase(this._visitaService);

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
      final entity = visita.toEntity();
      await _visitaService.saveOrUpdate(entity);
      return entity;
    } finally {
      saving = false;
    }
  }
}