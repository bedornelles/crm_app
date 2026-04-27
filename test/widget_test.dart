// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crm_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}



//login_service.dart
// import 'dart:convert';
//
// import 'package:crm_app/app/modules/login/login_service_interface.dart';
// import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
//
// class LoginService implements ILoginService {
//   final IVisitaService _visitaService;
//
//   //construtor -> modular vai entregar as dependecias que o service precisa
//   LoginService(this._visitaService);
//
//   @override
//   bool isLogged() {
//     //vai no cache do celular e procura pela chave do usuario
//     //se achar retorna true
//     return false;
//   }
//
//   @override
//   Future<UsuarioEntity> login(String username, String password) async {
//     // // 1 - Vai na api (rota/auth/login) levando usuario e senha.
//     // final response = await _api.post(uri: '/auth/login', data:{
//     //   'login': username,
//     //   'senha': password,
//     // });
//     //
//     // // 2 - Se api falhar devolve um erro
//     // if (response == null) throw Exception('erro ao fazer login');
//     //
//     // // 3 - Pega a resposta da API (JSON) e converte para o UsuarioEntity
//     // final usuario = UsuarioEntity.fromJson(response);
//     //
//     // // 4 - Salva o JSON no Cache local para o app "lembrar" do usuario depois
//     // await _cache.setString(cacheUsuarioKey, jsonEncode(response));
//     //
//     // // 5 - Devolve a entidade pronta paa quem chamou (a controller)
//     // return usuario
//     throw UnimplementedError('Api e cache ainda nao implçemtados');
//   }
//
//   @override
//   Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts) async {
//     // // se o token de acesso expirar, este medoto vai na api
//     // // e troca o tken velho por um novo, sem pedir senha
//     // final response = await _api.post(
//     //   uri: '/usuario/refresh-token',
//     //   data: {'refreshToken': refreshToken},
//     //   refreshAttempts: refreshAttempts
//     // );
//     //
//     // if (response == null) throw Exception('Erro ao atualizar token');
//     // await _cache.setString(cacheUsuarioKey, jsonEncode(response));
//     // return usuario;
//     throw UnimplementedError('Api e cache ainda nao implçemtados');
//   }
//
//   @override
//   Future<void> logout() async {
//     // 1 - remove a autorização do do usuario no cache
//     //await _cache.remove(cacheUsuarioKey);
//
//     // 2 - chama a serice de visitas e manda limpar o banco de dados no SQLite
//     //assim se outra pessoa logar no mesmo celular nao vera os dados do usuario anterior
//     await _visitaService.limparTabelaDoBancoLocal();
//   }
// }


//login_service_interface
// import '../../usuario/entity/usuario_entity.dart';
//
// //Interface que define as operações de autenticação e gerenciamento de sessão do usuário.
// //
// // // Deve ser implementada por serviços de autenticação para login, logout, criação de conta e renovação de token.
//
//
// abstract class ILoginService {
//   //Realiza login do usuario
//   //Envia as credenciais para a API e devolve a entidade do usuário com os tokens.
//   Future<UsuarioEntity> login(String username, String password);
//
//   //renova o token de autenticaçao do usuario
//   //Usa o token de renovação para pegar um novo token de acesso na API.
//   Future<UsuarioEntity> refreshToken(String refreshToken, int refreshAttempts);
//
//   //realiza logout do usuario
//   Future<void> logout();
//
//   //verifica se esxte usuario logado
//   bool isLogged();
//
// }
