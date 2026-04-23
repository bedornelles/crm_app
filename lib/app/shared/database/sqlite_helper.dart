import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteHelper {
  // Padrão Singleton para garantir apenas uma conexão aberta
  SqliteHelper._();
  static final SqliteHelper instance = SqliteHelper._();

  static Database? _database;

  // Função que entrega o banco de dados pronto para uso
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Função que encontra a pasta do celular e abre o arquivo
  Future<Database> _initDatabase() async {
    // Pega o caminho padrão de bancos de dados do Android/iOS
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'crm_app.db'); // Nome do seu arquivo

    return await openDatabase(
      path,
      version: 1, // Se mudarmos a tabela no futuro, aumentamos a versão
      onCreate: _onCreate,
    );
  }

  // O GATILHO: Roda apenas uma vez quando o banco é criado
  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE visitas (
      id TEXT PRIMARY KEY,
      data TEXT,
      nomeEmpresa TEXT,
      contato TEXT,
      cpfCnpj TEXT,
      email TEXT,
      telefone TEXT,
      logradouro TEXT,
      numero TEXT,
      cidade TEXT,
      complemento TEXT,
      sistemaAtual TEXT,
      valorPago TEXT,
      demonstrouInteresse INTEGER,
      observacoes TEXT
      )
    ''');

  }
}