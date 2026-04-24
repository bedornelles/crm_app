import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/home_page.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/visita/services/VisitaService.dart';


class HomeModule extends Module{
  @override
  void binds(Injector i) {
    i.addLazySingleton<IVisitaRepository>(VisitaRepositoryLocal.new);

    i.addLazySingleton<IVisitaService>(VisitaService.new); //alteracao da ia

    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}