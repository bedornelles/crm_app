// Interface base para serviços de entidades.

// Define operações genéricas para manipulação de entidades, como listar, buscar, salvar/atualizar e deletar.
// Deve ser implementada por todos os serviços da aplicação.
abstract class IService<T> {
  // Retorna todos os registros, podendo filtrar por deletados.
  Future<List<T>> getAll({bool deleted = false});

  // Retorna o primeiro registro encontrado.
  Future<T?> getFirst();

  // Salva ou atualiza uma entidade.
  Future<T> saveOrUpdate(T entity, {String? uri});

  // Deleta (lógica ou fisicamente) uma entidade.
  Future<void> delete(T? entity, {String? uri});

  // Busca uma entidade pelo ID.
  Future<T?> getById(String id, {bool deleted = false});
}