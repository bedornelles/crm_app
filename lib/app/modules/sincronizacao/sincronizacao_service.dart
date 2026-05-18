import 'dart:async';
import 'dart:ui';

import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SincronizacaoService implements Disposable {
  final IVisitaRepository _visitaRepository;
  final ICrmApi _api;
  final ICache _cache;
  VoidCallback? onSincronizacaoConcluida;

  Timer? _timer;
  bool _sincronizando = false;

  SincronizacaoService(this._visitaRepository, this._api, this._cache);

  //vai iniciar o polling quando abrir o app
  void iniciar() {
    //roda uma vez ao iniciar e depois de 30 em 30s
    _sincronizar();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
        (_) => _sincronizar(),
    );
  }


  //para o polling
  void parar() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _sincronizar() async {

    //se ja ta tondando ignora esse disparo do timer
    if (_sincronizando) return;
    _sincronizando = true;

    try {
      //so tenta sincronizar se tiver usuario logado
      final usuarioLogado = _cache.getUsuario(cacheUsuarioKey);
      if (usuarioLogado == null) return;

      //busca todas as visitas pendentes no banco local
      final pendentes = await _visitaRepository.getAllNaoSincronizadas();
      if (pendentes.isEmpty) return;

      //tenta enviar uma por uma para a API
      for (final visita in pendentes) {
        await _enviarVisita(visita);
      }
      onSincronizacaoConcluida?.call();
    } catch (e) {
      print ('erro na sincronização: $e');
    }
    finally {
      //libera mesmo se der erro
      _sincronizando = false;
    }
  }

  Future<void> _enviarVisita(VisitaEntity visita) async {
    try {
      final payload = _montarPayload(visita);
      print('DEBUG: Enviando visita da empresa: ${payload['nomeEmpresa']} | ID: ${payload['identificadorEmpresa']}');

      final res = await _api.post(uri: '/api/v1/visita', data: payload);

      if (res != null && res ['success'] == true) {
        //sucesso - atualiza o status no banco lcoal
        await _visitaRepository.marcarComoSincronizada(visita.base.id);
        print('Sincronização OK: ${res['message']}');

      }else{
        //erro da api success:false
        final erroMsg = res?['detail'] ?? res?['message'] ?? 'erro desconhecido na api';
        await _visitaRepository.marcarComoErro(visita.base.id, erroMsg);
      }

    } catch (e) {
      final erroMsg = 'Falha na comunicação: ${e.toString()}';
      await _visitaRepository.marcarComoErro(visita.base.id, erroMsg);
    }
  }
  Map<String, dynamic> _montarPayload(VisitaEntity visita) {
    final payload = <String, dynamic>{
      'dataVisita': visita.dataVisita.toIso8601String().split('T')[0],
      'nomeEmpresa': visita.nomeEmpresa,
      'nomeContatoEmpresa': visita.nomeContatoEmpresa,
      'emailEmpresa': visita.emailEmpresa,
      'cpfCnpjEmpresa': visita.cpfCnpjEmpresa?.replaceAll(
          RegExp(r'[^0-9]'), ''),
      'telefoneEmpresa': visita.telefoneEmpresa?.replaceAll(
          RegExp(r'[^0-9]'), ''),
      'sistemaAtual': visita.sistemaAtual,
      'valorPago': double.tryParse(
        visita.valorPago
            .replaceAll('R\$', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ) ?? 0.0,
      'interessado': visita.demonstrouInteresse,
      'observacao': visita.observacoes,
      'logradouroEmpresa': visita.logradouroEmpresa,
      'numeroEmpresa': visita.numeroEmpresa,
      'cidadeEmpresa': visita.cidadeEmpresa,
      'complementoEmpresa': visita.complementoEmpresa,
      'identificadorEmpresa': visita.identificadorEmpresa,
      'localizacao': visita.localizacao ?? '',
    };

    // remove campos nulos

    return payload;

  }

  // o Modular chama isso automaticamente quando o módulo é destruído
  @override
  void dispose() {
    parar();
  }

}