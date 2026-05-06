import 'dart:convert';

import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/widgets/visita/visita_card.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:crm_app/app/shared/cache/cache_interface.dart';
import 'package:crm_app/app/shared/api/crm_api_interface.dart';

class HomePage extends StatefulWidget{
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //modular procura o controller que registrei no module
  final controller = Modular.get<HomeController>();

  @override
  void initState(){
    super.initState();
    //tela abre e chama o metodo carregar fados
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Observer(
            builder: (_) {
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
        title: const Text('Visita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: (){

            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
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

          if (controller.visitas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt_rounded,
                    size: 70,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    "Nenhuma visita registrada hoje neste dispositivo",
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
            itemCount: controller.visitas.length,
            itemBuilder: (context, index) {

              final visita = controller.visitas[index];

              return VisitaCard(visita: visita);
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          await Modular.to.pushNamed('/visita/');

          controller.load();
        },
        child: const Icon(Icons.add),
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

              InkWell(
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
                    color:  Color(0xFFFFFF),
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
            ],
          )
        );
      }
    );
  }

}