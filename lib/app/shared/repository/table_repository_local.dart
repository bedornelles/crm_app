import 'dart:async';

import 'package:pkg_flutter_utils/extensions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crm_app/app/shared/database/database_local.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';
import 'package:crm_app/app/shared/repositories/base_repository.dart';
import 'package:crm_app/app/shared/repositories/repository_interface.dart';


/// Classe abstrata que implementa um repositório local de tabela.
///
/// Fornece métodos genéricos para salvar, atualizar, buscar e converter entidades
/// do banco de dados local. Utiliza o padrão Repository para facilitar a manutenção
/// e reutilização de código entre diferentes entidades.
/// Deve ser estendida por repositórios concretos.
abstract class TableRepositoryLocal<T extends IBaseEntity> extends BaseRepositoryLocal<T> implements IRepository<T> {
  /// Converte uma entidade para um mapa (para salvar no banco).
  Map<String, dynamic> toMap(T entity);

  /// Converte um mapa do banco para uma entidade.
  T fromMap(Map<String, dynamic> e);

  @override
  Future<int?> save(T entity) async {
    try {
      validate(entity);

      var values = toMap(entity);
      values.putIfAbsent(
        BaseRepositoryLocal.dataHoraCriado,
            () => entity.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
      );

      var db = await DatabaseLocal().getDb();

      return await db.insert(getTableName, values);
    } on DatabaseException catch (e) {
      if (e.getResultCode() == 2067) {
        throw Exception('Existe dado já cadastrado.');
      }

      rethrow;
    }
  }

  @override
  Future update(T entity) async {
    try {
      if (entity.base.isDeleted) return delete(entity);

      validate(entity);

      var values = toMap(entity);
      values.putIfAbsent(
        BaseRepositoryLocal.dataHoraUltimaAlteracao,
            () => DateTime.now().toIso8601String(),
      );
      if (entity.base.dataHoraCriado != null) {
        values.putIfAbsent(BaseRepositoryLocal.dataHoraCriado, () => entity.base.dataHoraCriado!.toIso8601String());
      }

      var db = await DatabaseLocal().getDb();

      var retorno = await db.update(getTableName, values, where: "$getIdColumnName = ?", whereArgs: [entity.base.id]);

      if (retorno == 0) throw Exception("Nenhum registro atualizado");

      return retorno;
    } on DatabaseException catch (_) {
      rethrow;
    }
  }

  @override
  Future<int> saveInTransaction(T entity, Transaction txn) async {
    try {
      validate(entity);

      var values = toMap(entity);
      values.putIfAbsent(BaseRepositoryLocal.dataHoraCriado, () => DateTime.now().toIso8601String());

      return await txn.insert(getTableName, values);
    } on DatabaseException catch (e) {
      if (e.getResultCode() == 2067) {
        throw Exception('Existe dado já cadastrado.');
      }

      rethrow;
    }
  }

  @override
  Future<void> updateInTransaction(T? entity, Transaction txn) async {
    try {
      if (entity!.base.isDeleted) return deleteInTransaction(entity, txn);

      validate(entity);

      var values = toMap(entity);
      values.putIfAbsent(BaseRepositoryLocal.dataHoraUltimaAlteracao, () => DateTime.now().toIso8601String());

      var retorno = await txn.update(getTableName, values, where: "$getIdColumnName = ?", whereArgs: [entity.base.id]);

      if (retorno == 0) throw Exception("Nenhum registro atualizado");
    } on DatabaseException catch (_) {
      rethrow;
    }
  }

  /// [db] Transação que será utilizada. Passar NULL para usar database padrão.
  @override
  Future<T?> getById(String id, {bool deleted = false}) async {
    final itens = await getFull(id: id, deleted: deleted);

    return itens.firstOrNull;
  }

  @override
  Future<T?> getFirst({Transaction? txn}) async => await getAll(txn: txn).then((value) => value.firstOrNull);

  @override
  Future<List<T>> getAll({bool deleted = false, Transaction? txn}) async => getFull(deleted: deleted, txn: txn);

  /// Busca registros completos com filtros opcionais.
  Future<List<T>> getFull({String? id, String where = '', List<dynamic>? whereArgs, String? orderBy, bool deleted = false, Transaction? txn}) async {
    var db = txn ?? await DatabaseLocal().getDb();

    List<String> whereListed = [];
    whereArgs ??= [];

    if (notIsNullOrWhiteSpace(where)) {
      whereListed.add(where);
    }

    if (!deleted) {
      whereListed.add('${BaseRepositoryLocal.dataHoraDeletado} IS NULL');
    }

    if (id != null) {
      whereListed.add('$getIdColumnName = ?');
      whereArgs.add(id);
    }

    var results = await db.query(getTableName, where: whereListed.isEmpty ? null : whereListed.join(' AND '), whereArgs: whereArgs, orderBy: orderBy);

    var list = results.map((e) => fromMap(e)).toList();

    return list;
  }
}