import 'package:crm_app/app/modules/login/services/login_service_interface.dart';
import 'package:crm_app/app/shared/router/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashController {
  final ILoginService _loginService;

  SplashController(this._loginService);

  Future<void> load() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_loginService.isLogged()) {
      Modular.to.navigate(homeRouter);
    } else {
      Modular.to.navigate(loginRouter);
    }
  }
}