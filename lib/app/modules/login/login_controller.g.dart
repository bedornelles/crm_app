// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on _LoginControllerBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(
    () => super.loading,
    name: '_LoginControllerBase.loading',
  )).value;
  Computed<bool>? _$mostrarSenhaComputed;

  @override
  bool get mostrarSenha => (_$mostrarSenhaComputed ??= Computed<bool>(
    () => super.mostrarSenha,
    name: '_LoginControllerBase.mostrarSenha',
  )).value;

  late final _$_loadingAtom = Atom(
    name: '_LoginControllerBase._loading',
    context: context,
  );

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_mostrarSenhaAtom = Atom(
    name: '_LoginControllerBase._mostrarSenha',
    context: context,
  );

  @override
  bool get _mostrarSenha {
    _$_mostrarSenhaAtom.reportRead();
    return super._mostrarSenha;
  }

  @override
  set _mostrarSenha(bool value) {
    _$_mostrarSenhaAtom.reportWrite(value, super._mostrarSenha, () {
      super._mostrarSenha = value;
    });
  }

  late final _$_LoginControllerBaseActionController = ActionController(
    name: '_LoginControllerBase',
    context: context,
  );

  @override
  void alterarMostrarSenha() {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
      name: '_LoginControllerBase.alterarMostrarSenha',
    );
    try {
      return super.alterarMostrarSenha();
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
mostrarSenha: ${mostrarSenha}
    ''';
  }
}
