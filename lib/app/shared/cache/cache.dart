import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';
import 'package:crm_app/app/shared/cache/cache_interface.dart';

// Classe responsável por gerenciar o cache local da aplicação utilizando SharedPreferences.
//
// Permite salvar, recuperar e remover dados simples em formato chave-valor.
// Também oferece métodos específicos para manipular o usuário logado.
class Cache implements ICache {
  late SharedPreferences _prefs;

  Cache() {
    SharedPreferences.getInstance().then((prefs){
      _prefs = prefs;
    });
  }

  // Salva uma string no cache com a chave fornecida.
  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Recupera uma string do cache pela chave.
  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Remove um item do cache pela chave.
  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Limpa todos os dados do cache.
  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  // Recupera um objeto [UsuarioEntity] do cache pela chave.
  //
  // Retorna null caso não exista um usuário salvo.
  @override
  UsuarioEntity? getUsuario(String key) {
    final String? userData = _prefs.getString(key);
    if (userData != null) {
      return UsuarioEntity.fromJson(jsonDecode(userData));
    }
    return null;
  }
}

// Chave padrão utilizada para armazenar o usuário logado no cache.
const String cacheUsuarioKey = 'usuario';

// permissao de localizacao
const String cachePermissaoLocalizacaoKey = 'permissao_localizacao_solicitada';