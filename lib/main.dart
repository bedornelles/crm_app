import 'dart:async';
import 'dart:io';

import 'package:crm_app/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app_module.dart';
import 'app/shared/database/database_local.dart';

void main() {

  // O runZonedGuarded cria um "escudo" no app.
  // Se qualquer erro acontecer e não for tratado, ele cai no segundo bloco (error, stack).
  runZonedGuarded(()async{
    WidgetsFlutterBinding.ensureInitialized();


    if (Platform.isWindows) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
    }

    //inicializa o banco de dados local sqlite
    await DatabaseLocal().getDb();

    runApp(
      ModularApp(
          module: AppModule(),
          child: const AppWidget()
      ),
    );
  }, (error, stack){
    //se o app crashar ele imprime o erro aqui
    debugPrintStack(label: error.toString(), stackTrace: stack);
  });

}