import 'dart:convert';

class JwtUtils {
  Map<String, dynamic> decodeJwt(String token) {
    // 1 - O JWT é dividido em 3 partes separadas por pontos: Header, Payload e Signature.
    final parts = token.split('.');

    // 2 - Verifica se o token tem as 3 partes para garantir que nao esta corrompido
    if (parts.length != 3) {
      throw Exception('Token inválido');
    }

    // 3 - pega a parte do meio (indice 1) que contem os dados do usuario (id, nome...)
    final payload = parts [1];

    // 4 - normaliza o Base64 para o dar ler corretamente
    final normalized = base64Url.normalize(payload);

    // 5 - Decodifica de Base64 para bytes e depois para uma String legível (JSON)
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);

    // 6 - Transaforma a String JSON em um mapa do dart
    return jsonDecode(payloadString);
  }
}