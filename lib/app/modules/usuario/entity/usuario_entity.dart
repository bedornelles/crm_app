import 'package:crm_app/app/shared/utils/jwt/jwt_utils.dart';

class UsuarioEntity {
  String token;
  String refreshToken;

  String get nome {
    final payload = JwtUtils().decodeJwt(token);
    return payload['nome'];
  }

  String get id {
    final payload = JwtUtils().decodeJwt(token);
    return payload['id_usuario'];
  }

  UsuarioEntity({
    required this.token,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'accessToken': token,
    'refreshToken': refreshToken,
  };

  //TRADUTOR
  //transforma o mapa de dados que vem da API nessa classe
  factory UsuarioEntity.fromJson(Map<String, dynamic> json) {
    return UsuarioEntity(
      token: json['accessToken'], // Nome do campo que vem da API
      refreshToken: json['refreshToken'],
    );
  }

}