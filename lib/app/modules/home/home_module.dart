import 'package:crm_app/app/app_module.dart';
import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/home_page.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_module.dart';

import '../../shared/cache/cache_interface.dart';


class HomeModule extends Module{
  final ICache _cache;
  HomeModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
    VisitaModule(_cache),
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