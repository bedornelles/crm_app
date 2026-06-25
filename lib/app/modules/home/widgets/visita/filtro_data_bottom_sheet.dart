import 'package:crm_app/app/modules/visita/enum/filtro_data.dart';
import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FiltroDataBottomSheet extends StatefulWidget {
  const FiltroDataBottomSheet({super.key});

  @override
  State<FiltroDataBottomSheet> createState() => _FiltroDataBottomSheetState();
}

class _FiltroDataBottomSheetState extends State<FiltroDataBottomSheet> {
  final controller = Modular.get<HomeController>();

  late FiltroData _selecaoAtual;
  DateTime? _dataInicio;
  DateTime? _dataFim;

  @override
  void initState() {
    super.initState();

    _selecaoAtual = controller.filtroData;
    _dataInicio = controller.dataInicio;
    _dataFim = controller.dataFim;
  }

  void _confirmar() {
    if (_selecaoAtual == FiltroData.personalisado) {
      if (_dataInicio == null || _dataFim == null) return;
    }
    controller.aplicarFiltroData(
      _selecaoAtual,
      inicio: _dataInicio,
      fim: _dataFim,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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

          _OpcaoFiltro(
            label: 'Hoje',
            selecionado: _selecaoAtual == FiltroData.hoje,
            onTap: () => setState(() {
              _selecaoAtual = FiltroData.hoje;
            }),
          ),

          const SizedBox(height: 12),

          _OpcaoFiltro(
            label: 'Ontem',
            selecionado: _selecaoAtual == FiltroData.ontem,
            onTap: () => setState(() {
              _selecaoAtual = FiltroData.ontem;
            }),
          ),

          const SizedBox(height: 12),

          _OpcaoFiltro(
            label: 'Personalizado',
            selecionado: _selecaoAtual == FiltroData.personalisado,
            onTap: () async {
              // abre o segundo bottom sheet por cima
              final resultado = await showModalBottomSheet<Map<String, DateTime>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => _FiltroPersonalizadoSheet(
                  dataInicio: _dataInicio,
                  dataFim: _dataFim,
                ),
              );

              if (resultado != null) {
                controller.aplicarFiltroData(
                  FiltroData.personalisado,
                  inicio: resultado['inicio'],
                  fim: resultado['fim'],
                );
                Navigator.pop(context);
              }
            },
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _confirmar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Filtrar'),
                Icon(Icons.check),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpcaoFiltro extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _OpcaoFiltro({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              selecionado ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selecionado
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// widget do campo de data
class _CampoData extends StatelessWidget {
  final String label;
  final String valor;
  final VoidCallback onTap;

  const _CampoData({
    required this.label,
    required this.valor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valor.isEmpty ? '' : valor,
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.calendar_month_rounded,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FiltroPersonalizadoSheet extends StatefulWidget {
  final DateTime? dataInicio;
  final DateTime? dataFim;

  const _FiltroPersonalizadoSheet({
    this.dataInicio,
    this.dataFim,
  });

  @override
  State<_FiltroPersonalizadoSheet> createState() => _FiltroPersonalizadoSheetState();
}

class _FiltroPersonalizadoSheetState extends State<_FiltroPersonalizadoSheet> {
  DateTime? _dataInicio;
  DateTime? _dataFim;

  @override
  void initState() {
    super.initState();
    _dataInicio = widget.dataInicio;
    _dataFim = widget.dataFim;
  }

  Future<void> _selecionarData(bool ehInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null) {
      setState(() {
        if (ehInicio) {
          _dataInicio = picked;
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _confirmar() {
    if (_dataInicio == null || _dataFim == null) {
      _mostrarErroDataPersonalizada('Preencha as duas datas para continuar.');
      return;
    }
    if(_dataFim!.isBefore(_dataInicio!)){
      _mostrarErroDataPersonalizada('Redefina a data inicial, pois ela não pode ser posterior a data final!',
        onTentarNovamente: () => setState(() {
          _dataInicio = null;
          _dataFim = null;
        }),
      );
      return;
    }
    Navigator.pop(context, {
      'inicio': _dataInicio!,
      'fim': _dataFim!,
    });
  }
  
  void _mostrarErroDataPersonalizada(String mensagem, {VoidCallback? onTentarNovamente}) {
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
              const SizedBox(height: 32),
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.primary, size: 30),
              const SizedBox(height: 12),
              Text(
                'Ops!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onTentarNovamente?.call();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tentar novamente',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                        ),
                      ),
                      Icon(Icons.refresh, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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

          _CampoData(
            label: 'De',
            valor: _formatarData(_dataInicio),
            onTap: () => _selecionarData(true),
          ),

          const SizedBox(height: 12),

          _CampoData(
            label: 'Até',
            valor: _formatarData(_dataFim),
            onTap: () => _selecionarData(false),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _confirmar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Filtrar'),
                Icon(Icons.check),
              ],
            ),
          ),
        ],
      ),
    );
  }
}