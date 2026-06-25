import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/identificar_empresa_id_controller.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:crm_app/app/modules/visita/visita_detalhe_page.dart';
import 'package:crm_app/app/shared/geolocator/geolocator_module.dart';
import 'package:crm_app/app/shared/router/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/visita/visita_page.dart';
import 'package:crm_app/app/modules/visita/identificar_empresa_id_page.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';

import '../../shared/cache/cache_interface.dart';

class VisitaModule extends Module {
  final ICache _cache;
  VisitaModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
    GeolocatorModule(_cache),
  ];

  @override
  void binds (Injector i ) {

    i.add<IVisitaRepository>(VisitaRepositoryLocal.new);
    i.add<IVisitaService>(VisitaService.new);
    i.add(IdentificarEmpresaIdController.new);
    i.add(VisitaController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const VisitaPage());
    r.child(visitaIdentificarIdRouter, child: (context) => const IdentificarEmpresaIdPage());
    r.child(visitaDetalheRouter, child: (context) => VisitaDetalhePage(
        visita: r.args.data as VisitaEntity,
    ));
  }
}
