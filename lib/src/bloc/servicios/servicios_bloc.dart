

import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:rxdart/subjects.dart';

class ServiciosBloc {
  final subservicesDatabase = SubsidiaryServiceDatabase();
  final subservicesModel = SubsidiaryServiceModel();
  final serviciosApi = ServiceApi();

  final _servicioController = BehaviorSubject<List<SubsidiaryServiceModel>>();

  final _detailServicioController =
      BehaviorSubject<List<SubsidiaryServiceModel>>();

  Stream<List<SubsidiaryServiceModel>> get serviciostream =>
      _servicioController.stream;

  Stream<List<SubsidiaryServiceModel>> get detailServiciostream =>
      _detailServicioController.stream;

  void dispose() {
    _servicioController?.close();
    _detailServicioController?.close();
  }

  void listarServiciosPorSucursal(String id) async {
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
    await serviciosApi.listarServiciosPorSucursal(id);
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
  }

  void detalleServicioPorIdSubsidiaryService(String id) async {
    _detailServicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursalService(id));
    await serviciosApi.detalleSerivicioPorIdSubsidiaryService(id);
    _detailServicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursalService(id));
  }
}
