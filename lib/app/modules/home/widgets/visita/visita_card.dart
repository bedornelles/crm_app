import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';
import 'package:crm_app/app/shared/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:crm_app/app/modules/sincronizacao/sincronizacao_service.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

class VisitaCard extends StatelessWidget{
  final VisitaEntity visita;

  const VisitaCard({
    super.key,
    required this.visita,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(visita.dataVisita);

    return Card (
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Modular.to.pushNamed('$visitaRouter$visitaDetalheRouter', arguments: visita,
        ),

        child: Padding(
          padding: const EdgeInsetsGeometry.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataFormatada,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildIconeSincronizacao(context),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                visita.tituloExibicao,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                visita.nomeContatoEmpresa,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildIconeSincronizacao(BuildContext context) {
    switch (visita.statusSincronizacao) {
      case StatusSincronizacao.sincronizado:
        return const SizedBox.shrink();

      case StatusSincronizacao.pendente:
        return SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.grey.shade400,
          ),
        );

      case StatusSincronizacao.erro:
        return GestureDetector(
          onTap: () => _mostrarModalErro(context),
          behavior: HitTestBehavior.opaque,
          child: Icon(
            Icons.cloud_off_rounded,
            size:20,
            color: Colors.red.shade600,
          ),
        );

      case StatusSincronizacao.falhou:
        return GestureDetector(
          onTap: () => _mostrarModalErro(context),
          behavior: HitTestBehavior.opaque,
          child: Icon(
            Icons.cloud_off_rounded,
            size: 20,
            color: Colors.red.shade600,
          ),
        );
    }
  }

  void _mostrarModalErro(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => Padding(
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

              SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Erro de sincronização',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                visita.erroSincronizacao ?? 'Erro desconhecido.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  if (visita.statusSincronizacao == StatusSincronizacao.falhou) {
                    // busca o serviço e tenta novamente
                    final sincronizacaoService = Modular.get<SincronizacaoService>();
                    await sincronizacaoService.tentarNovamente(visita.base.id);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      visita.statusSincronizacao == StatusSincronizacao.falhou
                          ? 'Tentar novamente'
                          : 'Fechar',
                    ),
                    Icon(
                      visita.statusSincronizacao == StatusSincronizacao.falhou
                          ? Icons.sync
                          : Icons.close,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}