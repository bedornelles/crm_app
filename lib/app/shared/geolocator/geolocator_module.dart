import 'package:crm_app/app/shared/geolocator/permissao/service/permissao_localizacao_service.dart';
import 'package:crm_app/app/shared/geolocator/permissao/service/permissao_localizacao_service_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/shared/cache/cache_module.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'localizacao/service/geolocalizacao_service.dart';
import 'localizacao/service/geolocalizacao_service_interface.dart';

class GeolocatorModule extends Module {
  final ICache _cache;

  GeolocatorModule(this._cache);

  @override
  List<Module> get imports => [
    CacheModule(_cache),
  ];

  @override
  void exportedBinds(Injector i) {
    i.add<IPermissaoLocalizacaoService>(PermissaoLocalizacaoService.new);
    i.add<IGeolocalizacaoService>(GeolocalizacaoService.new);
  }
}