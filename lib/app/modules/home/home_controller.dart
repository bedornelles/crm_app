import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @action
  Future <void> load() async {
    try {
      _loading = true;
      //simular a busca de dados por alguns segundos
      await Future.delayed(const Duration(seconds: 2));
    }finally{
      _loading = false;
    }
  }
}

