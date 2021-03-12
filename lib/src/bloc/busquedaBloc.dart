import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/api/busqueda_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc {
  final busquedaApi = BusquedaApi();
  //final productoDatabase = ProductoDatabase();
  //final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();

  final busquedaGeneralController =
      BehaviorSubject<List<BusquedaGeneralModel>>();
  final busquedaProductoController =
      BehaviorSubject<List<BusquedaProductoModel>>();
  final busquedaServicioController =
      BehaviorSubject<List<BusquedaServicioModel>>();
  final busquedaNegocioController =
      BehaviorSubject<List<BusquedaNegocioModel>>();

  Stream<List<BusquedaGeneralModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;
  Stream<List<BusquedaProductoModel>> get busquedaProductoStream =>
      busquedaProductoController.stream;
  Stream<List<BusquedaServicioModel>> get busquedaServicioStream =>
      busquedaServicioController.stream;
  Stream<List<BusquedaNegocioModel>> get busquedaNegocioStream =>
      busquedaNegocioController.stream;

  void dispose() {
    busquedaGeneralController?.close();
    busquedaProductoController?.close();
    busquedaServicioController?.close();
    busquedaNegocioController?.close();
  }

//Para la busqueda General
  void obtenerResultadosBusquedaPorQuery(String query) async {
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
    busquedaGeneralController.sink
        .add(await busquedaApi.busquedaGeneral(query));
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
  }

  void obtenerBusquedaProducto(String query) async {
        busquedaProductoController.sink
        .add(await busquedaApi.busquedaProducto(query));
    
  }
}
