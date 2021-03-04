import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/marcaProducto_database.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class MarcaProductoBloc {

  //final marcaProductoModel = MarcaProductoModel();
  final marcaProductoDb = MarcaProductoDatabase();
  final marcaProdApi = ProductosApi();

  final _marcaProductoController =
      BehaviorSubject<List<MarcaProductoModel>>();

  Stream<List<MarcaProductoModel>> get marcaProdStream =>
      _marcaProductoController.stream;

  void dispose() {
    _marcaProductoController?.close();
   
  }

  void listarMarcaProducto(String idProducto) async {
    _marcaProductoController.sink.add(await marcaProductoDb.obtenerMarcaProductoPorIdProducto(idProducto));
    await marcaProdApi.listarDetalleProductoPorIdProducto(idProducto);
     _marcaProductoController.sink.add(await marcaProductoDb.obtenerMarcaProductoPorIdProducto(idProducto));
    
  }
}
