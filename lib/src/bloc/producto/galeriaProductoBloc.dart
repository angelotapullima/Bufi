import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/galeriaProducto_database.dart';
import 'package:bufi/src/models/galeriaProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class GaleriaProductoBloc {

  final galeriaProductoModel = GaleriaProductoModel();
  final galeriaProductoDb = GaleriaProductoDatabase();
  final galeriaProdApi = ProductosApi();

  final _galeriaProductoController =
      BehaviorSubject<List<GaleriaProductoModel>>();

  Stream<List<GaleriaProductoModel>> get galeriaProdStream =>
      _galeriaProductoController.stream;

  void dispose() {
    _galeriaProductoController?.close();
   
  }

  void listarGaleriaProducto(String idProducto) async {
    _galeriaProductoController.sink.add(await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(idProducto));
    await galeriaProdApi.listarDetalleProducto(idProducto);
     _galeriaProductoController.sink.add(await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(idProducto));
    
  }
}
