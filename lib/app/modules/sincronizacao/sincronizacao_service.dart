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

  void iniciar() {
    _sincronizar();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
        (_) => _sincronizar(),
    );
  }

  void parar() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _sincronizar() async {

    if (_sincronizando) return;
    _sincronizando = true;

    try {
      final usuarioLogado = _cache.getUsuario(cacheUsuarioKey);
      if (usuarioLogado == null) return;


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
      _sincronizando = false;
    }
  }

  final Map<String, int> _tentativas = {};

  Future<void> _enviarVisita(VisitaEntity visita) async {
    try {
      final payload = _montarPayload(visita);
      print('Enviando visita: ${payload['nomeEmpresa']}');

      final res = await _api.post(uri: '/api/v1/visita', data: payload);
      print('Resposta recebida: $res');

      if (res != null && res ['success'] == true) {
        await _visitaRepository.marcarComoSincronizada(visita.base.id);
        print('Sincronização OK: ${res['message']}');

      }else{
        final erroMsg = res?['detail'] ?? res?['message'] ?? 'erro desconhecido na api';
        print('Erro da API: $erroMsg');
        await _visitaRepository.marcarComoErro(visita.base.id, erroMsg);
      }

    } catch (e) {
      final erroMsg = 'Não foi possivel estabelecer a conexão com o servidor no momento.';

      _tentativas[visita.base.id] = (_tentativas[visita.base.id] ?? 0) +1;
      if(_tentativas[visita.base.id]! >= 3) {
        await _visitaRepository.marcarComoFalhou(visita.base.id, erroMsg);
        _tentativas.remove(visita.base.id);
      } else {
        await _visitaRepository.marcarComoErro(visita.base.id, erroMsg);
      }
    }
  }

  Future<void> sincronizarVisita(VisitaEntity visita) async {
    try {
      await _enviarVisita(visita);
      onSincronizacaoConcluida?.call();
    } catch (e) {
      print('erro ao sincronizar visita: $e');
    }
  }

  Future<void> sincronizarAgora() async {
    await _sincronizar();
  }
  Future<void> tentarNovamente(String idVisita) async {
    await _visitaRepository.resetarParaPendente(idVisita);
    _tentativas.remove(idVisita);
    await _sincronizar();
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
      'valorPago': visita.valorPago == null ||visita.valorPago!.trim().isEmpty
        ?null
        : double.tryParse(
            visita.valorPago!
              .replaceAll('R\$', '')
              .replaceAll('.', '')
              .replaceAll(',', '.')
              .trim(),
        ),
      'interessado': visita.demonstrouInteresse,
      'observacao': visita.observacoes,
      'logradouroEmpresa': visita.logradouroEmpresa,
      'numeroEmpresa': visita.numeroEmpresa,
      'cidadeEmpresa': visita.cidadeEmpresa,
      'complementoEmpresa': visita.complementoEmpresa,
      'identificadorEmpresa': visita.identificadorEmpresa,
      'localizacao': visita.localizacao ?? '',
    };

    return payload;

  }

  @override
  void dispose() {
    parar();
  }

}