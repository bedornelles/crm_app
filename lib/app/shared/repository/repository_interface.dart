import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';

/// Interface base para repositórios de entidades.
///
/// Define operações CRUD (Create, Read, Update, Delete) e métodos para manipulação
/// de entidades em banco de dados local, incluindo suporte a transações.
/// Deve ser implementada por todos os repositórios da aplicação.
abstract class IRepository<T extends IBaseEntity> implements Disposable {
  /// Retorna todos os registros, podendo filtrar por deletados.
  Future<List<T>> getAll({bool deleted = false, Transaction? txn});

  /// Busca um registro pelo ID.
  Future<T?> getById(String id, {bool deleted = false});

  /// Retorna o primeiro registro encontrado.
  Future<T?> getFirst({Transaction? txn});

  /// Salva uma nova entidade.
  Future<void> save(T entity);

  /// Atualiza uma entidade existente.
  Future<void> update(T entity);

  /// Deleta (lógica ou fisicamente) uma entidade.
  Future<void> delete(T entity);

  /// Salva uma entidade dentro de uma transação.
  Future<void> saveInTransaction(T entity, Transaction txn);

  /// Atualiza uma entidade dentro de uma transação.
  Future<void> updateInTransaction(T entity, Transaction txn);
}