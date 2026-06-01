import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

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
        onTap: () => Modular.to.pushNamed(
          '/visita/detalhe',
          arguments: visita,
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                visita.nomeContatoEmpresa,
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
        return Icon(
          Icons.cloud_upload_outlined,
          size: 20,
          color: Colors.grey.shade400,
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
    }
  }

  void _mostrarModalErro(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cloud_off_rounded, color: Colors.red.shade600, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Erro de sincronização',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Text(
                visita.erroSincronizacao ?? 'Erro desconhecido.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}