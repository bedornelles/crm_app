import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';

part 'visita_controller.g.dart';

class VisitaController extends _VisitaControllerBase with _$VisitaController {
  // Agora o Modular consegue "enxergar" que ele exige um VisitaRepository!
  VisitaController(IVisitaService service) : super(service);
}

abstract class _VisitaControllerBase with Store {
  //variavel para guardar o repositorio
  final IVisitaService _service;
  //construtor que vai pedir o repositorio para o modular
  _VisitaControllerBase(this._service);

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

  @action
  Future<void> salvarVisita(VisitaEntity novaVisita) async {
    try {
      //repositorio vai salvar no sqlite
      await _service.saveOrUpdate(novaVisita);
      //true para avisar que salvou no bd
      Modular.to.pop(novaVisita);
    } catch (e) {
      print("erro ao salvar: $e");
    }
  }
}