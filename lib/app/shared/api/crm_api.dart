
import 'package:crm_app/app/shared/cache/cache.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/login/services/login_service_interface.dart';
import 'crm_api_interface.dart';
import 'package:crm_app/app/shared/api/urls.dart';

typedef JsonMap = Map<String, dynamic>;

class CrmApi implements ICrmApi{

  //o app vai tentar renovar o token no maximo 3 vzs seguidas se der erro
  static const int _maxTokenRefreshAttempts = 3;

  //pega a variavel do urls.dart com o caminho da api
  static String get _baseUrl => '$crmApiUrl';

  //pede para o modular entregar a ferramenta do cache SharedPreferences
  final ICache _cache = Modular.get<ICache>();

  //configura a ferramneta dio que faz as requisições http.
  //toda vex que for fazer uma chamada o get busca o token mais atualizado do cache
  Dio get _dio {
    //busca o usuario salvo no celular e pega o token dele se houver
    final token = _cache.getUsuario(cacheUsuarioKey)?.token;

    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        //setado limite de 18 segundos para conectar/enviar/receber
        connectTimeout: const Duration(seconds: 18),
        sendTimeout: const Duration(seconds: 18),
        receiveTimeout: const Duration(seconds: 18),

        //info escondidas que sao enviadas junto da requisição
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          //se o usuario estiver logado avisa api para autroizar
          if (token != null) 'Authorization': 'Bearer $token',
         }
      )
    );
  }

  ///metodo usado para buscar lista de visitas
  @override
  Future<List<JsonMap>> getAll({
    required String uri,
    Map<String, dynamic>? queryParameters,
    int refreshAttempts = 0,
  }) async {
    // Passa a ação para o metodo _request, que vai empacotar isso com tratamento de erros.
    return _request<List<JsonMap>>(
          () async {
        final response = await _dio.get(uri, queryParameters: queryParameters);
        // Pega a resposta do servidor e transforma numa Lista de Mapas que o Flutter entende.
        return List<JsonMap>.from(response.data);
      },
      refreshAttempts,
    );
  }

  ///metodo para fazer login ou criar uma visita nova
  @override
  Future<JsonMap?> post({
    required String uri,
    required JsonMap data, // Os dados que você quer salvar (ex: email e senha)
    int refreshAttempts = 0,
  }) async {
    return _request<JsonMap?>(
          () async {
        final response = await _dio.post(uri, data: data);
        // Transforma a resposta do servidor de volta num Mapa.
        return JsonMap.from(response.data);
      },
      refreshAttempts,
    );
  }


  //tod o get e post passam por aqui
  //ele tenta executar a ação, se der erro ele analisa o que houve
  Future<T> _request<T>(
      Future<T> Function() action, // A ação que queremos fazer (o get ou o post)
      int refreshAttempts,
      ) async {
    try {
      // Tenta fazer a requisição de fato...
      return await action();
    } on DioException catch (e) {
      // Opa, deu um erro de rede! Vamos ver se é problema de Token vencido.
      if (_isTokenExpirado(e)) {

        // Se já tentou renovar menos de 3 vezes, tenta de novo.
        if (refreshAttempts < _maxTokenRefreshAttempts) {
          await _tokenExpirado(refreshAttempts); // Chama a função que renova o token
          return _request(action, refreshAttempts + 1); // Tenta fazer o get/post original de novo!
        }

        // Se já tentou 3 vezes e não conseguiu renovar, desiste e desloga o usuário.
        await _logout();
        throw Exception('Sessão expirada, faça login novamente.');
      }

      // Se não for erro de token vencido (ex: senha errada, servidor fora do ar, sem internet),
      // manda para a função que traduz o erro.
      await _tratarErro(e);
      rethrow; // Repassa o erro traduzido para a tela mostrar ao usuário.
    } catch (e) {
      throw Exception('Erro inesperado: $e'); // Qualquer erro bizarro que não seja do Dio cai aqui.
    }
  }

  // Traduz os erros técnicos do servidor para mensagens amigáveis em português.
  Future<void> _tratarErro(DioException e) async {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw Exception('Tempo de conexão excedido. Verifique sua internet.');
      case DioExceptionType.cancel:
        throw Exception('Requisição cancelada.');
      case DioExceptionType.badResponse:
      // O servidor devolveu um erro intencional (ex: 400 Bad Request, 404 Not Found)
        final data = e.response?.data;
        final statusCode = e.response?.statusCode;

        // Tenta ler a mensagem de erro que o backend mandou no corpo da resposta
        if (data is JsonMap) {
          final title = data['title'] ?? data['message'] ?? 'Erro na requisição';
          final errors = data['errors'];
          String detail = '';

          // Se a API mandou uma lista de erros detalhados, junta tudo numa string só.
          if (errors is JsonMap && errors['messages'] is List) {
            detail = (errors['messages'] as List).join(', ');
          }
          throw Exception('$title${detail.isNotEmpty ? '\n$detail' : ''}');
        }
        // Se a API não mandou uma mensagem amigável, mostra o código (ex: Erro HTTP 500)
        throw Exception('Erro HTTP $statusCode: ${e.response?.statusMessage}');
      case DioExceptionType.unknown:
        throw Exception('Erro desconhecido: ${e.message}');
      default:
        throw Exception(e.message ?? 'Erro inesperado.');
    }
  }

  // Função chamada quando a API avisa que o token atual venceu.
  Future<void> _tokenExpirado(int refreshAttempts) async {
    try {
      // Pega a "senha de emergência" (refreshToken) salva no cache.
      final refreshToken = _cache.getUsuario(cacheUsuarioKey)?.refreshToken ?? '';

      // Pede para o LoginService ir na API trocar esse refreshToken por um Token novo.
      await Modular.get<ILoginService>().refreshToken(refreshToken, refreshAttempts + 1);
    } catch (e, s) {
      debugPrint('Erro ao renovar token: $e\n$s');
    }
  }

  // Verifica se o erro foi de Autorização (Status 401 - Não Autorizado)
  // E se o usuário tem um refreshToken guardado para tentarmos salvá-lo.
  bool _isTokenExpirado(DioException e) {
    return e.response?.statusCode == 401 && _cache.getUsuario(cacheUsuarioKey)?.refreshToken != null;
  }

  // Função de emergência: limpa tudo e joga o usuário para a tela de login.
  Future<void> _logout() async {
    await Modular.get<ILoginService>().logout(); // Limpa banco de dados e cache
    Modular.to.navigate('/login'); // Navega para fora do app
  }
}