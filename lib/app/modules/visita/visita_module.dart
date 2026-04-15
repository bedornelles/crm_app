import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_page.dart';

class VisitaModule extends Module {

  @override
  void binds (Injector i ) {
    i.addLazySingleton(VisitaController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const VisitaPage());
  }
}