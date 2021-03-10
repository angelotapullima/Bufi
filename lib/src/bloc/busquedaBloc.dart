
import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc{

  final goodApi = GoodApi();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();

  final busquedaGeneralController = BehaviorSubject<List<ProductoModel>>();

  Stream<List<ProductoModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;

  void dispose(){
    busquedaGeneralController?.close();
  }

//Para la busqueda
  void obtenerResultadosBusquedaPorQuery(String query) async {
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
    await goodApi.listarBienesAllPorCiudad();
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
  }


}