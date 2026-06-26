import 'package:crm_app/app/modules/login/login_module.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_controller.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_page.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends Module {

  @override
  List<Module> get imports => [
    CacheModule(),
    ApiModule(),
    LoginModule(),
  ];

  @override
  void binds(Injector i) {
    i.add(SplashController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
  }
}