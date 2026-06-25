import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pkg_flutter_utils/validators.dart';
import '../sincronizacao/sincronizacao_service.dart';
import 'identificar_empresa_id_controller.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:crm_app/app/modules/home/home_controller.dart';

class IdentificarEmpresaIdPage extends StatefulWidget {
  const IdentificarEmpresaIdPage({super.key});

  @override
  State<IdentificarEmpresaIdPage> createState() => _IdentificarEmpresaIdPageState();
}

class _IdentificarEmpresaIdPageState extends State<IdentificarEmpresaIdPage> with TickerProviderStateMixin{
  final controller = Modular.get<IdentificarEmpresaIdController>();
  //puxa a função getIdUsuarioLogado da visitacontroller
  final visitaController = Modular.get<VisitaController>();
  //para validar os formularios
  final _formKey = GlobalKey<FormState>();
  final _idKey = GlobalKey();
  final _contatoKey = GlobalKey();
  final Set<String> _camposComErro = {};

  late AnimationController _shakeId;
  late AnimationController _shakeContato;

  @override
  void initState() {
    super.initState();
    _shakeId = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeContato = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _shakeId.dispose();
    _shakeContato.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabel(theme, 'ID'),

              KeyedSubtree(
                key: _idKey,
                child: _buildShakeField(
                  animationController: _shakeId,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: InputValidator.required,
                    onChanged: (value) {
                      controller.setIdEmpresa(value);
                      if (_camposComErro.contains('id')) {
                        setState(() => _camposComErro.remove('id'));
                      }
                    },
                    decoration: InputDecoration(
                      border: _camposComErro.contains('id')
                          ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
                      )
                          : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel(theme, 'Contato na empresa'),

              KeyedSubtree(
                key: _contatoKey,
                child: _buildShakeField(
                  animationController: _shakeContato,
                  child: TextFormField(
                    validator: InputValidator.required,
                    onChanged: (value) {
                      controller.setContato(value);
                      if (_camposComErro.contains('contato')) {
                        setState(() => _camposComErro.remove('contato'));
                      }
                    },
                    decoration: InputDecoration(
                      border: _camposComErro.contains('contato')
                          ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
                      )
                          : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel(theme, 'Observações'),
              TextFormField(
                maxLines: 4,
                maxLength: 1500,
                onChanged: controller.setObservacoes,
              ),

              const SizedBox(height: 32),

              Observer(
                  builder: (_) => ElevatedButton(
                      onPressed: controller.saving ? null : _salvar,
                      child: controller.saving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2,))
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Salvar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Icon(Icons.check, size:20),
                            ],
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel (ThemeData theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.secondary
      )),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final homeController = Modular.get<HomeController>();
        final String idUsuario = homeController.idUsuarioLogado;

        final visita = await controller.salvar(idUsuario);

        if (visita != null) {
          final sincronizacaoService = Modular.get<SincronizacaoService>();
          sincronizacaoService.sincronizarVisita(visita);
        }

        await homeController.load();

      }catch(e) {
        print('erro mostrar visita do id $e');
      }finally {
        Modular.to.navigate('/home/');
      }
    } else {

      setState(() {
        if (controller.idEmpresa.isEmpty) {
          _camposComErro.add('id');
        }
        if (controller.contato.isEmpty) {
          _camposComErro.add('contato');
        }
      });

      if (controller.idEmpresa.isEmpty) {
        _shakeId.forward(from: 0);
      }
      if (controller.contato.isEmpty) {
        _shakeContato.forward(from: 0);
      }
    }
  }

  Widget _buildShakeField({
    required AnimationController animationController,
    required Widget child,
}) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final offset = sin(animationController.value * pi * 6) * 8;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}