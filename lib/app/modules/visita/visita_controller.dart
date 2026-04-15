import 'package:mobx/mobx.dart';

part 'visita_controller.g.dart';

class VisitaController = _VisitaControllerBase with _$VisitaController;

abstract class _VisitaControllerBase with Store {

  //btn demonstrou interesse
  @observable
    bool? demonstrouInteresse;
  //calendário data da vista
  @observable
  DateTime dataDaVisita = DateTime.now();

  //btn demonstrou interesse
  @action
  void setDemonstrouInteresse(bool valor) {
    demonstrouInteresse = valor;
  }
  //calendário data da vista
  @action
  void setDataDaVisita(DateTime valor) {
    dataDaVisita = valor;
  }
}