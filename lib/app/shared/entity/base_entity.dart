import 'package:uuid/uuid.dart';

/// Entidade base para todas as entidades do sistema.
///
/// Contém campos comuns como identificador, datas de criação, deleção e última alteração.
/// Fornece métodos utilitários para manipulação e conversão da entidade.
class BaseEntity {
  /// Identificador único da entidade.
  String id;

  /// Data e hora em que a entidade foi criada.
  DateTime? dataHoraCriado;

  /// Data e hora em que a entidade foi deletada (deleção lógica).
  DateTime? dataHoraDeletado;

  /// Data e hora da última alteração realizada na entidade.
  DateTime? dataHoraUltimaAlteracao;

  /// Construtor padrão da entidade base.
  BaseEntity({
    required this.id,
    this.dataHoraCriado,
    this.dataHoraDeletado,
    this.dataHoraUltimaAlteracao,
  });

  /// Cria uma nova instância de [BaseEntity] com um novo UUID.
  factory BaseEntity.novo() => BaseEntity(id: const Uuid().v4());

  /// Cria uma instância de [BaseEntity] a partir de um mapa.
  factory BaseEntity.fromMap(Map<String, dynamic> map) {
    return BaseEntity(
      id: map['id'],
      dataHoraCriado: map['dataHoraCriado'] != null ? DateTime.parse(map['dataHoraCriado']) : null,
      dataHoraUltimaAlteracao: map['dataHoraUltimaAlteracao'] != null ? DateTime.parse(map['dataHoraUltimaAlteracao']) : null,
      dataHoraDeletado: map['dataHoraDeletado'] != null ? DateTime.parse(map['dataHoraDeletado']) : null,
    );
  }

  /// Retorna verdadeiro se a entidade está deletada logicamente.
  bool get isDeleted => dataHoraDeletado != null;

  /// Retorna verdadeiro se a entidade ainda não foi persistida (nova).
  bool get isNew => dataHoraCriado == null;

  /// Define a data de criação caso ainda não tenha sido definida.
  void setDataHoraCriado() {
    dataHoraCriado ??= DateTime.now();
  }

  /// Cria uma cópia da entidade base.
  BaseEntity clone() => BaseEntity(
    id: id,
    dataHoraCriado: dataHoraCriado,
    dataHoraUltimaAlteracao: dataHoraUltimaAlteracao,
    dataHoraDeletado: dataHoraDeletado,
  );

  /// Converte a entidade para um mapa, útil para persistência em banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataHoraCriado': dataHoraCriado?.toIso8601String(),
      'dataHoraUltimaAlteracao': dataHoraUltimaAlteracao?.toIso8601String(),
      'dataHoraDeletado': dataHoraDeletado?.toIso8601String(),
    };
  }
}