import 'package:crm_app/app/shared/entity/base_entity_interface.dart';
import 'package:crm_app/app/shared/repository/repository_interface.dart';
import 'package:crm_app/app/shared/service/base_service_interface.dart';

// Serviço base genérico para operações de entidades.
//
// Implementa operações comuns como salvar, atualizar, buscar, listar e deletar entidades.
// Utiliza um repositório para persistência dos dados.
//
// Toda a lógica de negócio genérica deve ser colocada aqui para reutilização.
// Os serviços específicos podem estender essa classe para adicionar funcionalidades específicas.

class BaseService<T extends IBaseEntity, Y extends IRepository<T>> implements IService<T> {
  // Instância do repositório utilizado pelo serviço.
  final Y repository;

  // Construtor que recebe o repositório.
  BaseService(this.repository);

  // Salva ou atualiza uma entidade.
  // Se a entidade não existir, salva; caso contrário, atualiza.
  @override
  Future<T> saveOrUpdate(T entity, {String? uri}) async {
    // aqui que garante a data de criação antes de salvar!
    if (entity.base.isNew) {
      entity.base.setDataHoraCriado();
    }

    if ((await repository.getById(entity.base.id)) == null) {
      await repository.save(entity);
    } else {
      await repository.update(entity);
    }

    return entity;
  }

  // Retorna o primeiro registro encontrado.
  @override
  Future<T?> getFirst() async => await repository.getFirst();

  // Retorna todos os registros, podendo filtrar por deletados.
  @override
  Future<List<T>> getAll({bool deleted = false}) async => await repository.getAll(deleted: deleted);

  // Busca uma entidade pelo ID.
  @override
  Future<T?> getById(String id, {bool deleted = false}) async {
    return await repository.getById(id, deleted: deleted);
  }

  // Realiza a deleção lógica da entidade.
  // Se a entidade não existir, salva como deletada.
  @override
  Future<void> delete(T? entity, {String? uri}) async {
    entity!.base.dataHoraDeletado = DateTime.now();

    if ((await repository.getById(entity.base.id)) == null) {
      await saveOrUpdate(entity);
      return;
    }

    await repository.delete(entity);
  }
}