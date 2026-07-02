import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/login/services/login_service_interface.dart';

import '../../shared/router/routes.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final ILoginService _loginService;

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @observable
  bool _mostrarSenha = false;

  @computed
  bool get mostrarSenha => _mostrarSenha;

  _LoginControllerBase(this._loginService);

  @action
  void alterarMostrarSenha() {
    _mostrarSenha = !_mostrarSenha;
  }

  @action
  Future<void> login(String username, String password) async {
    try {
      _loading = true;
      await _loginService.login(username, password);
      Modular.to.navigate(homeRouter);
    } finally {
      _loading = false;
    }
  }

  @action
  Future<void> logout() async {
    await _loginService.logout();
    Modular.to.navigate(loginRouter);
  }
}