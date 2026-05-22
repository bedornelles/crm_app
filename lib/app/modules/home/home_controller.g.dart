// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(
    () => super.loading,
    name: '_HomeControllerBase.loading',
  )).value;
  Computed<List<VisitaEntity>>? _$visitasFiltradasComputed;

  @override
  List<VisitaEntity> get visitasFiltradas =>
      (_$visitasFiltradasComputed ??= Computed<List<VisitaEntity>>(
        () => super.visitasFiltradas,
        name: '_HomeControllerBase.visitasFiltradas',
      )).value;

  late final _$_loadingAtom = Atom(
    name: '_HomeControllerBase._loading',
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

  late final _$visitasAtom = Atom(
    name: '_HomeControllerBase.visitas',
    context: context,
  );

  @override
  ObservableList<VisitaEntity> get visitas {
    _$visitasAtom.reportRead();
    return super.visitas;
  }

  @override
  set visitas(ObservableList<VisitaEntity> value) {
    _$visitasAtom.reportWrite(value, super.visitas, () {
      super.visitas = value;
    });
  }

  late final _$idUsuarioLogadoAtom = Atom(
    name: '_HomeControllerBase.idUsuarioLogado',
    context: context,
  );

  @override
  String get idUsuarioLogado {
    _$idUsuarioLogadoAtom.reportRead();
    return super.idUsuarioLogado;
  }

  @override
  set idUsuarioLogado(String value) {
    _$idUsuarioLogadoAtom.reportWrite(value, super.idUsuarioLogado, () {
      super.idUsuarioLogado = value;
    });
  }

  late final _$pesquisandoAtom = Atom(
    name: '_HomeControllerBase.pesquisando',
    context: context,
  );

  @override
  bool get pesquisando {
    _$pesquisandoAtom.reportRead();
    return super.pesquisando;
  }

  @override
  set pesquisando(bool value) {
    _$pesquisandoAtom.reportWrite(value, super.pesquisando, () {
      super.pesquisando = value;
    });
  }

  late final _$termoPesquisaAtom = Atom(
    name: '_HomeControllerBase.termoPesquisa',
    context: context,
  );

  @override
  String get termoPesquisa {
    _$termoPesquisaAtom.reportRead();
    return super.termoPesquisa;
  }

  @override
  set termoPesquisa(String value) {
    _$termoPesquisaAtom.reportWrite(value, super.termoPesquisa, () {
      super.termoPesquisa = value;
    });
  }

  late final _$nomeUsuarioAtom = Atom(
    name: '_HomeControllerBase.nomeUsuario',
    context: context,
  );

  @override
  String get nomeUsuario {
    _$nomeUsuarioAtom.reportRead();
    return super.nomeUsuario;
  }

  @override
  set nomeUsuario(String value) {
    _$nomeUsuarioAtom.reportWrite(value, super.nomeUsuario, () {
      super.nomeUsuario = value;
    });
  }

  late final _$iniciaisUsuarioAtom = Atom(
    name: '_HomeControllerBase.iniciaisUsuario',
    context: context,
  );

  @override
  String get iniciaisUsuario {
    _$iniciaisUsuarioAtom.reportRead();
    return super.iniciaisUsuario;
  }

  @override
  set iniciaisUsuario(String value) {
    _$iniciaisUsuarioAtom.reportWrite(value, super.iniciaisUsuario, () {
      super.iniciaisUsuario = value;
    });
  }

  late final _$desconectarAsyncAction = AsyncAction(
    '_HomeControllerBase.desconectar',
    context: context,
  );

  @override
  Future<void> desconectar() {
    return _$desconectarAsyncAction.run(() => super.desconectar());
  }

  late final _$carregarDadosUsuarioAsyncAction = AsyncAction(
    '_HomeControllerBase.carregarDadosUsuario',
    context: context,
  );

  @override
  Future<void> carregarDadosUsuario() {
    return _$carregarDadosUsuarioAsyncAction.run(
      () => super.carregarDadosUsuario(),
    );
  }

  late final _$loadAsyncAction = AsyncAction(
    '_HomeControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$_HomeControllerBaseActionController = ActionController(
    name: '_HomeControllerBase',
    context: context,
  );

  @override
  void addVisita(VisitaEntity visita) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
      name: '_HomeControllerBase.addVisita',
    );
    try {
      return super.addVisita(visita);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void iniciarPesquisa() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
      name: '_HomeControllerBase.iniciarPesquisa',
    );
    try {
      return super.iniciarPesquisa();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void encerrarPesquisa() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
      name: '_HomeControllerBase.encerrarPesquisa',
    );
    try {
      return super.encerrarPesquisa();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void atualizarPesquisa(String termo) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
      name: '_HomeControllerBase.atualizarPesquisa',
    );
    try {
      return super.atualizarPesquisa(termo);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
visitas: ${visitas},
idUsuarioLogado: ${idUsuarioLogado},
pesquisando: ${pesquisando},
termoPesquisa: ${termoPesquisa},
nomeUsuario: ${nomeUsuario},
iniciaisUsuario: ${iniciaisUsuario},
loading: ${loading},
visitasFiltradas: ${visitasFiltradas}
    ''';
  }
}
