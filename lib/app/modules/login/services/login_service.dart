import 'package:crm_app/app/modules/login/services/login_service_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/modules/usuario/entity/usuario_entity.dart';

class LoginService implements ILoginService {

  @override
  bool isLogged() {
    // Para o teste, vamos fingir que o usuário não está logado
    // para forçar a tela de login a aparecer.
    return false;
  }

  @override
  Future<UsuarioEntity> login(String username, String password) async {
    // 1. Simula o tempo de resposta da internet (2 segundos de "loading")
    await Future.delayed(const Duration(seconds: 2));

    // 2. Regra mockada: Só aceita admin / 123
    if (username == 'admin' && password == '123') {

      // 3. Devolve um usuário fake usando aquele seu token real para não quebrar a decodificação!
      return UsuarioEntity(
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub21lIjoiU2Vsc28gUGFjaGVjbyIsImlkX3VzdWFyaW8iOiIwOGNhNjk1Yy04MjU0LTRhYmMtOTU0OC01ZGJjOWRiM2MwMjIiLCJyb2xlIjoiQ2VydmFudGVzQWRtaW4iLCJleHAiOjE3NzczMDQ1MzEsImlzcyI6IkNlcnZhbnRlcyBUZWNub2xvZ2lhIn0.1VoqEy5HsGMfUtJpqqUb8EiNqWnOPBC9vxIhH33Qsng",
        refreshToken: "token_falso_para_teste",
      );

    } else {
      // 4. Simula o erro da API caso erre a senha
      throw Exception('Usuário ou senha inválidos. (Dica: use admin e 123)');
    }
  }

  @override
  Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts) async {
    throw UnimplementedError('Não precisamos testar o refresh agora');
  }

  @override
  Future<void> logout() async {
    // Apenas simula o tempo de limpar o banco e sair
    await Future.delayed(const Duration(seconds: 1));
  }
}