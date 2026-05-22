import 'dart:convert';

import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/widgets/visita/visita_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';

class HomePage extends StatefulWidget{
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //modular procura o controller que registrei no module
  final controller = Modular.get<HomeController>();
  final _pesquisaController = TextEditingController();

  @override
  void initState(){
    super.initState();
    //tela abre e chama o metodo carregar fados
    controller.load();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final visitaController = Modular.get<VisitaController>();
      final deveExibir = await visitaController.deveExibirPermissaoLocalizacao();
      if (deveExibir) {
        _mostrarModalPermissaoLocalizacao(context);
      }
    });
  }

  @override
  void dispose(){
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Observer(
            builder: (_) {
              if (controller.pesquisando) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  mostrarMenuPerfil(context, controller);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      controller.iniciaisUsuario, // Agora o Observer vai conseguir atualizar isso!
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),


        title: Observer(
          builder: (_) {
            // quando pesquisando, mostra o campo de texto no lugar do título
            if (controller.pesquisando) {
              return TextField(
                controller: _pesquisaController,
                autofocus: true, // abre o teclado automaticamente
                decoration: const InputDecoration(
                  hintText: 'Digite para buscar...',
                  border: InputBorder.none, // sem borda para ficar clean na AppBar
                ),
                onChanged: controller.atualizarPesquisa,
              );
            }
            return const Text('Visitas');
          },
        ),
        actions: [
          Observer(
            builder: (_) {
              if (controller.pesquisando) {
                // quando pesquisando, mostra o X para fechar
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _pesquisaController.clear();
                    controller.encerrarPesquisa();
                  },
                );
              }
              // estado normal: mostra calendário e lupa
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: controller.iniciarPesquisa,
                  ),
                ],
              );
            },
          ),
        ],
      ),

      //observer vai invelopar o que precsa ser reativo
      //sempre q o controller.loading mudar o observer roda o codigo novamente
      body: Observer(
        builder: (_) {
          if (controller.loading) {
            return const Center(
                child: CircularProgressIndicator()
            );
          }

          if (controller.visitasFiltradas.isEmpty) {
            final ehResultadoDePesquisa = controller.pesquisando && controller.visitas.isNotEmpty;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ehResultadoDePesquisa ? Icons.filter_alt_outlined : Icons.list_alt_rounded,
                    size: 70,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    ehResultadoDePesquisa
                      ? "Nenhuma visita encontrada com este filtro atribuído."
                      : "Nenhuma visita registrada hoje neste dispositivo.",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.all(16.0),

            itemCount: controller.visitasFiltradas.length,
            itemBuilder: (context, index) {

              final visita = controller.visitasFiltradas[index];

              return VisitaCard(visita: visita);
            },
          );

        },
      ),

      floatingActionButton: Observer(
        builder: (_){
          if (controller.pesquisando) return const SizedBox.shrink();

            return FloatingActionButton(
              onPressed:() async {
                await Modular.to.pushNamed('/visita/');
                controller.load();
              },
              child: const Icon(Icons.add),
            );
          },
      ),
    );
  }

  void mostrarMenuPerfil(BuildContext context, HomeController controller) {
      showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
      ),
      builder: (BuildContext context) {
        return Padding (
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 24),

              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  controller.iniciaisUsuario,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                controller.nomeUsuario,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    // Primeiro fecha o Bottom Sheet
                    Navigator.pop(context);
                    // Depois chama a função de logout no Controller
                    controller.desconectar();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Desconectar',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.exit_to_app_rounded, // Ícone de saída
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        );
      }
    );
  }

  void _mostrarModalPermissaoLocalizacao(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 36,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sua localização',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Precisamos acessar sua localização para registrar automaticamente suas visitas no sistema.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  // fecha o modal primeiro
                  Navigator.of(ctx).pop();
                  // depois dispara o popup nativo do sistema
                  final visitaController = Modular.get<VisitaController>();
                  await visitaController.obterLocalizacao();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sua localização é armazenada com segurança e usada apenas para cadastro de visitas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }


}