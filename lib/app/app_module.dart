import 'package:crm_app/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/visita/repositories/visita_repository.dart';
import 'modules/visita/repositories/visita_repository_interface.dart';
import 'modules/visita/visita_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i){
    i.addLazySingleton<IVisitaRepository>(VisitaRepositoryLocal.new);
  }
  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.module('/visita', module: VisitaModule());
  }
}