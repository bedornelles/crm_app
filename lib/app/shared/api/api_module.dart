import 'package:crm_app/app/shared/api/crm_api.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';

class ApiModule extends Module {

  @override
  List<Module> get imports => [
    CacheModule(),
  ];

  @override
  void exportedBinds(Injector i) {
    i.add<ICrmApi>(CrmApi.new);
  }
}