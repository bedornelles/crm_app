import 'dart:convert';

import 'package:crm_app/app/modules/login/services/login_service_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';

import 'package:crm_app/app/shared/api/crm_api_interface.dart';
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';

class LoginService implements ILoginService {

  final ICache _cache;
  final ICrmApi _api;

  LoginService(this._cache, this._api);

  // Verifica se existe usuário logado no cache.
  @override
  bool isLogged() {
    return _cache.getString(cacheUsuarioKey) != null;
  }

  //realiza o login do usuario
  @override
  Future<UsuarioEntity> login(String username, String password) async {
    //chama a API e ve se as credenciais estao certas
    final response = await _api.post(uri: '/api/v1/usuario/login', data: {
      'login': username,
      'senha': password,
    });
    if (response == null) {
      throw Exception('Erro ao fazer login no servidor');
    }
    //após sucesso no login limpa o banco local

    final usuario = UsuarioEntity.fromJson(response);
    // Salva o usuário (com o token) no cache local para não precisar logar de novo
    await _cache.setString(cacheUsuarioKey, jsonEncode(usuario.toJson()));

    // baixa visitas e guarda no banco local
    // await _visitaService.buscarVisitasDaApiESalvarLocal();

    return usuario;
  }

  //Renva o token de autenticaçao do usuario
  @override
  Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts) async {
    final response = await _api.post(
      uri: '/api/v1/usuario/refresh',
      data: {'refreshToken': refreshToken},
      refreshAttempts: refreshAttempts
    );

    if (response == null) {
      throw Exception('Erro ao atualizar token');
    }

    final usuario = UsuarioEntity.fromJson(response);

    await _cache.setString(cacheUsuarioKey, jsonEncode(usuario.toJson()));

    return usuario;
  }

  @override
  Future<void> logout() async {
    // limpa o token do cache
    await _cache.remove(cacheUsuarioKey);
  }

}