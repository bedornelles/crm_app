
import 'dart:convert';

import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/login/services/login_service_interface.dart';
import '../../modules/usuario/entity/usuario_entity.dart';
import 'crm_api_interface.dart';
import 'package:crm_app/app/shared/api/urls.dart';

typedef JsonMap = Map<String, dynamic>;

class CrmApi implements ICrmApi{

  static const int _maxTokenRefreshAttempts = 3;
  static String get _baseUrl => '$crmApiUrl';

  final ICache _cache;

  CrmApi(this._cache);

  //Dio faz as requisicoes http
  Dio get _dio {
    //busca o usuario salvo no celular e pega o token dele se houver
    final token = _cache.getUsuario(cacheUsuarioKey)?.token;

    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 18),
        sendTimeout: const Duration(seconds: 18),
        receiveTimeout: const Duration(seconds: 18),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          //se o usuario estiver logado avisa api para autroizar
          if (token != null) 'Authorization': 'Bearer $token',
         }
      )
    );
  }

  ///metodo para fazer login ou criar uma visita nova
  @override
  Future<JsonMap?> post({
    required String uri,
    required JsonMap data,
    int refreshAttempts = 0,
  }) async {
    return _request<JsonMap?>(() async {
      final response = await _dio.post(uri, data: data);
      print('DEBUG API: Tipo real da resposta -> ${response.data.runtimeType}');
      print('DEBUG API: Conteúdo real da resposta -> ${response.data}');

      if (response.data == null) return null;

      if (response.data is Map) {
        return JsonMap.from(response.data);
      } else {
        print('Aviso: A API não retornou um Map. Retornando objeto vazio.');
        return {};
      }
    },
      refreshAttempts,
    );
  }

  //tod o get e post passam por aqui
  //ele tenta executar a ação, se der erro ele analisa o que houve
  Future<T> _request<T>(
      Future<T> Function() action,
      int refreshAttempts,
      ) async {
    try {
      return await action();
    } on DioException catch (e) {
      if (_isTokenExpirado(e)) {
        print('Token expirado, tentativa $refreshAttempts de $_maxTokenRefreshAttempts');
        if (refreshAttempts < _maxTokenRefreshAttempts) {
          await _tokenExpirado(refreshAttempts);
          return _request(action, refreshAttempts + 1);
        }

        await _logout();
        throw Exception('Sessão expirada, faça login novamente.');
      }

      await _tratarErro(e);
      rethrow;
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> _tratarErro(DioException e) async {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw Exception('Tempo de conexão excedido');
      case DioExceptionType.cancel:
        throw Exception('Requisição cancelada.');
      case DioExceptionType.badResponse:

        final data = e.response?.data;
        final statusCode = e.response?.statusCode;

        if (data is JsonMap) {
          final title = data['title'] ?? data['message'] ?? 'Erro na requisição';
          final errors = data['errors'];
          String detail = '';

          if (errors is JsonMap && errors['messages'] is List) {
            detail = (errors['messages'] as List).join(', ');
          }
          throw Exception('$title${detail.isNotEmpty ? '\n$detail' : ''}');
        }
        throw Exception('Erro HTTP $statusCode: ${e.response?.statusMessage}');
      case DioExceptionType.unknown:
        throw Exception('Erro desconhecido: ${e.message} | tipo: ${e.type} | erro: ${e.error} | response: ${e.response}');
      default:
        throw Exception('Default: ${e.message} | tipo: ${e.type} | erro: ${e.error}');
    }
  }

  Future<void> _tokenExpirado(int refreshAttempts) async {
    try {
      print('Tentando renovar token...');
      final refreshToken = _cache.getUsuario(cacheUsuarioKey)?.refreshToken ?? '';

      final dio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 18),
        sendTimeout: const Duration(seconds: 18),
        receiveTimeout: const Duration(seconds: 18),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await dio.post(
        '/api/v1/usuario/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.data != null) {
        final usuario = UsuarioEntity.fromJson(Map<String, dynamic>.from(response.data));
        await _cache.setString(cacheUsuarioKey, jsonEncode(usuario.toJson()));
        print('Token renovado com sucesso');
      }
    } catch (e, s) {
      debugPrint('Erro ao renovar token: $e\n$s');
    }
  }

  bool _isTokenExpirado(DioException e) {
    return e.response?.statusCode == 401 && _cache.getUsuario(cacheUsuarioKey)?.refreshToken != null;
  }

  Future<void> _logout() async {
    await _cache.remove(cacheUsuarioKey);
    Modular.to.navigate('/login');
  }
}