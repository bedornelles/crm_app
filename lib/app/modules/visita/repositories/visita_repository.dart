import 'package:sqflite/sqflite.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/shared/repositories/base_repository.dart';
import 'package:crm_app/app/shared/repositories/table_repository_local.dart';

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
        data TEXT NOT NULL,
        nomeEmpresa TEXT NOT NULL,
        contato TEXT NOT NULL,
        cpfCnpj TEXT NOT NULL,
        email TEXT NOT NULL,
        telefone TEXT NOT NULL,
        logradouro TEXT NOT NULL,
        numero TEXT NOT NULL,
        cidade TEXT NOT NULL,
        complemento TEXT,
        sistemaAtual TEXT,
        valorPago TEXT NOT NULL,
        demonstrouInteresse INTEGER NOT NULL DEFAULT 0,
        observacoes TEXT,
        statusSincronizacao TEXT NOT NULL
      )
    ''');
  }
  @override
  VisitaEntity fromMap(Map<String, dynamic> e) => VisitaEntity(
    base: baseFromMap(e), // Função do TableRepositoryLocal que monta a BaseEntity com ID e Datas
    data: DateTime.parse(e['data']),
    nomeEmpresa: e['nomeEmpresa'],
    contato: e['contato'],
    cpfCnpj: e['cpfCnpj'],
    email: e['email'],
    telefone: e['telefone'],
    logradouro: e['logradouro'],
    numero: e['numero'],
    cidade: e['cidade'],
    complemento: e['complemento'],
    sistemaAtual: e['sistemaAtual'],
    valorPago: e['valorPago'],
    demonstrouInteresse: (e['demonstrouInteresse'] ?? 0) == 1,
    observacoes: e['observacoes'],
    statusSincronizacao: e['statusSincronizacao'],
  );

  @override
  Map<String, dynamic> toMap(VisitaEntity entity) => {
    getIdColumnName: entity.base.id,
    BaseRepositoryLocal.dataHoraCriado: entity.base.dataHoraCriado?.toIso8601String(),
    BaseRepositoryLocal.dataHoraUltimaAlteracao: entity.base.dataHoraUltimaAlteracao?.toIso8601String(),
    BaseRepositoryLocal.dataHoraDeletado: entity.base.dataHoraDeletado?.toIso8601String(),
    'data': entity.data.toIso8601String(),
    'nomeEmpresa': entity.nomeEmpresa,
    'contato': entity.contato,
    'cpfCnpj': entity.cpfCnpj,
    'email': entity.email,
    'telefone': entity.telefone,
    'logradouro': entity.logradouro,
    'numero': entity.numero,
    'cidade': entity.cidade,
    'complemento': entity.complemento,
    'sistemaAtual': entity.sistemaAtual,
    'valorPago': entity.valorPago,
    'demonstrouInteresse': entity.demonstrouInteresse ? 1 : 0,
    'observacoes': entity.observacoes,
    'statusSincronizacao': entity.statusSincronizacao,
  };

  @override
  void validate(VisitaEntity entity) {
    // Regras de validação antes de inserir no banco, se necessário
  }

  @override
  void dispose() {}
}