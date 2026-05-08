import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:crm_app/app/shared/entity/base_entity_interface.dart';
import 'package:flutter/cupertino.dart';

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
  final String idUsuario;
  final int? identificadorEmpresa;

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
    required this.idUsuario,
    this.identificadorEmpresa,
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
      'idUsuario': idUsuario,
      'identificadorEmpresa': identificadorEmpresa,
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
      statusSincronizacao: map['statusSincronizacao'],
      idUsuario: map['idUsuario'] ?? '',
      identificadorEmpresa: map['identificadorEmpresa'],
    );
  }

  //alterando formato para conversar com a API

  Map<String, dynamic> toApiMap() {
    final map = {
      "dataVisita": data.toIso8601String().split('T')[0],
      "nomeEmpresa": nomeEmpresa,
      "nomeContatoEmpresa": contato,
      "emailEmpresa": email,
      "cpfCnpjEmpresa": cpfCnpj.replaceAll(RegExp(r'[^0-9]'), ''),
      "telefoneEmpresa": telefone.replaceAll(RegExp(r'[^0-9]'), ''),
      "sistemaAtual": sistemaAtual,
      "valorPago": double.tryParse(valorPago.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0,
      "interessado": demonstrouInteresse,
      "observacao": observacoes,
      "logradouroEmpresa": logradouro,
      "numeroEmpresa": numero.toString(),
      "cidadeEmpresa": cidade,
      "complementoEmpresa": complemento,
      "statusSincronizacao": 0,
      "identificadorEmpresa": identificadorEmpresa,
      "localizacao": "",
      "erroSincronizacao": "",
    };

    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory VisitaEntity.fromApiMap(Map<String, dynamic> map){
    final mapaLocal = {
      'id': map['id'],
      'dataHoraCriado': map['dataHoraCriada'],
      'dataHoraUltimaAlteracao': map['dataHoraAlterada'],
      'dataHoraDeletado': map['dataHoraDeletada'],

      'data': map['dataVisita'],
      'nomeEmpresa': map['nomeEmpresa'] ??'',
      'contato': map['nomeContatoEmpresa'] ??'',
      'cpfCnpj': map['cpfCnpjEmpresa'] ??'',
      'email': map['emailEmpresa'] ??'',
      'telefone': map['telefoneEmpresa'] ??'',
      'logradouro': map['logradouroEmpresa'] ??'',
      'numero': map['numeroEmpresa']?.toString() ??'',
      'cidade': map['cidadeEmpresa'] ??'',
      'complemento': map['complementoEmpresa'] ??'',
      'sistemaAtual': map['sistemaAtual'] ??'',
      'valorPago': map['valorPago']?.toString() ?? '0.0',
      'demonstrouInteresse': map['interessado'] == true ? 1 : 0,
      'observacoes': map['observacao'] ??'',

      'statusSincronizacao': '1',

      'idUsuario': map['idUsuario'] ?? '',
    };
    return VisitaEntity.fromMap(mapaLocal);
  }

}

