import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository.dart';

/// Classe responsável por gerenciar o banco de dados local SQLite da aplicação.
///
/// Implementa o padrão singleton para garantir uma única instância do banco.
/// Realiza a criação, configuração, abertura, atualização e fechamento do banco.
/// Utiliza o pacote `sqflite` para operações e suporta transações seguras com lock.
class DatabaseLocal {
  final String _nameDb = 'crm_app.db';
  final int _versionDb = 1;
  final _lock = Lock();
  static Database? _db;

  DatabaseLocal();

  // Metodo chamado na criação do banco de dados.
  // Utiliza batch para criar as tabelas necessárias.
  void _onCreate(Database db, int version) async {
    var batch = db.batch();

    //delega a criaçao da tabla para o repo de visita
    VisitaRepositoryLocal().create(batch);

    await batch.commit();
  }

  //metodo chamado ao abrir o banco
  _onOpen (Database db) async {
    print('db version ${await db.getVersion()}');
  }

  // Metodo chamado ao atualizar a versão do banco de dados.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // Configuração executada antes de abrir o banco de dados.
  // Desativa as chaves estrangeiras temporariamente.
  _onConfigureBeforeOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = OFF");
  }

  // Configuração executada após abrir o banco de dados.
  // Ativa as chaves estrangeiras.
  _onConfigureAfterOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  // Retorna o caminho completo do arquivo do banco de dados.
  // Cria o diretório se necessário.
  Future<String> getPath() async {
    var databasesPath = '';
    var path = '';
    if (Platform.isIOS) {
      databasesPath = (await getApplicationSupportDirectory()).path;
    } else {
      databasesPath = await getDatabasesPath();
    }

    path = join(databasesPath, _nameDb);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (ex) {
      print('Erro ao criar diretório: $ex');
    }

    return path;
  }

  // Garante thread safety utilizando lock.
  Future<Database> getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Verifica novamente dentro do lock para ter 100% de certeza
        if (_db == null) {
          _db = await openDatabase(
            await getPath(),
            version: _versionDb,
            onCreate: _onCreate,
            onConfigure: _onConfigureBeforeOpenDatabase,
            onOpen: _onOpen,
            onUpgrade: _onUpgrade,
          );
          await _onConfigureAfterOpenDatabase(_db!);
        }
      });
    }
    return _db!;
  }

  // Fecha a instância do banco de dados e libera recursos.
  Future<void> closeDb() async {
    await _db?.close();
    _db = null;
  }

}
