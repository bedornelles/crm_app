import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/home_page.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_module.dart';



class HomeModule extends Module{
  @override
  List<Module> get imports => [
    CacheModule(),
    VisitaModule(),
  ];

  @override
  void binds(Injector i) {
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}