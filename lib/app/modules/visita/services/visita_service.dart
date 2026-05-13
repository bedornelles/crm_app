import 'package:crm_app/app/modules/visita/entity/visita_entity.dart';
import 'package:crm_app/app/modules/visita/repositories/visita_repository_interface.dart';
import 'package:crm_app/app/modules/visita/services/visita_service_interface.dart';
import 'package:crm_app/app/shared/service/base_service.dart';


class VisitaService extends BaseService<VisitaEntity, IVisitaRepository> implements IVisitaService {

  VisitaService(super.repository);

  @override
  Future<List<VisitaEntity>> getAllNaoSincronizadas() async {
    return await repository.getAllNaoSincronizadas();
  }

  @override
  Future<List<VisitaEntity>> getVisitasPorUsuario(String idUsuario) async{
    return await repository.getVisitasPorUsuario(idUsuario);
  }
}