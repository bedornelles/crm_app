import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pkg_flutter_utils/validators.dart';
import 'identificar_empresa_id_controller.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:crm_app/app/modules/home/home_controller.dart';

class IdentificarEmpresaIdPage extends StatefulWidget {
  const IdentificarEmpresaIdPage({super.key});

  @override
  State<IdentificarEmpresaIdPage> createState() => _IdentificarEmpresaIdPageState();
}

class _IdentificarEmpresaIdPageState extends State<IdentificarEmpresaIdPage> {
  final controller = Modular.get<IdentificarEmpresaIdController>();
  //puxa a função getIdUsuarioLogado da visitacontroller
  final visitaController = Modular.get<VisitaController>();
  //para validar os formularios
  final _formKey = GlobalKey<FormState>();

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
              TextFormField(
                keyboardType: TextInputType.number,
                validator: InputValidator.required,
                onChanged: (value) => controller.idEmpresa = value,
              ),

              const SizedBox(height: 16),

              _buildLabel(theme, 'Contato na empresa'),
              TextFormField(
                validator: InputValidator.required,
                onChanged: (value) => controller.contato = value,
              ),

              const SizedBox(height: 16),

              _buildLabel(theme, 'Observações'),
              TextFormField(
                validator: InputValidator.required,
                maxLines: 4,
                maxLength: 1500,
                onChanged: (value) => controller.observacoes = value,
              ),

              const SizedBox(height: 32),

              Observer(
                  builder: (_) => ElevatedButton(
                      onPressed: controller.loading ? null : _salvar,
                      child: controller.loading
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
        final String idLogado = await visitaController.getIdUsuarioLogado();

        await controller.salvarVisitaId(idLogado);

        final homeController = Modular.get<HomeController>();
        await homeController.load();

      }catch(e) {
        print('erro mostrar visita do id $e');
      }finally {
        Modular.to.navigate('/home/');
      }
    }
  }
}