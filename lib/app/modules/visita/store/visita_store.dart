import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/shared/store/base_store.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';

part 'visita_store.g.dart';

class VisitaStore = _VisitaStoreBase with _$VisitaStore;

abstract class VisitaStoreFactory {
  static VisitaStore fromEntity(VisitaEntity entity) => VisitaStore(
    base: BaseStoreFactory.fromEntity(entity.base),
    dataVisita: entity.dataVisita,
    nomeEmpresa: entity.nomeEmpresa,
    nomeContatoEmpresa: entity.nomeContatoEmpresa,
    identificadorEmpresa: entity.identificadorEmpresa,
    emailEmpresa: entity.emailEmpresa,
    cpfCnpjEmpresa: entity.cpfCnpjEmpresa,
    telefoneEmpresa: entity.telefoneEmpresa,
    logradouroEmpresa: entity.logradouroEmpresa,
    numeroEmpresa: entity.numeroEmpresa,
    cidadeEmpresa: entity.cidadeEmpresa,
    complementoEmpresa: entity.complementoEmpresa,
    sistemaAtual: entity.sistemaAtual,
    valorPago: entity.valorPago,
    demonstrouInteresse: entity.demonstrouInteresse,
    observacoes: entity.observacoes,
    statusSincronizacao: entity.statusSincronizacao,
    localizacao: entity.localizacao,
    idUsuario: entity.idUsuario,
    erroSincronizacao: entity.erroSincronizacao,
  );

  static VisitaStore novo(String idUsuario) => VisitaStore(
    base: BaseStoreFactory.novo(),
    dataVisita: DateTime.now(),
    nomeEmpresa: '',
    nomeContatoEmpresa: '',
    identificadorEmpresa: null,
    emailEmpresa: '',
    cpfCnpjEmpresa: '',
    telefoneEmpresa: '',
    logradouroEmpresa: '',
    numeroEmpresa: '',
    cidadeEmpresa: '',
    complementoEmpresa: null,
    sistemaAtual: null,
    valorPago: '',
    demonstrouInteresse: null,
    observacoes: null,
    statusSincronizacao: StatusSincronizacao.pendente,
    localizacao: null,
    idUsuario: idUsuario,
    erroSincronizacao: null,
  );
}

abstract class _VisitaStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  DateTime dataVisita;

  @observable
  String nomeEmpresa;

  @observable
  String nomeContatoEmpresa;

  @observable
  int? identificadorEmpresa;

  @observable
  String? emailEmpresa;

  @observable
  String? cpfCnpjEmpresa;

  @observable
  String? telefoneEmpresa;

  @observable
  String logradouroEmpresa;

  @observable
  String numeroEmpresa;

  @observable
  String cidadeEmpresa;

  @observable
  String? complementoEmpresa;

  @observable
  String? sistemaAtual;

  @observable
  String valorPago;

  @observable
  bool? demonstrouInteresse;

  @observable
  String? observacoes;

  @observable
  StatusSincronizacao statusSincronizacao;

  @observable
  String idUsuario;

  @observable
  String? localizacao;

  @observable
  String? erroSincronizacao;

  _VisitaStoreBase({
    required this.base,
    required this.dataVisita,
    required this.nomeEmpresa,
    required this.nomeContatoEmpresa,
    required this.identificadorEmpresa,
    required this.emailEmpresa,
    required this.cpfCnpjEmpresa,
    required this.telefoneEmpresa,
    required this.logradouroEmpresa,
    required this.numeroEmpresa,
    required this.cidadeEmpresa,
    required this.complementoEmpresa,
    required this.sistemaAtual,
    required this.valorPago,
    required this.demonstrouInteresse,
    required this.observacoes,
    required this.statusSincronizacao,
    required this.localizacao,
    required this.idUsuario,
    required this.erroSincronizacao,
  });

  VisitaEntity toEntity() => VisitaEntity(
    base: base.toEntity(),
    dataVisita: dataVisita,
    nomeEmpresa: nomeEmpresa,
    nomeContatoEmpresa: nomeContatoEmpresa,
    identificadorEmpresa: identificadorEmpresa,
    emailEmpresa: emailEmpresa,
    cpfCnpjEmpresa: cpfCnpjEmpresa,
    telefoneEmpresa: telefoneEmpresa,
    logradouroEmpresa: logradouroEmpresa,
    numeroEmpresa: numeroEmpresa,
    cidadeEmpresa: cidadeEmpresa,
    complementoEmpresa: complementoEmpresa,
    sistemaAtual: sistemaAtual,
    valorPago: valorPago,
    demonstrouInteresse: demonstrouInteresse ?? false,
    observacoes: observacoes,
    statusSincronizacao: statusSincronizacao,
    localizacao: localizacao,
    idUsuario: idUsuario,
    erroSincronizacao: erroSincronizacao,
  );

  VisitaStore clone() => VisitaStore(
    base: base.clone(),
    dataVisita: dataVisita,
    nomeEmpresa: nomeEmpresa,
    nomeContatoEmpresa: nomeContatoEmpresa,
    identificadorEmpresa: identificadorEmpresa,
    emailEmpresa: emailEmpresa,
    cpfCnpjEmpresa: cpfCnpjEmpresa,
    telefoneEmpresa: telefoneEmpresa,
    logradouroEmpresa: logradouroEmpresa,
    numeroEmpresa: numeroEmpresa,
    cidadeEmpresa: cidadeEmpresa,
    complementoEmpresa: complementoEmpresa,
    sistemaAtual: sistemaAtual,
    valorPago: valorPago,
    demonstrouInteresse: demonstrouInteresse,
    observacoes: observacoes,
    statusSincronizacao: statusSincronizacao,
    localizacao: localizacao,
    idUsuario: idUsuario,
    erroSincronizacao: erroSincronizacao,
  );
}
