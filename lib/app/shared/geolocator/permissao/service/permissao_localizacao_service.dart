import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:crm_app/app/shared/geolocator/permissao/service/permissao_localizacao_service_interface.dart';
import 'package:geolocator/geolocator.dart';

class PermissaoLocalizacaoService implements IPermissaoLocalizacaoService {
  final ICache _cache;

  PermissaoLocalizacaoService(this._cache);

  @override
  Future<bool> temPermissao() async {
    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) return false;

    final permissao = await Geolocator.checkPermission();
    return permissao == LocationPermission.always ||
        permissao == LocationPermission.whileInUse;
  }

  @override
  Future<void> solicitarPermissao() async {
    final permissao = await Geolocator.checkPermission();

    if(permissao == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    final novaPermissao = await Geolocator.requestPermission();
  }

  @override
  Future<bool> deveExibirModal() async {
    final temPermissaoAtual = await temPermissao();
    if (temPermissaoAtual) return false;

    await _cache.setString(cachePermissaoLocalizacaoKey, 'true');
    return true;
  }
}