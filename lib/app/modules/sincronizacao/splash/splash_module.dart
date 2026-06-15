import 'package:crm_app/app/modules/login/login_module.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_controller.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_page.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:path/path.dart';

class SplashModule extends Module {
  final ICache _cache;

  SplashModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
    ApiModule(_cache),
    LoginModule(_cache)
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