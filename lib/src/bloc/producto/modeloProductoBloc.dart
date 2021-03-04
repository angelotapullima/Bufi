import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/modeloProducto_database.dart';
import 'package:bufi/src/models/modeloProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class ModeloProductoBloc {

    final modeloProductoDb = ModeloProductoDatabase();
  final modeloProdApi = ProductosApi();

  final _modeloProductoController =
      BehaviorSubject<List<ModeloProductoModel>>();

  Stream<List<ModeloProductoModel>> get marcaProdStream =>
      _modeloProductoController.stream;

  void dispose() {
    _modeloProductoController?.close();
   
  }

  void listarModeloProducto(String idProducto) async {
    _modeloProductoController.sink.add(await modeloProductoDb.obtenerModeloProductoPorIdProducto(idProducto));
    await modeloProdApi.listarDetalleProductoPorIdProducto(idProducto);
     _modeloProductoController.sink.add(await modeloProductoDb.obtenerModeloProductoPorIdProducto(idProducto));
    
  }
}
