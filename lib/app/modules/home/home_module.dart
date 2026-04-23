import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/home_page.dart';
import 'package:crm_app/app/shared/repositories/visita_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module{
  @override
  void binds(Injector i) {
    i.addLazySingleton(VisitaRepository.new);
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}