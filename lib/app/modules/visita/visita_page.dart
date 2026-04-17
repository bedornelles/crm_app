
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
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

class _VisitaPageState extends State<VisitaPage> {
  final controller = Modular.get<VisitaController>();

  final _formKey = GlobalKey<FormState>();

  //controler do campo de telefone
  final _telefoneController = TextEditingController();
  //controller do campo de cfp/cnpj
  final _cpfCnpjController = TextEditingController();
  // controller do campo de valor pago
  final _valorPagoController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: (){},
          ),
        ],
      ),

      body: SingleChildScrollView(
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
                        controller.setDataDaVisita(novaData);
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

                  TextFormField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: 'Lancheria do centro'
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

                  TextFormField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: 'João da Silva'
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

                  TextFormField(
                    controller: _cpfCnpjController, //controller conectada
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    keyboardType: TextInputType.number,//puxa o teclado numerico, mas nao bloqueia a opção de colar texto ou digitar eltras em um teclado fisico
                    inputFormatters: [
                      InputMasked.cnpjCpf(value: _cpfCnpjController.text),
                    ],
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: '00.000.000/0000-00'
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
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'emailEmpresa@example.com',
                    ),
                    validator: (value){
                      final erroVazio = InputValidator.required(value);
                      if (erroVazio != null) return erroVazio;

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
                    validator: InputValidator.required,
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

                  TextFormField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: 'Av Barão do Rio Branco, centro',
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

                  TextFormField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: '1234',
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

                  TextFormField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    validator: InputValidator.required,
                    decoration: const InputDecoration(
                      hintText: 'São Paulo/SP',
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

                  Observer(
                    builder: (_){
                      return Row(
                        children: [

                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical:14),
                                backgroundColor: controller.demonstrouInteresse == true
                                    ?theme.colorScheme.primary
                                    :Colors.white,
                                foregroundColor: controller.demonstrouInteresse == true
                                    ? Colors.white
                                    : theme.colorScheme.secondary,
                                elevation: 0,
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              onPressed: () => controller.setDemonstrouInteresse(true),
                              icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                              label: const Text ('Sim', style: TextStyle(fontSize: 15)),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: controller.demonstrouInteresse == false
                                    ? theme.colorScheme.primary
                                    : Colors.white,
                                foregroundColor: controller.demonstrouInteresse == false
                                    ? Colors.white
                                    : theme.colorScheme.secondary,
                                elevation: 0,
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => controller.setDemonstrouInteresse(false),
                              icon: const Icon(Icons.thumb_down_alt_outlined, size: 20),
                              label: const Text ('Não', style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      );
                    },
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
                    maxLines: 4,
                    maxLength: 1500,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: (){
                      //validação
                      bool estaValido = _formKey.currentState!.validate();
                      bool escolheuInteresse = controller.demonstrouInteresse != null;
                      if (estaValido && escolheuInteresse) {
                        print('Tudo certo!');
                      } else{
                        print('tem erro no forumalairo');
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
}