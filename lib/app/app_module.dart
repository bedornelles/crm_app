import 'package:crm_app/app/modules/home/home_module.dart';
import 'package:crm_app/app/modules/login/login_module.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/visita/repositories/visita_repository.dart';
import 'modules/visita/repositories/visita_repository_interface.dart';
import 'modules/visita/visita_module.dart';

class AppModule extends Module {

  @override
  List<Module> get imports => [ CacheModule(), ApiModule()];

  @override
  void binds(Injector i){
    i.addLazySingleton<IVisitaRepository>(VisitaRepositoryLocal.new);
  }
  @override
  void routes(RouteManager r) {
    r.module('/', module: LoginModule());
    r.module('/home', module: HomeModule());
    r.module('/visita', module: VisitaModule());
  }
}