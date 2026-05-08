import 'package:crm_app/app/modules/visita/identificar_empresa_id_controller.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/VisitaService.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_page.dart';
import 'package:crm_app/app/modules/visita/identificar_empresa_id_page.dart';

class VisitaModule extends Module {

  @override
  List<Module> get imports => [
    ApiModule(),
    CacheModule(),
  ];

  @override
  void exportedBinds (Injector i ) {
    //repositorio
    i.addLazySingleton<IVisitaRepository>(VisitaRepositoryLocal.new);
    //servico
    i.addLazySingleton<IVisitaService>(VisitaService.new);
    //analisar se esta no local certo
    i.addLazySingleton(IdentificarEmpresaIdController.new);
    //controller
    i.addLazySingleton(VisitaController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const VisitaPage());
    r.child('/identificarId', child: (context) => const IdentificarEmpresaIdPage());
  }
}