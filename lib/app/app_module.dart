import 'package:crm_app/app/modules/home/home_module.dart';
import 'package:crm_app/app/modules/login/login_module.dart';
import 'package:crm_app/app/modules/sincronizacao/sincronizacao_module.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/visita/visita_module.dart';
import 'package:crm_app/app/app_controller.dart';

class AppModule extends Module {
  final ICache _cache;

  AppModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
    ApiModule(_cache),
    SincronizacaoModule(_cache),
  ];


  @override
  void binds(Injector i){
    i.addSingleton(AppController.new);
  }
  @override
  void routes(RouteManager r) {
    r.module('/', module: LoginModule(_cache));
    r.module('/home', module: HomeModule(_cache));
    r.module('/visita', module: VisitaModule(_cache));
  }
}