
import 'package:sqflite/sqflite.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/shared/repository/base_repository.dart';
import 'package:crm_app/app/shared/repository/table_repository_local.dart';
import 'package:crm_app/app/shared/database/database_local.dart';
import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';

class VisitaRepositoryLocal extends TableRepositoryLocal<VisitaEntity> implements IVisitaRepository {

  @override
  String get getTableName => 'visitas';

  @override
  void create(Batch batch) {
    // Aqui usamos as variáveis da classe pai para criar as colunas de controle do padrão base
    batch.execute('''
      CREATE TABLE IF NOT EXISTS $getTableName (
        $getIdColumnName TEXT PRIMARY KEY,
      ${BaseRepositoryLocal.dataHoraCriado} TEXT,
      ${BaseRepositoryLocal.dataHoraUltimaAlteracao} TEXT,
      ${BaseRepositoryLocal.dataHoraDeletado} TEXT,
      data_visita TEXT NOT NULL,
      nome_empresa TEXT NOT NULL,
      nome_contato_empresa TEXT NOT NULL,
      cpf_cnpj_empresa TEXT,
      email_empresa TEXT,
      telefone_empresa TEXT,
      logradouro_empresa TEXT NOT NULL,
      numero_empresa TEXT NOT NULL,
      cidade_empresa TEXT NOT NULL,
      complemento_empresa TEXT,
      sistema_atual TEXT,
      valor_pago TEXT NOT NULL,
      demonstrou_interesse INTEGER NOT NULL DEFAULT 0,
      observacoes TEXT,
      id_usuario TEXT NOT NULL,
      identificador_empresa INTEGER,
      status_sincronizacao TEXT NOT NULL,
      erro_sincronizacao TEXT
      )
    ''');
  }
  @override
  VisitaEntity fromMap(Map<String, dynamic> e) => VisitaEntity(
    base: baseFromMap(e), // Função do TableRepositoryLocal que monta a BaseEntity com ID e Datas
    dataVisita: DateTime.parse(e['data_visita']),
    nomeEmpresa: e['nome_empresa'] ?? '',
    nomeContatoEmpresa: e['nome_contato_empresa'] ?? '',
    cpfCnpjEmpresa: e['cpf_cnpj_empresa'],
    emailEmpresa: e['email_empresa'],
    telefoneEmpresa: e['telefone_empresa'],
    logradouroEmpresa: e['logradouro_empresa'] ?? '',
    numeroEmpresa: e['numero_empresa'] ?? '',
    cidadeEmpresa: e['cidade_empresa'] ?? '',
    complementoEmpresa: e['complemento_empresa'],
    sistemaAtual: e['sistema_atual'],
    valorPago: e['valor_pago'] ?? '',
    demonstrouInteresse: (e['demonstrou_interesse'] ?? 0) == 1,
    observacoes: e['observacoes'],
    statusSincronizacao: StatusSincronizacao.fromValor(
      e['status_sincronizacao'] ?? 'PENDENTE',
    ),
    erroSincronizacao: e['erro_sincronizacao'],
    idUsuario: e['id_usuario'],
    identificadorEmpresa: e['identificador_empresa'] != null
        ? int.tryParse(e['identificador_empresa'].toString())
        : null,
  );

  @override
  Map<String, dynamic> toMap(VisitaEntity entity) => {
    getIdColumnName: entity.base.id,
    BaseRepositoryLocal.dataHoraCriado: entity.base.dataHoraCriado?.toIso8601String(),
    BaseRepositoryLocal.dataHoraUltimaAlteracao: entity.base.dataHoraUltimaAlteracao?.toIso8601String(),
    BaseRepositoryLocal.dataHoraDeletado: entity.base.dataHoraDeletado?.toIso8601String(),
    'data_visita': entity.dataVisita.toIso8601String(),
    'nome_empresa': entity.nomeEmpresa,
    'nome_contato_empresa': entity.nomeContatoEmpresa,
    'cpf_cnpj_empresa': entity.cpfCnpjEmpresa,
    'email_empresa': entity.emailEmpresa,
    'telefone_empresa': entity.telefoneEmpresa,
    'logradouro_empresa': entity.logradouroEmpresa,
    'numero_empresa': entity.numeroEmpresa,
    'cidade_empresa': entity.cidadeEmpresa,
    'complemento_empresa': entity.complementoEmpresa,
    'sistema_atual': entity.sistemaAtual,
    'valor_pago': entity.valorPago,
    'demonstrou_interesse': entity.demonstrouInteresse ? 1 : 0,
    'observacoes': entity.observacoes,
    'id_usuario': entity.idUsuario,
    'identificador_empresa': entity.identificadorEmpresa,
    'status_sincronizacao': entity.statusSincronizacao.valor,
    'erro_sincronizacao': entity.erroSincronizacao,
  };

  @override
  void validate(VisitaEntity entity) {
    // Regras de validação antes de inserir no banco, se necessário
  }

  @override
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario) async {
    return getFull(
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'data_visita DESC'
    );
  }

  @override
  Future<List<VisitaEntity>> getAllNaoSincronizadas () async {
    return getFull(
      where: 'status_sincronizacao = ? OR status_sincronizacao = ?',
      whereArgs: [
        StatusSincronizacao.pendente.valor,
        StatusSincronizacao.erro.valor,
      ],
    );
  }

  @override
  Future<void> marcarComoSincronizada(String id) async {
    final db = await DatabaseLocal().getDb();
    await db.update(
      getTableName,
      {'status_sincronizacao': StatusSincronizacao.sincronizado.valor},
      where: '$getIdColumnName = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> marcarComoErro(String id, String mensagemErro) async {
    final db = await DatabaseLocal().getDb();
    await db.update(
      getTableName,
      {
        'status_sincronizacao': StatusSincronizacao.erro.valor,
        'erro_sincronizacao': mensagemErro,
      },
      where: '$getIdColumnName = ?',
        whereArgs: [id],
    );
  }

  @override
  void dispose() {}
}