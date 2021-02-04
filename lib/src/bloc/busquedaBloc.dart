
import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc{

  final goodApi = GoodApi();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();

  final bienesBusquedaController = BehaviorSubject<List<ProductoModel>>();

  Stream<List<ProductoModel>> get bienesBusquedaStream =>
      bienesBusquedaController.stream;

  void dispose(){
    bienesBusquedaController?.close();
  }

//Para la busqueda
  void obtenerBienesAllPorQuery(String query) async {
    bienesBusquedaController.sink
        .add(await productoDatabase.consultarProductoPorQuery('$query'));
    await goodApi.listarBienesAllPorCiudad();
    bienesBusquedaController.sink
        .add(await productoDatabase.consultarProductoPorQuery('$query'));
  }


}