import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';

import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';

class VisitaEntity implements IBaseEntity{
  @override
  BaseEntity base; //herda o ID das propriedades base

  DateTime dataVisita;
  String nomeEmpresa;
  String nomeContatoEmpresa;
  int? identificadorEmpresa;
  String? cpfCnpjEmpresa;
  String? emailEmpresa;
  String? telefoneEmpresa;
  String logradouroEmpresa;
  String numeroEmpresa;
  String cidadeEmpresa;
  String? complementoEmpresa;
  String? sistemaAtual;
  String valorPago;
  bool demonstrouInteresse;
  String? observacoes;
  StatusSincronizacao statusSincronizacao;
  String? erroSincronizacao;
  String? localizacao;
  String idUsuario;


  String get tituloExibicao {
    if (nomeEmpresa.isNotEmpty) {
      return nomeEmpresa;
    } else if (identificadorEmpresa != null) {
      return 'Empresa ID: $identificadorEmpresa';
    }
    return 'Nova Empresa (sem nome)';
  }

  VisitaEntity({
    required this.base,
    required this.dataVisita,
    required this.nomeEmpresa,
    required this.nomeContatoEmpresa,
    this.identificadorEmpresa,
    this.emailEmpresa,
    this.cpfCnpjEmpresa,
    this.telefoneEmpresa,
    required this.logradouroEmpresa,
    required this.numeroEmpresa,
    required this.cidadeEmpresa,
    this.complementoEmpresa,
    this.sistemaAtual,
    required this.valorPago,
    required this.demonstrouInteresse,
    this.observacoes,
    required this.statusSincronizacao,
    this.erroSincronizacao,
    this.localizacao,
    required this.idUsuario,
  });

  Map<String, dynamic> toMap(){
    return{
      ...base.toMap(),
      'data_visita': dataVisita.toIso8601String(),
      'nome_empresa': nomeEmpresa,
      'nome_contato_empresa': nomeContatoEmpresa,
      'identificador_empresa': identificadorEmpresa,
      'email_empresa': emailEmpresa,
      'cpf_cnpj_empresa': cpfCnpjEmpresa,
      'telefone_empresa': telefoneEmpresa,
      'logradouro_empresa': logradouroEmpresa,
      'numero_empresa': numeroEmpresa,
      'cidade_empresa': cidadeEmpresa,
      'complemento_empresa': complementoEmpresa,
      'sistema_atual': sistemaAtual,
      'valor_pago': valorPago,
      'demonstrou_interesse': demonstrouInteresse ? 1 : 0,
      'observacoes': observacoes,
      'status_sincronizacao': statusSincronizacao.valor,
      'erro_sincronizacao': erroSincronizacao,
      'localizacao': localizacao,
      'id_usuario': idUsuario,
    };
  }

  factory VisitaEntity.fromMap(Map<String, dynamic> map) {
    return VisitaEntity(
      base: BaseEntity.fromMap(map),
      dataVisita: DateTime.parse(map['data_visita']),
      nomeEmpresa: map['nome_empresa'] ?? '',
      nomeContatoEmpresa: map['nome_contato_empresa'] ?? '',
      identificadorEmpresa: map['identificador_empresa'],
      emailEmpresa: map['email_empresa'],
      cpfCnpjEmpresa: map['cpf_cnpj_empresa'],
      telefoneEmpresa: map['telefone_empresa'],
      logradouroEmpresa: map['logradouro_empresa'] ?? '',
      numeroEmpresa: map['numero_empresa'] ?? '',
      cidadeEmpresa: map['cidade_empresa'] ?? '',
      complementoEmpresa: map['complemento_empresa'],
      sistemaAtual: map['sistema_atual'],
      valorPago: map['valor_pago'] ?? '',
      demonstrouInteresse: map['demonstrou_interesse'] == 1,
      observacoes: map['observacoes'],
      statusSincronizacao: StatusSincronizacao.fromValor(map['status_sincronizacao'] ?? 'PENDENTE'),
      erroSincronizacao: map['erro_sincronizacao'],
      localizacao: map['localizacao'],
      idUsuario: map['id_usuario'] ?? '',
    );
  }
}

