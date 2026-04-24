import 'package:pkg_flutter_utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crm_app/app/shared/database/database_local.dart';
import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';

/// Classe base abstrata para repositórios locais.
///
/// Define operações comuns para manipulação de entidades no banco de dados local,
/// como criação de tabelas, deleção lógica e conversão de mapas para entidades.
/// Deve ser estendida por repositórios específicos de cada entidade.
abstract class BaseRepositoryLocal<T extends IBaseEntity> {
  static const dataHoraCriado = 'data_hora_criado';
  static const dataHoraDeletado = 'data_hora_deletado';
  static const dataHoraUltimaAlteracao = 'data_hora_ultima_alteracao';

  /// Nome da tabela no banco de dados.
  String get getTableName;

  /// Nome da coluna de ID da tabela.
  String get getIdColumnName => "id_$getTableName";

  /// Cria a tabela no banco de dados utilizando batch.
  void create(Batch batch);

  /// Converte um mapa do banco de dados para uma entidade base.
  BaseEntity baseFromMap(Map<String, dynamic> e) {
    return BaseEntity(
      id: e[getIdColumnName],
      dataHoraCriado: DateTimeUtils.parseIfNotNull(e[dataHoraCriado]),
      dataHoraDeletado: DateTimeUtils.parseIfNotNull(e[dataHoraDeletado]),
      dataHoraUltimaAlteracao: DateTimeUtils.parseIfNotNull(e[dataHoraUltimaAlteracao]),
    );
  }

  /// Valida a entidade antes de operações de banco.
  void validate(T entity);

  /// Realiza deleção lógica da entidade no banco de dados.
  Future delete(T entity) async {
    var db = await DatabaseLocal().getDb();
    try {
      return await db.update(
        getTableName,
        {
          dataHoraDeletado: entity.base.dataHoraDeletado!.toIso8601String(),
        },
        where: "$getIdColumnName = ?",
        whereArgs: [entity.base.id],
      );
    } on DatabaseException catch (_) {
      rethrow;
    }
  }

  /// Realiza deleção lógica da entidade dentro de uma transação.
  Future deleteInTransaction(T entity, Transaction txn) async {
    try {
      return await txn.update(
        getTableName,
        {
          dataHoraDeletado: entity.base.dataHoraDeletado!.toIso8601String(),
        },
        where: "$getIdColumnName = ?",
        whereArgs: [entity.base.id],
      );
    } on DatabaseException catch (_) {
      rethrow;
    }
  }
}