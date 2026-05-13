import 'package:crm_app/app/modules/sincronizacao/sincronizacao_service.dart';
import 'package:crm_app/app/modules/visita/visita_module.dart';
import 'package:crm_app/app/shared/api/api_module.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SincronizacaoModule extends Module{
  @override
  List<Module> get imports => [
    ApiModule(),
    CacheModule(),
    VisitaModule(),
  ];

  @override
  void binds(Injector i) {
    i.addSingleton(SincronizacaoService.new);
  }
}