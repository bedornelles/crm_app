enum StatusSincronizacao {
  pendente,
  sincronizado,
  erro;


  //converte o enum para string para salvar no sqlite
  String get valor {
    switch (this) {
      case StatusSincronizacao.pendente:
        return 'PENDENE';
      case StatusSincronizacao.sincronizado:
        return 'SINCRONIZADO';
      case StatusSincronizacao.erro:
        return 'ERRO';
    }
  }

  //converte a string para enum
  static StatusSincronizacao fromValor(String valor) {
    switch (valor.toUpperCase()) {
      case 'SINCRONIZADO':
        return StatusSincronizacao.sincronizado;
      case 'ERRO' :
        return StatusSincronizacao.erro;

        default:
          return StatusSincronizacao.pendente;
    }
  }

}