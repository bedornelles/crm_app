import '../../usuario/entity/usuario_entity.dart';

//Interface que define as operações de autenticação e gerenciamento de sessão do usuário.
//
// // Deve ser implementada por serviços de autenticação para login, logout, criação de conta e renovação de token.


abstract class ILoginService {
  //Realiza login do usuario
  //Envia as credenciais para a API e devolve a entidade do usuário com os tokens.
  Future<UsuarioEntity> login(String username, String password);

  //renova o token de autenticaçao do usuario
  //Usa o token de renovação para pegar um novo token de acesso na API.
  Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts);

  //realiza logout do usuario
  Future<void> logout();

  //verifica se esxte usuario logado
  bool isLogged();

}