import 'package:crm_app/app/modules/home/home_module.dart';
import 'package:crm_app/app/modules/login/login_module.dart';
import 'package:crm_app/app/modules/sincronizacao/sincronizacao_module.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_module.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:crm_app/app/shared/router/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/visita/visita_module.dart';
import 'package:crm_app/app/app_controller.dart';

class AppModule extends Module {

  @override
  List<Module> get imports => [
    CacheModule(),
    ApiModule(),
    SincronizacaoModule(),
  ];


  @override
  void binds(Injector i){
    i.addSingleton(AppController.new);
  }
  @override
  void routes(RouteManager r) {
    r.module(splashRouter, module: SplashModule());
    r.module(loginRouter, module: LoginModule());
    r.module(homeRouter, module: HomeModule());
    r.module(visitaRouter, module: VisitaModule());
  }
}