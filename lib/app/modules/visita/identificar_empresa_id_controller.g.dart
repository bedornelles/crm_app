// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identificar_empresa_id_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IdentificarEmpresaIdController
    on _IdentificarEmpresaIdControllerBase, Store {
  late final _$savingAtom = Atom(
    name: '_IdentificarEmpresaIdControllerBase.saving',
    context: context,
  );

  @override
  bool get saving {
    _$savingAtom.reportRead();
    return super.saving;
  }

  @override
  set saving(bool value) {
    _$savingAtom.reportWrite(value, super.saving, () {
      super.saving = value;
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

  late final _$salvarAsyncAction = AsyncAction(
    '_IdentificarEmpresaIdControllerBase.salvar',
    context: context,
  );

  @override
  Future<VisitaEntity?> salvar(String idUsuario) {
    return _$salvarAsyncAction.run(() => super.salvar(idUsuario));
  }

  late final _$_IdentificarEmpresaIdControllerBaseActionController =
      ActionController(
        name: '_IdentificarEmpresaIdControllerBase',
        context: context,
      );

  @override
  void setIdEmpresa(String valor) {
    final _$actionInfo = _$_IdentificarEmpresaIdControllerBaseActionController
        .startAction(name: '_IdentificarEmpresaIdControllerBase.setIdEmpresa');
    try {
      return super.setIdEmpresa(valor);
    } finally {
      _$_IdentificarEmpresaIdControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setContato(String valor) {
    final _$actionInfo = _$_IdentificarEmpresaIdControllerBaseActionController
        .startAction(name: '_IdentificarEmpresaIdControllerBase.setContato');
    try {
      return super.setContato(valor);
    } finally {
      _$_IdentificarEmpresaIdControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setObservacoes(String valor) {
    final _$actionInfo = _$_IdentificarEmpresaIdControllerBaseActionController
        .startAction(
          name: '_IdentificarEmpresaIdControllerBase.setObservacoes',
        );
    try {
      return super.setObservacoes(valor);
    } finally {
      _$_IdentificarEmpresaIdControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
saving: ${saving},
idEmpresa: ${idEmpresa},
contato: ${contato},
observacoes: ${observacoes}
    ''';
  }
}
