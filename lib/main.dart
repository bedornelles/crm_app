import 'dart:async';
import 'dart:io';

import 'package:crm_app/app/app_widget.dart';
import 'package:crm_app/app/modules/sincronizacao/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app_module.dart';
import 'app/shared/cache/cache.dart';
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

    await DatabaseLocal().getDb();

    final cache = await Cache.criar();

    runApp(
      ModularApp(
          module: AppModule(cache),
          child: const AppWidget()
      ),
    );
  }, (error, stack){
    debugPrintStack(label: error.toString(), stackTrace: stack);
  });

}