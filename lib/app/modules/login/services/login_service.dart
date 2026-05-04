import 'dart:convert';

import 'package:crm_app/app/modules/login/services/login_service_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';

import '../../../shared/api/crm_api_interface.dart';
import '../../../shared/cache/cache.dart';
import '../../../shared/cache/cache_interface.dart';

class LoginService implements ILoginService {

  final ICache _cache;
  final ICrmApi _api;
  final IVisitaService _visitaService;

  LoginService(this._cache, this._api, this._visitaService);

  // Verifica se existe usuário logado no cache.
  @override
  bool isLogged() {
    return _cache.getString(cacheUsuarioKey) != null;
  }

  //realiza o login do usuario
  @override
  Future<UsuarioEntity> login(String username, String password) async {
    //chama a API e ve se as credenciais estao certas
    final response = await _api.post(uri: '/auth/login', data: {
      'login': username,
      'senha': password,
    });
    if (response == null) {
      throw Exception('Erro ao fazer login no servidor');
    }
    //após sucesso no login limpa o banco local
    await _visitaService.limparTabelaDoBancoLocal();
    print('Limpando visitas antigas para o novo login');

    //baixa visitas e guarda no banco local
    await _visitaService.buscarVisitasDaApiESalvarLocal();

    final usuario = UsuarioEntity.fromJson(response);

    // Salva o usuário (com o token) no cache local para não precisar logar de novo
    await _cache.setString(cacheUsuarioKey, jsonEncode(response));

    return usuario;
  }

  //Renva o token de autenticaçao do usuario
  @override
  Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts) async {
    final response = await _api.post(
      uri: '/auth/refresh',
      data: {
              'refreshToken': refreshToken,
      },
      refreshAttempts: refreshAttempts
    );

    if (response == null) {
      throw Exception('Erro ao atualizar token');
    }

    final usuario = UsuarioEntity.fromJson(response);

    await _cache.setString(cacheUsuarioKey, jsonEncode(response));

    return usuario;
  }

  @override
  Future<void> logout() async {
    // limpa o token do cache
    await _cache.remove(cacheUsuarioKey);
    //limpa o banco de dados de visitas
    await _visitaService.limparTabelaDoBancoLocal();
  }

}