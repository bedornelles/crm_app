// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identificar_empresa_id_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IdentificarEmpresaIdController
    on _IdentificarEmpresaIdControllerBase, Store {
  late final _$loadingAtom = Atom(
    name: '_IdentificarEmpresaIdControllerBase.loading',
    context: context,
  );

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$idEmpresaAtom = Atom(
    name: '_IdentificarEmpresaIdControllerBase.idEmpresa',
    context: context,
  );

  @override
  String get idEmpresa {
    _$idEmpresaAtom.reportRead();
    return super.idEmpresa;
  }

  @override
  set idEmpresa(String value) {
    _$idEmpresaAtom.reportWrite(value, super.idEmpresa, () {
      super.idEmpresa = value;
    });
  }

  late final _$contatoAtom = Atom(
    name: '_IdentificarEmpresaIdControllerBase.contato',
    context: context,
  );

  @override
  String get contato {
    _$contatoAtom.reportRead();
    return super.contato;
  }

  @override
  set contato(String value) {
    _$contatoAtom.reportWrite(value, super.contato, () {
      super.contato = value;
    });
  }

  late final _$observacoesAtom = Atom(
    name: '_IdentificarEmpresaIdControllerBase.observacoes',
    context: context,
  );

  @override
  String get observacoes {
    _$observacoesAtom.reportRead();
    return super.observacoes;
  }

  @override
  set observacoes(String value) {
    _$observacoesAtom.reportWrite(value, super.observacoes, () {
      super.observacoes = value;
    });
  }

  late final _$salvarVisitaIdAsyncAction = AsyncAction(
    '_IdentificarEmpresaIdControllerBase.salvarVisitaId',
    context: context,
  );

  @override
  Future<void> salvarVisitaId(String idUsuarioLogado) {
    return _$salvarVisitaIdAsyncAction.run(
      () => super.salvarVisitaId(idUsuarioLogado),
    );
  }

  @override
  String toString() {
    return '''
loading: ${loading},
idEmpresa: ${idEmpresa},
contato: ${contato},
observacoes: ${observacoes}
    ''';
  }
}
