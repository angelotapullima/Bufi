import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/tallaProducto_database.dart';
import 'package:bufi/src/models/tallaProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class TallaProductoBloc {

    final tallaProductoDb = TallaProductoDatabase();
  final tallaProdApi = ProductosApi();

  final _tallaProductoController =
      BehaviorSubject<List<TallaProductoModel>>();

  Stream<List<TallaProductoModel>> get tallaProdStream =>
      _tallaProductoController.stream;

  void dispose() {
    _tallaProductoController?.close();
   
  }

  void listarModeloProducto(String idProducto) async {
    _tallaProductoController.sink.add(await tallaProductoDb.obtenerTallaProductoPorIdProducto(idProducto));
    await tallaProdApi.listarDetalleProductoPorIdProducto(idProducto);
     _tallaProductoController.sink.add(await tallaProductoDb.obtenerTallaProductoPorIdProducto(idProducto));
    
  }
}
