import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';

part 'identificar_empresa_id_controller.g.dart';

class IdentificarEmpresaIdController = _IdentificarEmpresaIdControllerBase with _$IdentificarEmpresaIdController;

abstract class _IdentificarEmpresaIdControllerBase with Store{
  final IVisitaService _visitaService;

  _IdentificarEmpresaIdControllerBase(this._visitaService);

  @observable
  bool loading = false;

  @observable
  String idEmpresa = '';

  @observable
  String contato = '';

  @observable
  String observacoes = '';

  @action
  Future<void> salvarVisitaId(String idUsuarioLogado) async {
    loading = true;
    try {
      final visita = VisitaEntity(
        base: BaseEntity.novo(),
        statusSincronizacao: 'pending',
        data: DateTime.now(),
        identificadorEmpresa: int.tryParse(idEmpresa),
        nomeEmpresa: '',
        contato: contato,
        observacoes: observacoes,
        idUsuario: idUsuarioLogado,
        demonstrouInteresse: true,
        cpfCnpj: '',
        email: '',
        telefone: '',
        logradouro: '',
        numero: '',
        cidade: '',
        complemento: '',
        sistemaAtual: '',
        valorPago: '',
      );

      await _visitaService.salvarEEnviar(visita);
    }finally {
      loading = false;
    }
  }

}