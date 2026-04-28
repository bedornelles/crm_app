import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:crm_app/app/modules/login/login_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Modular.get<LoginController>();

  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image.asset('assets/images/app_icon_grande.png'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          Form(
                            key: formKey,
                            child: SizedBox(
                              width: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Usuário'),
                                  const SizedBox(height: 8),
              
                                  TextFormField(
                                    controller: usuarioController,
                                    decoration: InputDecoration(
                                      hintText: 'Insira seu usuário...',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe o usuário';
                                      }
                                      return null;
                                    },
                                  ),
              
                                  const SizedBox(height: 16),
              
                                  const Text('Senha'),

                                  const SizedBox(height: 8),
              
                                  Observer(
                                      builder: (_){
                                        return TextFormField(
                                          controller: passwordController,
                                          obscureText: !controller.mostrarSenha,
                                          decoration: InputDecoration(
                                            hintText: 'Insira sua senha...',
                                            hintStyle: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                controller.mostrarSenha
                                                    ?Icons.visibility_off
                                                    :Icons.visibility,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              onPressed: controller.alterarMostrarSenha,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Informe a senha';
                                            }
                                            return null;
                                          }
                                        );
                                      }
                                  ),
                                  const SizedBox(height: 24),
              
                                  Observer(
                                    builder: (_) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: FilledButton(
                                            onPressed: () async{
                                              await save(() async {
                                                await controller.login(
                                                  usuarioController.text,
                                                  passwordController.text,
                                                );
                                              });
                                            },
                                          child: controller.loading
                                              ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                               child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                          )
                                              :Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text('Entrar'),
                                              Icon(Icons.arrow_forward_outlined, size: 18),
                                            ],
                                          )
                                        ),
                                      );
                                    }
                                  )
                                ],
                              ),
                            )
                          )
                        ],
                      )
                    ),
                ],
              ),
            ),
        ),
      ),
    );
  }
  Future<void> save(Future<void> Function() onSave) async {
    try {
      if (formKey.currentState != null &&
          formKey.currentState!.validate()) {
        await onSave();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
