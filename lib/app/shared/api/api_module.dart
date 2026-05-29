import 'package:crm_app/app/shared/api/crm_api.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';

import '../cache/cache_interface.dart';

class ApiModule extends Module {
  final ICache _cache;

  ApiModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
  ];

  @override
  void exportedBinds(Injector i) {
    i.add<ICrmApi>(CrmApi.new);
  }
}