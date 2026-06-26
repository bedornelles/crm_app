import 'dart:async';
import 'dart:io';

import 'package:crm_app/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app_module.dart';
import 'app/shared/database/database_local.dart';

/// Função principal da aplicação.
///
/// Inicializa o ambiente Flutter, configura o banco de dados local (incluindo suporte para Windows),
/// e executa o aplicativo utilizando o Modular para gerenciamento de rotas e dependências.
/// Também captura e exibe erros não tratados.

void main() {
  runZonedGuarded(()async{
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isWindows) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
    }

    await DatabaseLocal().getDb();

    runApp(
      ModularApp(
          module: AppModule(),
          child: const AppWidget()
      ),
    );
  }, (error, stack){
    debugPrintStack(label: error.toString(), stackTrace: stack);
  });

}