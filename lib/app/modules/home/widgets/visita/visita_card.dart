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
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(visita.data);

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
              Text(
                dataFormatada,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                visita.nomeEmpresa,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                visita.contato,
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