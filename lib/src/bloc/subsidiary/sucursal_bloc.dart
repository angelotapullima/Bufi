

import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:rxdart/subjects.dart';

class SucursalBloc {
  final sucursalDatabase = SubsidiaryDatabase();
  final sucursalApi = NegociosApi();

//obtener subsidiary por idCompany
  final _sucursalController = BehaviorSubject<List<SubsidiaryModel>>();
  final _listarsucursalesController = BehaviorSubject<List<SubsidiaryModel>>();

  //Controller de subsidiary por id
  final _subsidiaryIdController = BehaviorSubject<List<SubsidiaryModel>>();

//Stream de subsidiary por idCompany
  Stream<List<SubsidiaryModel>> get sucursalStream =>_sucursalController.stream;

//Stream de subsidiary por id
  Stream<List<SubsidiaryModel>> get subsidiaryIdStream =>_subsidiaryIdController.stream;

  void dispose() {
    _sucursalController?.close();
    _listarsucursalesController?.close();
    _subsidiaryIdController?.close();
  }

  void obtenerSucursalporIdCompany(String id) async {
    _sucursalController.sink.add(await sucursalDatabase.obtenerSubsidiaryPorIdCompany(id));
    await sucursalApi.listarSedesPorNegocio(id);
    _sucursalController.sink.add(await sucursalDatabase.obtenerSubsidiaryPorIdCompany(id));
  }

  void obtenerSucursalporId(String id) async {
    _subsidiaryIdController.sink.add(await sucursalDatabase.obtenerSubsidiaryPorId(id));
    await sucursalApi.listarSubsidiaryPorId(id);
   _subsidiaryIdController.sink.add(await sucursalDatabase.obtenerSubsidiaryPorId(id));
  }
}
