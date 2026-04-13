import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Text(
              'LT',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: const Text('Visitas'),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed:(){
            controller.load();
          },
        child: const Icon(Icons.add),
      ),

    );
  }
}