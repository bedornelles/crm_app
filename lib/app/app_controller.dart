import 'dart:async';

import 'package:crm_app/app/modules/sincronizacao/sincronizacao_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppController implements Disposable{
  final SincronizacaoService _sincronizacaoService;

  //
  final _sincronizacaoStreamController = StreamController<void>.broadcast();
  Stream<void> get sincronizacaoStream => _sincronizacaoStreamController.stream;

  AppController(this._sincronizacaoService);

  void startSincronizacao() {
    _sincronizacaoService.onSincronizacaoConcluida = () {
      _sincronizacaoStreamController.add(null);
    };
      _sincronizacaoService.iniciar();
  }

  @override
  void dispose(){
    _sincronizacaoStreamController.close();
  }

}