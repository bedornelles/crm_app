import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';

class VisitaEntity implements IBaseEntity{
  @override
  BaseEntity base; //herda o ID das propriedades base
  final DateTime data;
  final String nomeEmpresa;
  final String contato;
  final String cpfCnpj;
  final String email;
  final String telefone;
  final String logradouro;
  final String numero;
  final String cidade;
  final String? complemento;
  final String? sistemaAtual;
  final String valorPago;
  final bool demonstrouInteresse;
  final String? observacoes;
  final String statusSincronizacao;

  VisitaEntity({
    required this.base,
    required this.data,
    required this.nomeEmpresa,
    required this.contato,
    required this.cpfCnpj,
    required this.email,
    required this.telefone,
    required this.logradouro,
    required this.numero,
    required this.cidade,
    this.complemento,
    this.sistemaAtual,
    required this.valorPago,
    required this.demonstrouInteresse,
    this.observacoes,
    required this.statusSincronizacao,
  });

  Map<String, dynamic> toMap(){
    return{
      ...base.toMap(),
      'data' : data.toIso8601String(),
      'nomeEmpresa' : nomeEmpresa,
      'contato' : contato,
      'cpfCnpj': cpfCnpj,
      'email': email,
      'telefone': telefone,
      'logradouro': logradouro,
      'numero': numero,
      'cidade': cidade,
      'complemento': complemento,
      'sistemaAtual': sistemaAtual,
      'valorPago': valorPago,
      'demonstrouInteresse' : demonstrouInteresse ? 1 : 0,
      'observacoes' : observacoes,
      'statusSincronizacao': statusSincronizacao,
    };
  }

  factory VisitaEntity.fromMap(Map<String, dynamic> map) {
    return VisitaEntity(
      base:  BaseEntity.fromMap(map),
      data: DateTime.parse(map['data']),
      nomeEmpresa: map['nomeEmpresa'],
      contato: map['contato'],
      cpfCnpj: map['cpfCnpj'],
      email: map['email'],
      telefone: map['telefone'],
      logradouro: map['logradouro'],
      numero: map['numero'],
      cidade: map['cidade'],
      complemento: map['complemento'],
      sistemaAtual: map['sistemaAtual'],
      valorPago: map['valorPago'],
      demonstrouInteresse: map['demonstrouInteresse'] == 1,
      observacoes: map['observacoes'],
      statusSincronizacao: map['statusSincronizacao']
    );
  }
}

