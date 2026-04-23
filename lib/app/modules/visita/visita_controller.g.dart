// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visita_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisitaController on _VisitaControllerBase, Store {
  late final _$demonstrouInteresseAtom = Atom(
    name: '_VisitaControllerBase.demonstrouInteresse',
    context: context,
  );

  @override
  bool? get demonstrouInteresse {
    _$demonstrouInteresseAtom.reportRead();
    return super.demonstrouInteresse;
  }

  @override
  set demonstrouInteresse(bool? value) {
    _$demonstrouInteresseAtom.reportWrite(value, super.demonstrouInteresse, () {
      super.demonstrouInteresse = value;
    });
  }

  late final _$dataDaVisitaAtom = Atom(
    name: '_VisitaControllerBase.dataDaVisita',
    context: context,
  );

  @override
  DateTime get dataDaVisita {
    _$dataDaVisitaAtom.reportRead();
    return super.dataDaVisita;
  }

  @override
  set dataDaVisita(DateTime value) {
    _$dataDaVisitaAtom.reportWrite(value, super.dataDaVisita, () {
      super.dataDaVisita = value;
    });
  }

  late final _$salvarVisitaAsyncAction = AsyncAction(
    '_VisitaControllerBase.salvarVisita',
    context: context,
  );

  @override
  Future<void> salvarVisita(VisitaEntity novaVisita) {
    return _$salvarVisitaAsyncAction.run(() => super.salvarVisita(novaVisita));
  }

  late final _$_VisitaControllerBaseActionController = ActionController(
    name: '_VisitaControllerBase',
    context: context,
  );

  @override
  void setDemonstrouInteresse(bool valor) {
    final _$actionInfo = _$_VisitaControllerBaseActionController.startAction(
      name: '_VisitaControllerBase.setDemonstrouInteresse',
    );
    try {
      return super.setDemonstrouInteresse(valor);
    } finally {
      _$_VisitaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataDaVisita(DateTime valor) {
    final _$actionInfo = _$_VisitaControllerBaseActionController.startAction(
      name: '_VisitaControllerBase.setDataDaVisita',
    );
    try {
      return super.setDataDaVisita(valor);
    } finally {
      _$_VisitaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
demonstrouInteresse: ${demonstrouInteresse},
dataDaVisita: ${dataDaVisita}
    ''';
  }
}
