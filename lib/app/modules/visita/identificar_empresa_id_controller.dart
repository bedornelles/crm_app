import 'package:crm_app/app/modules/visita/enum/status_sincronizacao.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/entity/base_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/shared/geolocator/localizacao/service/geolocalizacao_service_interface.dart';

part 'identificar_empresa_id_controller.g.dart';

class IdentificarEmpresaIdController = _IdentificarEmpresaIdControllerBase with _$IdentificarEmpresaIdController;

abstract class _IdentificarEmpresaIdControllerBase with Store{
  final IVisitaService _visitaService;
  final IGeolocalizacaoService _geolocalizacaoService;

  _IdentificarEmpresaIdControllerBase(
      this._visitaService,
      this._geolocalizacaoService,
      );

  @observable
  bool saving = false;

  @observable
  String idEmpresa = '';
  @action
  void setIdEmpresa(String valor) => idEmpresa = valor;

  @observable
  String contato = '';
  @action
  void setContato(String valor) => contato = valor;

  @observable
  String observacoes = '';

  @action
  void setObservacoes(String valor) => observacoes = valor;

  Future<void>? _carregandoLocalizacao;

  @observable
  String? localizacaoAtual;

  void iniciarCarregamentoLocalizacao() {
    _carregandoLocalizacao = _carregarLocalizacao();
  }

  Future<void> _carregarLocalizacao() async {
    localizacaoAtual = await _geolocalizacaoService.obterLocalizacaoAtual();
  }

  @action
  Future<VisitaEntity?> salvar(String idUsuario) async {

    if (saving) return null;
    saving = true;

    try {
      if(_carregandoLocalizacao != null) {
        await _carregandoLocalizacao;
      }
      final entity = VisitaEntity(
        base: BaseEntity.novo(),
        statusSincronizacao: StatusSincronizacao.pendente,
        dataVisita: DateTime.now(),
        identificadorEmpresa: int.tryParse(idEmpresa),
        nomeEmpresa: '',
        nomeContatoEmpresa: contato,
        observacoes: observacoes,
        idUsuario: idUsuario,
        demonstrouInteresse: true,
        cpfCnpjEmpresa: '',
        emailEmpresa: '',
        telefoneEmpresa: '',
        logradouroEmpresa: '',
        numeroEmpresa: '',
        cidadeEmpresa: '',
        complementoEmpresa: '',
        sistemaAtual: '',
        valorPago: '',
        erroSincronizacao: null,
        localizacao: localizacaoAtual,
      );

      await _visitaService.saveOrUpdate(entity);
      return entity;
    }finally {
      saving = false;
    }
  }

}