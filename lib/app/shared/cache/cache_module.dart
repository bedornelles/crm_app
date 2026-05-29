import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';

class CacheModule extends Module {
  final ICache _cache;

  CacheModule(this._cache);

  @override
  void exportedBinds(Injector i) {
    i.addInstance<ICache>(_cache);
  }
}