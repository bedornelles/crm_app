import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

import '../../shared/repositories/visita_repository.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final VisitaRepository _repository;

  _HomeControllerBase(this._repository);

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
      final lista = await _repository.buscarVisitas();
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

