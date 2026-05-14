import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';
import 'package:flutter/material.dart';
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
        // onTap: () => _mostrarDetalhes(context),

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

  // // void _mostrarDetalhes(BuildContext context){
  // //   showModalBottomSheet(
  // //       context: context,
  // //       isScrollControlled: true,
  // //       shape: const RoundedRectangleBorder(
  // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  // //       ),
  // //
  // //       builder: (context) {
  // //         return Padding(
  // //           padding: EdgeInsets.only(
  // //               left:24.0,
  // //               right: 24.0,
  // //               top: 24.0,
  // //               bottom: MediaQuery.of(context).padding.bottom + 24.0
  // //           ),
  // //           child: Column(
  // //             mainAxisSize: MainAxisSize.min,
  // //             crossAxisAlignment: CrossAxisAlignment.start,
  // //             children: [
  // //               const Text(
  // //                 'Detalhes da visita',
  // //                 style: TextStyle(
  // //                   fontSize: 20,
  // //                   fontWeight: FontWeight.w500,
  // //                 ),
  // //               ),
  // //               const Divider(),
  // //               const SizedBox(height: 10),
  // //
  // //               _itemDetalhe("Empresa", visita.nomeEmpresa),
  // //               _itemDetalhe("Contato", visita.contato),
  // //               _itemDetalhe("Telefone", visita.telefone),
  // //               _itemDetalhe("CPF/CNPJ", visita.cpfCnpj),
  // //               _itemDetalhe("Endereço", "${visita.logradouro}, ${visita.numero} - ${visita.cidade}"),
  // //               _itemDetalhe("Valor Pago", visita.valorPago),
  // //               _itemDetalhe("Interesse?", visita.demonstrouInteresse ? "Sim" : "Não"),
  // //               // Se a observação for nula ou vazia, mostra "Sem observações"
  // //               _itemDetalhe("Observações", visita.observacoes?.isNotEmpty == true ? visita.observacoes! : "Sem observações"),
  // //             ],
  // //
  // //           ),
  // //         );
  // //       }
  // //
  // //   );
  // // }
  // Widget _itemDetalhe(String titulo, String valor) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("$titulo: ", style: const TextStyle(fontWeight: FontWeight.bold)),
  //         // O Expanded faz o texto quebrar de linha caso seja muito longo (como o endereço)
  //         Expanded(child: Text(valor)),
  //       ],
  //     ),
  //   );
  // }

}