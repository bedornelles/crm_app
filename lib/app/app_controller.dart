import 'package:crm_app/app/modules/sincronizacao/sincronizacao_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppController implements Disposable{
  final SincronizacaoService _sincronizacaoService;

  AppController(this._sincronizacaoService);

  void startSincronizacao() {
    _sincronizacaoService.iniciar();
  }

  @override
  void dispose(){}

}