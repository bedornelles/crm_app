import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';

class CacheModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<ICache>(Cache.new);
  }
}