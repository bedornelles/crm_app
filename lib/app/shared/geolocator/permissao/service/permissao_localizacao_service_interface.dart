abstract class IPermissaoLocalizacaoService {
  Future<bool> temPermissao();
  Future<void> solicitarPermissao();
  Future<bool> deveExibirModal();
}