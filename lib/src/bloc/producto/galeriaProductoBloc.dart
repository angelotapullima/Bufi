import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/galeriaProducto_database.dart';
import 'package:bufi/src/database/marcaProducto_database.dart';
import 'package:bufi/src/database/modeloProducto_database.dart';
import 'package:bufi/src/database/tallaProducto_database.dart';
import 'package:bufi/src/models/galeriaProductoModel.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:bufi/src/models/modeloProductoModel.dart';
import 'package:bufi/src/models/tallaProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class GaleriaProductoBloc {

  final galeriaProductoModel = GaleriaProductoModel();
  final galeriaProductoDb = GaleriaProductoDatabase();
  final marcaProductoDb = MarcaProductoDatabase();
  final modeloProductoDb = ModeloProductoDatabase();
  final tallaProductoDb = TallaProductoDatabase();
  final productoApi = ProductosApi();

  final _galeriaProductoController =
      BehaviorSubject<List<GaleriaProductoModel>>();
   final _marcaProductoController =
      BehaviorSubject<List<MarcaProductoModel>>();
      
  final _modeloProductoController =
      BehaviorSubject<List<ModeloProductoModel>>();

  final _tallaProductoController =
      BehaviorSubject<List<TallaProductoModel>>();

  Stream<List<TallaProductoModel>> get tallaProdStream =>
      _tallaProductoController.stream;

  Stream<List<ModeloProductoModel>> get modeloProdStream =>
      _modeloProductoController.stream;

  Stream<List<MarcaProductoModel>> get marcaProdStream =>
      _marcaProductoController.stream;

  Stream<List<GaleriaProductoModel>> get galeriaProdStream =>
      _galeriaProductoController.stream;

  void dispose() {
    _galeriaProductoController?.close();
     _marcaProductoController?.close();
    _tallaProductoController?.close();
   
  }

  void listarGaleriaProducto(String idProducto) async {
    _galeriaProductoController.sink.add(await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
     _galeriaProductoController.sink.add(await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(idProducto));
    
  }
  void listarMarcaProducto(String idProducto) async {
    _marcaProductoController.sink.add(await marcaProductoDb.obtenerMarcaProductoPorIdProducto(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
     _marcaProductoController.sink.add(await marcaProductoDb.obtenerMarcaProductoPorIdProducto(idProducto));
    
  }

  void listarModeloProducto(String idProducto) async {
    _modeloProductoController.sink.add(await modeloProductoDb.obtenerModeloProductoPorIdProducto(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
     _modeloProductoController.sink.add(await modeloProductoDb.obtenerModeloProductoPorIdProducto(idProducto));
    
  }

   void listarTallaProducto(String idProducto) async {
    _tallaProductoController.sink.add(await tallaProductoDb.obtenerTallaProductoPorIdProducto(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
     _tallaProductoController.sink.add(await tallaProductoDb.obtenerTallaProductoPorIdProducto(idProducto));
    
  }
}
