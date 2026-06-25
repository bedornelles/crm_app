import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/home/widgets/menu_perfil_bottom_sheet/menu_perfil_bottom_sheet.dart';
import 'package:crm_app/app/modules/home/widgets/visita/filtro_data_bottom_sheet.dart';
import 'package:crm_app/app/modules/home/widgets/visita/visita_card.dart';
import 'package:crm_app/app/modules/visita/enum/filtro_data.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/widgets/dialogs/confirmacao_logout.dart';
import '../../shared/widgets/dialogs/permissao_localizacao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  final _pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.load();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final visitaController = Modular.get<VisitaController>();
      final deveExibir = await visitaController.deveExibirPermissaoLocalizacao();
      if (deveExibir && mounted) {
        PermissaoLocalizacao.show(
          context,
          onContinuar: () async {
            await visitaController.obterLocalizacao();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leadingWidth: controller.pesquisando ? 0 : 80,
            leading: controller.pesquisando
                ? const SizedBox.shrink()
                : GestureDetector(
              onTap: () => MenuPerfilBottomSheet.show(
                context,
                iniciaisUsuario: controller.iniciaisUsuario,
                nomeUsuario: controller.nomeUsuario,
                onDesconectar: () => ConfirmacaoLogout.show(
                  context,
                  onConfirmar: controller.desconectar,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    controller.iniciaisUsuario,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: controller.pesquisando
                ? Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: SizedBox(
                height: 48,
                child: TextField(
                  controller: _pesquisaController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Digite para buscar...',
                  ),
                  onChanged: controller.atualizarPesquisa,
                ),
              ),
            )
                : const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Visitas'),
            ),
            actions: [
              controller.pesquisando
                  ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _pesquisaController.clear();
                  controller.encerrarPesquisa();
                },
              )
                  : Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => const FiltroDataBottomSheet(),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: controller.iniciarPesquisa,
                  ),
                ],
              ),
            ],
          ),
          body: Observer(
            builder: (_) {
              if (controller.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  if (controller.filtroDataAtivo)
                    _BannerFiltroAtivo(controller: controller),

                  Expanded(
                    child: controller.visitasFiltradas.isEmpty
                        ? _EstadoVazio(controller: controller)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: controller.visitasFiltradas.length,
                            itemBuilder: (context, index) {
                              final visita = controller.visitasFiltradas[index];
                              return VisitaCard(visita: visita);
                            },
                        ),
                    ),
                  ],
                );
              },
            ),
          floatingActionButton: controller.pesquisando
              ? const SizedBox.shrink()
              : FloatingActionButton(
            onPressed: () async {
              await Modular.to.pushNamed('/visita/');
              controller.load();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

//banner para mostrar o filtro ativo
class _BannerFiltroAtivo extends StatelessWidget {
  final HomeController controller;

  const _BannerFiltroAtivo({required this.controller});

  String get _textoBanner {
    if (controller.filtroData == FiltroData.ontem) {
      return 'Filtrando visitas de ontem';
    }
    if (controller.filtroData == FiltroData.personalisado &&
        controller.dataInicio != null &&
        controller.dataFim != null) {
      final ini = controller.dataInicio!;
      final fim = controller.dataFim!;
      return 'Filtrando do dia ${ini.day}/${ini.month} até ${fim.day}/${fim.month}';
    }
    return 'Filtro ativo';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _textoBanner,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          GestureDetector(
            onTap: controller.limparFiltroData,
            child: Icon(
              Icons.close,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  final HomeController controller;

  const _EstadoVazio({required this.controller});

  String get _mensagem {
    if (controller.pesquisando && controller.visitas.isNotEmpty) {
      return 'Nenhuma visita encontrada com este filtro atribuído.';
    }
    if (controller.filtroDataAtivo) {
      return 'Nenhuma visita encontrada com este filtro atribuído.';
    }
    return 'Nenhuma visita registrada hoje neste dispositivo.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.filtroDataAtivo || controller.pesquisando
                ? Icons.filter_alt_outlined
                : Icons.list_alt_rounded,
            size: 70,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          if (controller.filtroDataAtivo) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: () {
                  controller.limparFiltroData();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => const FiltroDataBottomSheet(),
                  );
                },
                child: const Text('Experimente um filtro diferente'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}