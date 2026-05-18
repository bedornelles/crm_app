import 'package:geolocator/geolocator.dart';
import 'package:crm_app/app/modules/visita/services/localizacao_service_interface.dart';

class LocalizacaoService implements ILocalizacaoService {

  @override
  Future<String?> obterLocalizacaoAtual() async {
    try {
      //verfiica se o gps esta ativo
      final servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) return null;

      //verifica  estado da permissao
      LocationPermission permissao = await Geolocator.checkPermission();

      //se ainda nao pediu permissao, sera pedido agora
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        //Se o usuario negou, retorna null sem forçar
        if (permissao == LocationPermission.denied) return null;
      }
      //se usuario negou permanentemente dai nao aparece mais o popup
      if (permissao == LocationPermission.deniedForever) return null;
      //permissa concedida - busca a posição atual
      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, //utiliza o gps para uma precisao maior
        ),
      );

      //retorna como string para salvar no banco
      return '${posicao.latitude}, ${posicao.longitude}';
    } catch (e) {
      print ('erro ao obter a localização: $e');
      return null;
    }
  }

}