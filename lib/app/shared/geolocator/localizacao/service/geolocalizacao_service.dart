import 'package:geolocator/geolocator.dart';
import 'geolocalizacao_service_interface.dart';

class GeolocalizacaoService implements IGeolocalizacaoService {

  @override
  Future<String?> obterLocalizacaoAtual() async {
    try {
      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return '${posicao.latitude}, ${posicao.longitude}';
    } catch (e) {
      print('erro ao obter localização: $e');
      return null;
    }
  }
}