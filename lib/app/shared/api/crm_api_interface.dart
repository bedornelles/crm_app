abstract class ICrmApi {
  //listas visitas
  Future<List<Map<String, dynamic>>> getAll({
    required String uri,
    Map<String, dynamic>? queryParameters,
    int refreshAttempts = 0,
});

  //fazer login e adicionar visitas
  Future<Map<String, dynamic>?> post ({
  required String uri,
  required Map<String, dynamic> data,
  int refreshAttempts = 0,
});
}
