import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'entity/visita_entity.dart';

class VisitaDetalhePage extends StatelessWidget {
  final VisitaEntity visita;

  const VisitaDetalhePage({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(visita.dataVisita);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visita'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              _CampoDetalhe(
                label: 'Data da visita',
                valor: dataFormatada,
              ),
              _CampoDetalhe(
                label: 'Nome da empresa',
                valor: visita.nomeEmpresa,
              ),
              _CampoDetalhe(
                label: 'Contato na empresa',
                valor: visita.nomeContatoEmpresa,
              ),
              _CampoDetalhe(
                label: 'CPF/CNPJ da empresa',
                valor: visita.cpfCnpjEmpresa,
              ),
              _CampoDetalhe(
                label: 'E-mail da empresa',
                valor: visita.emailEmpresa,
              ),
              _CampoDetalhe(
                label: 'Telefone',
                valor: visita.telefoneEmpresa,
              ),
              _CampoDetalhe(
                label: 'Logradouro',
                valor: visita.logradouroEmpresa,
              ),
              _CampoDetalhe(
                label: 'Número',
                valor: visita.numeroEmpresa,
              ),
              _CampoDetalhe(
                label: 'Cidade',
                valor: visita.cidadeEmpresa,
              ),
              _CampoDetalhe(
                label: 'Complemento',
                valor: visita.complementoEmpresa,
              ),
              _CampoDetalhe(
                label: 'Sistema atual',
                valor: visita.sistemaAtual,
              ),
              _CampoDetalhe(
                label: 'Valor pago',
                valor: visita.valorPago,
              ),

              _BotaoInteresse(demonstrouInteresse: visita.demonstrouInteresse),

              const SizedBox(height: 16),

              _CampoDetalhe(
                label: 'Observações',
                valor: visita.observacoes,
                mostrarSeDivider: false,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
class _CampoDetalhe extends StatelessWidget {
  final String label;
  final String? valor;
  final bool mostrarSeDivider;

  const _CampoDetalhe({
    required this.label,
    this.valor,
    this.mostrarSeDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (valor == null || valor!.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.secondary,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            valor!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if(mostrarSeDivider) const SizedBox(height: 16),
      ],
    );
  }
}

class _BotaoInteresse extends StatelessWidget {
  final bool demonstrouInteresse;

  const _BotaoInteresse({required this.demonstrouInteresse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demonstrou interesse?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: demonstrouInteresse ? Colors.green : Colors.white,
                  foregroundColor: demonstrouInteresse ? Colors.white : theme.colorScheme.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                label: const Text('Sim', style: TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: !demonstrouInteresse ? theme.colorScheme.primary : Colors.white,
                  foregroundColor: !demonstrouInteresse ? Colors.white : theme.colorScheme.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.thumb_down_alt_outlined, size: 20),
                label: const Text('Não', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}