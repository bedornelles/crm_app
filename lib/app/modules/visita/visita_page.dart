
import 'package:crm_app/app/modules/visita/visita_controller.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Controla o que o teclado pode digitar
import 'package:brasil_fields/brasil_fields.dart';

class VisitaPage extends StatefulWidget{

  const VisitaPage({super.key});

  @override
  State<VisitaPage> createState() => _VisitaPageState();
}

class _VisitaPageState extends State<VisitaPage> {
  final controller = Modular.get<VisitaController>();

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
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  keyboardType: TextInputType.number,//puxa o teclado numerico, mas nao bloqueia a opção de colar texto ou digitar eltras em um teclado fisico
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,//permite apenas a entrada de numeros
                    CpfOuCnpjFormatter(),
                  ],
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    hintText: 'emailEmpresa@example.com',
                  ),
                ),

              ],
          )
        ),
      ),

    );
  }
}