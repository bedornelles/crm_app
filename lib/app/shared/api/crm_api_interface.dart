abstract class ICrmApi {

  //fazer login e adicionar visitas
  Future<Map<String, dynamic>?> post ({
  required String uri,
  required Map<String, dynamic> data,
  int refreshAttempts = 0,
});
}
