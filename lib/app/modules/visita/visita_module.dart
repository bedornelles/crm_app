import 'package:crm_app/app/modules/visita/identificar_empresa_id_controller.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/localizacao_service.dart';
import 'package:crm_app/app/modules/visita/services/localizacao_service_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_page.dart';
import 'package:crm_app/app/modules/visita/identificar_empresa_id_page.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';

class VisitaModule extends Module {

  @override
  List<Module> get imports => [
    CacheModule(),
  ];

  @override
  void binds (Injector i ) {

    i.add<IVisitaRepository>(VisitaRepositoryLocal.new);

    i.add<IVisitaService>(VisitaService.new);

    i.add<ILocalizacaoService>(LocalizacaoService.new);

    i.add(IdentificarEmpresaIdController.new);

    i.add(VisitaController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const VisitaPage());
    r.child('/identificarId', child: (context) => const IdentificarEmpresaIdPage());
  }
}