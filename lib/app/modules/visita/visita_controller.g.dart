// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visita_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisitaController on _VisitaControllerBase, Store {
  late final _$savingAtom = Atom(
    name: '_VisitaControllerBase.saving',
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

  late final _$visitaAtom = Atom(
    name: '_VisitaControllerBase.visita',
    context: context,
  );

  @override
  VisitaStore get visita {
    _$visitaAtom.reportRead();
    return super.visita;
  }

  @override
  set visita(VisitaStore value) {
    _$visitaAtom.reportWrite(value, super.visita, () {
      super.visita = value;
    });
  }

  late final _$salvarAsyncAction = AsyncAction(
    '_VisitaControllerBase.salvar',
    context: context,
  );

  @override
  Future<VisitaEntity?> salvar() {
    return _$salvarAsyncAction.run(() => super.salvar());
  }

  late final _$_VisitaControllerBaseActionController = ActionController(
    name: '_VisitaControllerBase',
    context: context,
  );

  @override
  void init(String idUsuario) {
    final _$actionInfo = _$_VisitaControllerBaseActionController.startAction(
      name: '_VisitaControllerBase.init',
    );
    try {
      return super.init(idUsuario);
    } finally {
      _$_VisitaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
saving: ${saving},
visita: ${visita}
    ''';
  }
}
