
import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/api/busqueda_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc{

  final busquedaApi = BusquedaApi();
  //final productoDatabase = ProductoDatabase();
  //final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();

  final busquedaGeneralController = BehaviorSubject<List<BusquedaGeneralModel>>();

  Stream<List<BusquedaGeneralModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;

  void dispose(){
    busquedaGeneralController?.close();
  }

//Para la busqueda
  void obtenerResultadosBusquedaPorQuery(String query) async {
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
    await busquedaApi.busquedaGeneral(query);
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));

    //return resp;
    
  }


}