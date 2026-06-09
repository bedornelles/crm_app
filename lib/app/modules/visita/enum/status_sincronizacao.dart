enum StatusSincronizacao {
  pendente,
  sincronizado,
  erro,
  falhou;


  //converte o enum para string para salvar no sqlite
  String get valor {
    switch (this) {
      case StatusSincronizacao.pendente:
        return 'PENDENTE';
      case StatusSincronizacao.sincronizado:
        return 'SINCRONIZADO';
      case StatusSincronizacao.erro:
        return 'ERRO';
      case StatusSincronizacao.falhou:
        return 'FALHOU';
    }
  }

  //converte a string para enum
  static StatusSincronizacao fromValor(String? valor) {
    if (valor == null) return StatusSincronizacao.pendente;
    switch (valor.toUpperCase()) {
      case 'SINCRONIZADO':
        return StatusSincronizacao.sincronizado;
      case 'ERRO':
        return StatusSincronizacao.erro;
      case 'FALHOU':
        return StatusSincronizacao.falhou;
        default:
          return StatusSincronizacao.pendente;
    }
  }

}