import 'dart:convert';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';

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
      // await _service.saveOrUpdate(novaVisita);
      await _service.salvarEEnviar(novaVisita);

      //true para avisar que salvou no bd
      Modular.to.pop(novaVisita);
    } catch (e) {
      print("erro ao salvar: $e");
    }
  }

  @action
  Future<String> getIdUsuarioLogado() async {
    // Supondo que você tenha o ICache injetado ou consiga pegar via Modular
    final cache = Modular.get<ICache>();
    final userJson = await cache.getString(cacheUsuarioKey);

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      // Extrai do mesmo jeito que fizemos na Home
      final parts = userMap['accessToken'].toString().split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final String normalizedPayload = base64Url.normalize(payload);
        final String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
        final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

        return payloadMap['id_usuario'] ?? '';
      }
    }
    return '';
  }
}