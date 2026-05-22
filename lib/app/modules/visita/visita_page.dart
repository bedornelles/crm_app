
import 'dart:math';
import 'package:crm_app/app/modules/home/home_controller.dart';
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Controla o que o teclado pode digitar
import 'package:pkg_flutter_utils/masked.dart'; //pacote cervantes
import 'package:pkg_flutter_utils/validators.dart'; //pacote cervantes
import 'package:flutter_mobx/flutter_mobx.dart';

class VisitaPage extends StatefulWidget{

  const VisitaPage({super.key});

  @override
  State<VisitaPage> createState() => _VisitaPageState();
}

class _VisitaPageState extends State<VisitaPage> with TickerProviderStateMixin{

  final controller = Modular.get<VisitaController>();
  final _formKey = GlobalKey<FormState>();

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

  //controlador da animação "shake"
  late AnimationController _shakeNomeEmpresa;
  late AnimationController _shakeContato;
  late AnimationController _shakeLogradouro;
  late AnimationController _shakeNumero;
  late AnimationController _shakeCidade;
  late AnimationController _shakeInteresse;
  late AnimationController _shakeCpfCnpj;


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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visita'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'identificar_id'){
                await Modular.to.pushNamed('/visita/identificarId');
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

                  //cria o input de data/hora
                  DateTimeFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_month_rounded,
                        color: theme.colorScheme.secondary,
                      )
                    ),
                    //input ja "nasce" com data e hora atual
                    initialValue: DateTime.now(),
                    //faz abrir o calendario e depois o relogio
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    //faz o texto ficar no formato br (dep. INTL)
                    dateFormat: DateFormat('dd/MM/yyyy HH:mm'),
                    //salva a data e hora selecionada na variavel 'novaData'
                    onDateSelected: (DateTime? novaData){
                      //verifica se o user seleionou alguma coisa
                      if (novaData != null) {
                        //envia para controller guardar Mobx
                        controller.visita.dataVisita = novaData;
                      }
                    }
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Nome da empresa',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),


                  KeyedSubtree(
                    key: _nomeEmpresaKey,
                    child: _buildShakeField(
                      animationController: _shakeNomeEmpresa,
                      child: TextFormField(
                        controller: _nomeEmpresaController,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        validator: InputValidator.required,
                        onChanged: (_) {
                          if (_camposComErro.contains('nomeEmpresa')) {
                            setState(() => _camposComErro.remove('nomeEmpresa'));
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Lancheria do centro',
                          border: _camposComErro.contains('nomeEmpresa')
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
                              )
                              :null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Contato na empresa',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                    KeyedSubtree(
                      key: _contatoKey,
                      child: _buildShakeField(
                        animationController: _shakeContato,
                        child: TextFormField(
                        controller: _contatoController,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        validator: InputValidator.required,
                          onChanged: (_) {
                            if (_camposComErro.contains('contato')) {
                              setState(() => _camposComErro.remove('contato'));
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'João da Silva',
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

                  Text(
                    'CPF/CNPJ da empresa',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary
                    ),
                  ),

                  const SizedBox(height: 8),


                  KeyedSubtree(
                    key: _cpfCnpjKey,
                    child: _buildShakeField(
                      animationController: _shakeCpfCnpj,
                      child:TextFormField(
                          controller: _cpfCnpjController, //controller conectada
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                          keyboardType: TextInputType.number,//puxa o teclado numerico, mas nao bloqueia a opção de colar texto ou digitar eltras em um teclado fisico
                          inputFormatters: [
                            InputMasked.cnpjCpf(value: _cpfCnpjController.text),
                          ],
                          onChanged: (_) {
                            // remove o erro de borda quando o usuário digita
                            if (_camposComErro.contains('cpfCnpj')) {
                              setState(() => _camposComErro.remove('cpfCnpj'));
                            }
                          },
                          validator: (value) => InputValidator(
                            [CnpjCpfValidator()],
                          ).validate(value),
                          decoration: InputDecoration(
                              hintText: '00.000.000/0000-00',
                              border: _camposComErro.contains('cpfCnpj')
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

                  Text(
                    'E-mail da empresa',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'emailEmpresa@example.com',
                    ),
                    validator: (value){
                      final emailValido = EmailValidator.validate(value);
                      if(!emailValido) return 'Digite um E-mail válido';

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Telefone',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    //conectando a controller criada no topo da pag.
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    //aplicando a mascara
                    inputFormatters: [
                      InputMasked.fone(value: _telefoneController.text),
                    ],
                    //aplicando a valuidação
                    decoration: const InputDecoration(
                        hintText: '(51) 9 9999-990099'
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Logradouro',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  KeyedSubtree(
                    key: _logradouroKey,
                    child: _buildShakeField(
                      animationController: _shakeLogradouro,
                      child: TextFormField(
                        controller: _logradouroController,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        validator: InputValidator.required,
                        onChanged: (_) {
                          if (_camposComErro.contains('logradouro')) {
                            setState(() => _camposComErro.remove('logradouro'));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Av Barão do Rio Branco, centro',
                          border: _camposComErro.contains('logradouro')
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

                  Text(
                    'Número',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  KeyedSubtree(
                    key: _numeroKey,
                    child: _buildShakeField(
                      animationController: _shakeNumero,
                      child: TextFormField(
                        controller: _numeroController,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400
                        ),
                        validator: InputValidator.required,
                        onChanged: (_) {
                          if (_camposComErro.contains('numero')) {
                            setState(() => _camposComErro.remove('numero'));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: '1234',
                          border: _camposComErro.contains('numero')
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

                  Text(
                    'Cidade',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  KeyedSubtree(
                    key: _cidadeKey,
                    child: _buildShakeField(
                      animationController: _shakeCidade,
                      child: TextFormField(
                        controller: _cidadeController,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        validator: InputValidator.required,
                        onChanged: (_) {
                          if (_camposComErro.contains('cidade')) {
                            setState(() => _camposComErro.remove('cidade'));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'São Paulo/SP',
                          border: _camposComErro.contains('cidade')
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

                  Text(
                    'Complemento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _complementoController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Sala 01, Ap 01, Perto de...',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Sistema atual',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _sistemaController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'ERP Xyz',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Valor Pago',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _valorPagoController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      // se o texto esta vazio passa null. se nao passa o texto. inserido pois o app quebra se o valor estiver vazio
                      InputMasked.currency(
                        value: _valorPagoController.text.isEmpty ? null : _valorPagoController.text,
                      ),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'R\$ 99,90',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Demonstrou interesse?',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary
                    ),
                  ),

                  const SizedBox(height: 8),

                  KeyedSubtree(
                    key: _interesseKey,
                    child: _buildShakeField(
                      animationController: _shakeInteresse,
                      child: Row(
                        children: [
                          Expanded(
                            child: Observer(
                              builder: (_) => ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: controller.visita.demonstrouInteresse == true
                                      ? theme.colorScheme.primary
                                      : Colors.white,
                                  foregroundColor: controller.visita.demonstrouInteresse == true
                                      ? Colors.white
                                      : theme.colorScheme.secondary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // borda vermelha individual no botão Sim
                                    side: _camposComErro.contains('interesse')
                                        ? BorderSide(color: Colors.red.shade600, width: 1.5)
                                        : BorderSide.none,
                                  ),
                                ),
                                onPressed: () {
                                  controller.visita.demonstrouInteresse = true;
                                  if (_camposComErro.contains('interesse')) {
                                    setState(() => _camposComErro.remove('interesse'));
                                  }
                                },
                                icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                                label: const Text('Sim', style: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Observer(
                              builder: (_) => ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: controller.visita.demonstrouInteresse == false
                                      ? theme.colorScheme.primary
                                      : Colors.white,
                                  foregroundColor: controller.visita.demonstrouInteresse == false
                                      ? Colors.white
                                      : theme.colorScheme.secondary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // borda vermelha individual no botão Não
                                    side: _camposComErro.contains('interesse')
                                        ? BorderSide(color: Colors.red.shade600, width: 1.5)
                                        : BorderSide.none,
                                  ),
                                ),
                                onPressed: () {
                                  controller.visita.demonstrouInteresse = false;
                                  if (_camposComErro.contains('interesse')) {
                                    setState(() => _camposComErro.remove('interesse'));
                                  }
                                },
                                icon: const Icon(Icons.thumb_down_alt_outlined, size: 20),
                                label: const Text('Não', style: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ),

                  const SizedBox(width: 16),

                  Text(
                    'Observações',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _observacoesController,
                    maxLines: 4,
                    maxLength: 1500,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () async {
                      bool estaValido = _formKey.currentState!.validate();
                      bool escolheuInteresse = controller.visita.demonstrouInteresse != null;

                      //validação
                      if (estaValido && escolheuInteresse) {
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
                          await homeController.load();
                          Modular.to.pop(visita);
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

                    child: const Row(
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
    );
  }

  Widget _buildShakeField({
    required AnimationController animationController,
    required Widget child,
  }) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child){
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