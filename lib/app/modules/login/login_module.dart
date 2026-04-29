import 'package:crm_app/app/modules/visita/visita_module.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/login/login_controller.dart';
import 'package:crm_app/app/modules/login/login_page.dart';
import 'package:crm_app/app/modules/login/services/login_service_interface.dart';
import 'package:crm_app/app/modules/login/services/login_service.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';


class LoginModule extends Module{

  @override
  List<Module> get imports => [
    CacheModule(),
    ApiModule(),
    VisitaModule(),
  ];

  @override
  void binds (Injector i) {
    i.addLazySingleton<ILoginService>(LoginService.new);
    i.addLazySingleton(LoginController.new);
  }
  @override
  void routes(RouteManager r) {
    // Qnd entrar no LoginModule, mostra a LoginPage
    r.child('/', child: (context) => const LoginPage());
  }
}