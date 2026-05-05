import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';

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

  @action
  Future <void> load() async {
    try {
      _loading = true;
      final lista = await _service.getAll();
      visitas = ObservableList.of(lista);
    }finally{
      _loading = false;
    }
  }

  @action
  void addVisita(VisitaEntity visita) {
    visitas.add(visita);
  }
}

