import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';

abstract class ICache {
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
  UsuarioEntity? getUsuario(String key);
}