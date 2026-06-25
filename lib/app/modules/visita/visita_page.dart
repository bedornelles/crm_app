import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:crm_app/app/shared/router/routes.dart';
import 'package:crm_app/app/shared/widgets/demonstrou_interesse/demonstrou_interesse.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:pkg_flutter_utils/masked.dart'; //pacote cervantes
import 'package:pkg_flutter_utils/validators.dart'; //pacote cervantes
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:crm_app/app/shared/widgets/text_form_field/text_form_field_default.dart';
import 'package:crm_app/app/shared/widgets/type_ahead_field/type_ahead_field_default.dart';
import '../../shared/widgets/dialogs/modal_descartar.dart';
import '../sincronizacao/sincronizacao_service.dart';

class VisitaPage extends StatefulWidget{

  const VisitaPage({super.key});

  @override
  State<VisitaPage> createState() => _VisitaPageState();
}

class _VisitaPageState extends State<VisitaPage> with TickerProviderStateMixin{

  final controller = Modular.get<VisitaController>();
  final _formKey = GlobalKey<FormState>();
  bool _salvando = false;

  final _telefoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _valorPagoController = TextEditingController();
  final _nomeEmpresaController = TextEditingController();
  final _contatoController = TextEditingController();
  final _emailController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _complementoController = TextEditingController();
  final _sistemaController = TextEditingController();
  final _observacoesController = TextEditingController();

  // controla o scroll da tela
  final _scrollController = ScrollController();

  // mostra a posição exata do campo para scrollar ate ele
  final _nomeEmpresaKey = GlobalKey();
  final _contatoKey = GlobalKey();
  final _logradouroKey = GlobalKey();
  final _numeroKey = GlobalKey();
  final _cidadeKey = GlobalKey();
  final _interesseKey = GlobalKey();
  final _cpfCnpjKey = GlobalKey();

  final Set<String> _camposComErro = {};

  //controlador do shake
  late AnimationController _shakeNomeEmpresa;
  late AnimationController _shakeContato;
  late AnimationController _shakeLogradouro;
  late AnimationController _shakeNumero;
  late AnimationController _shakeCidade;
  late AnimationController _shakeInteresse;
  late AnimationController _shakeCpfCnpj;

  bool get _temAlteracoes {
    return _nomeEmpresaController.text.isNotEmpty ||
        _contatoController.text.isNotEmpty ||
        _logradouroController.text.isNotEmpty ||
        _numeroController.text.isNotEmpty ||
        _cidadeController.text.isNotEmpty ||
        _telefoneController.text.isNotEmpty ||
        _cpfCnpjController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _complementoController.text.isNotEmpty ||
        _sistemaController.text.isNotEmpty ||
        _valorPagoController.text.isNotEmpty ||
        _observacoesController.text.isNotEmpty ||
        controller.visita.demonstrouInteresse != null;
  }


  @override
  void initState() {
    super.initState();
    final homeController = Modular.get<HomeController>();
    controller.init(homeController.idUsuarioLogado);

    _shakeNomeEmpresa = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeContato = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeLogradouro = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeNumero = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeCidade = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeInteresse = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeCpfCnpj = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _shakeNomeEmpresa.dispose();
    _shakeContato.dispose();
    _shakeLogradouro.dispose();
    _shakeNumero.dispose();
    _shakeCidade.dispose();
    _scrollController.dispose();
    _shakeInteresse.dispose();
    _shakeCpfCnpj.dispose();
    super.dispose();
  }

  //recebe o controller da animazacao e a key do campo, dispara o shake e rola ate o campo
  Future<void> _shakeEScrollar(AnimationController shakeController, GlobalKey fieldKey) async {
    if (!mounted) return;

    final fieldContext = fieldKey.currentContext;
    if (fieldContext != null) {
      await Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }

    if (!mounted) return;

    shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if(_salvando) return;
        if (_temAlteracoes) {
          await ModalDescartar.show(
              context, onDescartar: () => Modular.to.pop());
        } else {
          Modular.to.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visita'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) async {
                if (result == 'identificar_id'){
                  await Modular.to.pushNamed('$visitaRouter$visitaIdentificarIdRouter');
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'identificar_id',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Identificar empresa pelo ID',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                )
              ]
            ),
          ],
        ),

        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Text(
                      'Data da visita',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DateTimeFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_month_rounded,
                          color: theme.colorScheme.secondary,
                        )
                      ),
                      initialValue: DateTime.now(),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      dateFormat: DateFormat('dd/MM/yyyy HH:mm'),
                      firstDate: DateTime.now().subtract(const Duration(days: 7)),
                      lastDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      onDateSelected: (DateTime? novaData){
                        if (novaData != null) {
                          controller.visita.dataVisita = novaData;
                        }
                      }
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Nome da empresa',
                      controller: _nomeEmpresaController,
                      hintText: 'Lancheria do centro',
                      validator: InputValidator.required,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 150,
                      mostrarContador: false,
                      fieldKey: _nomeEmpresaKey,
                      shakeController: _shakeNomeEmpresa,
                      temErro: _camposComErro.contains('nomeEmpresa'),
                      onChanged: (_) {
                        if (_camposComErro.contains('nomeEmpresa')) {
                          setState(() => _camposComErro.remove('nomeEmpresa'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Contato na empresa',
                      controller: _contatoController,
                      hintText: 'João da Silva',
                      validator: InputValidator.required,
                      textCapitalization: TextCapitalization.words,
                      maxLength:150,
                      mostrarContador: false,
                      fieldKey: _contatoKey,
                      shakeController: _shakeContato,
                      temErro: _camposComErro.contains('contato'),
                      onChanged: (_) {
                        if (_camposComErro.contains('contato')) {
                          setState(() => _camposComErro.remove('contato'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'CPF/CNPJ da empresa',
                      controller: _cpfCnpjController,
                      hintText: '00.000.000/0000-00',
                      textInputType: TextInputType.number,
                      inputFormatters: [InputMasked.cnpjCpf(value: _cpfCnpjController.text)],
                      validator: (value) => InputValidator([CnpjCpfValidator()]).validate(value),
                      fieldKey: _cpfCnpjKey,
                      shakeController: _shakeCpfCnpj,
                      temErro: _camposComErro.contains('cpfCnpj'),
                      onChanged: (_) {
                        if (_camposComErro.contains('cpfCnpj')) {
                          setState(() => _camposComErro.remove('cpfCnpj'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'E-mail da empresa',
                      controller: _emailController,
                      hintText: 'emailEmpresa@example.com',
                      maxLength: 150,
                      mostrarContador: false,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        final emailValido = EmailValidator.validate(value);
                        if (!emailValido) return 'Digite um E-mail válido';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Telefone',
                      controller: _telefoneController,
                      hintText: '(51) 9 9999-9999',
                      maxLength: 16,
                      mostrarContador: false,
                      textInputType: TextInputType.phone,
                      inputFormatters: [InputMasked.fone(value: _telefoneController.text)],
                    ),

                    const SizedBox(height: 16),

                    TypeAheadFieldDefault(
                      label: 'Logradouro',
                      controller: _logradouroController,
                      hintText: 'Av Barão do Rio Branco, centro',
                      validator: InputValidator.required,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      mostrarContador: false,
                      fieldKey: _logradouroKey,
                      shakeController: _shakeLogradouro,
                      temErro: _camposComErro.contains('logradouro'),
                      suggestionsCallback: (search) => controller.getEnderecos(search),
                      onChanged: (value) {
                        controller.visita.logradouroEmpresa = value!;
                        if (_camposComErro.contains('logradouro')) {
                          setState(() => _camposComErro.remove('logradouro'));
                        }
                      },
                      onSelected: (suggestion) {
                        _logradouroController.text = suggestion;
                        controller.visita.logradouroEmpresa = suggestion;
                        if (_camposComErro.contains('logradouro')) {
                          setState(() => _camposComErro.remove('logradouro'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Número',
                      controller: _numeroController,
                      hintText: '1234',
                      maxLength: 50,
                      mostrarContador: false,
                      validator: InputValidator.required,
                      fieldKey: _numeroKey,
                      shakeController: _shakeNumero,
                      temErro: _camposComErro.contains('numero'),
                      onChanged: (_) {
                        if (_camposComErro.contains('numero')) {
                          setState(() => _camposComErro.remove('numero'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TypeAheadFieldDefault(
                      label: 'Cidade',
                      controller: _cidadeController,
                      hintText: 'São Paulo/SP',
                      validator: InputValidator.required,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 50,
                      mostrarContador: false,
                      fieldKey: _cidadeKey,
                      shakeController: _shakeCidade,
                      temErro: _camposComErro.contains('cidade'),
                      suggestionsCallback: (search) => controller.getCidades(search),
                      onChanged: (value) {
                        controller.visita.cidadeEmpresa = value!;
                        if (_camposComErro.contains('cidade')) {
                          setState(() => _camposComErro.remove('cidade'));
                        }
                      },
                      onSelected: (suggestion) {
                        _cidadeController.text = suggestion;
                        controller.visita.cidadeEmpresa = suggestion;
                        if (_camposComErro.contains('cidade')) {
                          setState(() => _camposComErro.remove('cidade'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Complemento',
                      controller: _complementoController,
                      hintText: 'Sala 01, Ap 01, Perto de...',
                      maxLength: 50,
                      mostrarContador: false,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Sistema atual',
                      controller: _sistemaController,
                      hintText: 'ERP Xyz',
                      maxLength: 50,
                      mostrarContador: false,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Valor Pago',
                      controller: _valorPagoController,
                      hintText: 'R\$ 99,90',
                      maxLength: 15,
                      mostrarContador: false,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        InputMasked.currency(
                          value: _valorPagoController.text.isEmpty ? null : _valorPagoController.text,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Observer(
                      builder: (_) => DemonstrouInteresse(
                        label: 'Demonstrou interesse?',
                        value: controller.visita.demonstrouInteresse,
                        fieldKey: _interesseKey,
                        shakeController: _shakeInteresse,
                        temErro: _camposComErro.contains('interesse'),
                        onChanged: (novoValor) {
                          controller.visita.demonstrouInteresse = novoValor;
                          if (_camposComErro.contains('interesse')) {
                            setState(() => _camposComErro.remove('interesse'));
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldDefault(
                      label: 'Observações',
                      controller: _observacoesController,
                      maxLines: 4,
                      maxLength: 1500,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _salvando ? null : () async {
                        bool estaValido = _formKey.currentState!.validate();
                        bool escolheuInteresse = controller.visita.demonstrouInteresse != null;

                        //validação
                        if (estaValido && escolheuInteresse) {
                          setState(() => _salvando = true);
                          try{
                            controller.visita.nomeEmpresa = _nomeEmpresaController.text;
                            controller.visita.nomeContatoEmpresa = _contatoController.text;
                            controller.visita.cpfCnpjEmpresa = _cpfCnpjController.text;
                            controller.visita.emailEmpresa = _emailController.text;
                            controller.visita.telefoneEmpresa = _telefoneController.text;
                            controller.visita.logradouroEmpresa = _logradouroController.text;
                            controller.visita.numeroEmpresa = _numeroController.text;
                            controller.visita.cidadeEmpresa = _cidadeController.text;
                            controller.visita.complementoEmpresa = _complementoController.text;
                            controller.visita.sistemaAtual = _sistemaController.text;
                            controller.visita.valorPago = _valorPagoController.text;
                            controller.visita.observacoes = _observacoesController.text;

                            final homeController = Modular.get<HomeController>();
                            final visita = await controller.salvar();

                            if (visita != null) {
                              final sincronizacaoService = Modular.get<SincronizacaoService>();
                              sincronizacaoService.sincronizarVisita(visita);

                              await homeController.load();
                              Modular.to.pop(visita);
                            }
                          } finally {
                            if (mounted) setState(() => _salvando = false);
                          }
                          } else {

                            final cpfCnpjInvalido = InputValidator(
                              [CnpjCpfValidator()],
                            ).validate(_cpfCnpjController.text) != null;

                            // marca os campos vazios com erro para pintar a borda
                            setState(() {
                              if (_nomeEmpresaController.text.isEmpty) {
                                _camposComErro.add('nomeEmpresa');
                              }
                              if (_contatoController.text.isEmpty) {
                                _camposComErro.add('contato');
                              }
                              if (_logradouroController.text.isEmpty) {
                                _camposComErro.add('logradouro');
                              }
                              if (_numeroController.text.isEmpty) {
                                _camposComErro.add('numero');
                              }
                              if (_cidadeController.text.isEmpty) {
                                _camposComErro.add('cidade');
                              }
                              if (!escolheuInteresse) {
                                _camposComErro.add('interesse');
                              }
                              if (cpfCnpjInvalido) {
                                _camposComErro.add('cpfCnpj');
                              }
                          });

                          // coleta todos os campos vazios em ordem
                          final camposVazios = <({AnimationController shake, GlobalKey key})>[];

                          if (_nomeEmpresaController.text.isEmpty) {
                            camposVazios.add((shake: _shakeNomeEmpresa, key: _nomeEmpresaKey));
                          }
                          if (_contatoController.text.isEmpty) {
                            camposVazios.add((shake: _shakeContato, key: _contatoKey));
                          }
                          if (_logradouroController.text.isEmpty) {
                            camposVazios.add((shake: _shakeLogradouro, key: _logradouroKey));
                          }
                          if (_numeroController.text.isEmpty) {
                            camposVazios.add((shake: _shakeNumero, key: _numeroKey));
                          }
                          if (_cidadeController.text.isEmpty) {
                            camposVazios.add((shake: _shakeCidade, key: _cidadeKey));
                          }
                          if (!escolheuInteresse) {
                            camposVazios.add((shake: _shakeInteresse, key: _interesseKey));
                          }
                          if (cpfCnpjInvalido) {
                            camposVazios.add((shake: _shakeCpfCnpj, key: _cpfCnpjKey));
                          }

                          if (camposVazios.isNotEmpty) {
                            // rola até o primeiro campo vazio
                            await _shakeEScrollar(
                                camposVazios.first.shake, camposVazios.first.key);
                            // dispara shake em todos os outros campos vazios
                            for (final campo in camposVazios.skip(1)) {
                              campo.shake.forward(from: 0);
                            }
                          }
                        }
                      },
                      child: _salvando
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                      )

                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salvar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.check, size: 20),
                        ],
                      ),
                    )
                  ],
              ),
            ),
          ),
        ),
      )
    );
  }
}