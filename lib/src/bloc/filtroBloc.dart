import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/marcaProducto_database.dart';
import 'package:bufi/src/database/modeloProducto_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/tallaProducto_database.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:bufi/src/models/modeloProductoModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/tallaProductoModel.dart';
import 'package:rxdart/rxdart.dart';

class FiltroBloc{
  
  final productoDb = ProductoDatabase();
  
  final marcaProductoDb = MarcaProductoDatabase();
  final modeloProductoDb = ModeloProductoDatabase();
  final tallaProductoDb = TallaProductoDatabase();
  final productoApi = ProductosApi();

  final _datosProductoController = BehaviorSubject<List<ProductoModel>>();

  Stream<List<ProductoModel>> get datosProdStream =>
      _datosProductoController.stream;

  void dispose() {
    _datosProductoController?.close();
  }

  void listarDatosProducto(String idProducto) async {
    _datosProductoController.sink.add(await obtenerDatosProductosPorIdProducto(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
    _datosProductoController.sink.add(await obtenerDatosProductosPorIdProducto(idProducto));
  }
 Future<List<ProductoModel>> obtenerDatosProductosPorIdProducto(
      String idProducto) async {

        //await tallaProductoDb.updateEstadoa0();
    List<ProductoModel> listaGeneral = List<ProductoModel>();

    //obtener todos los productos de la bd
    final listProductos = await productoDb.obtenerProductoPorIdSubsidiaryGood(idProducto);

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < listProductos.length; i++) {
      final productoModel = ProductoModel();
      productoModel.idProducto = listProductos[i].idProducto;
      productoModel.idSubsidiary = listProductos[i].idSubsidiary;
      productoModel.idGood = listProductos[i].idGood;
      productoModel.idItemsubcategory = listProductos[i].idItemsubcategory;
      productoModel.productoName = listProductos[i].productoName;
      productoModel.productoPrice = listProductos[i].productoPrice;
      productoModel.productoCurrency = listProductos[i].productoCurrency;
      productoModel.productoImage = listProductos[i].productoImage;
      productoModel.productoCharacteristics = listProductos[i].productoCharacteristics;
      productoModel.productoBrand = listProductos[i].productoBrand;
      productoModel.productoModel = listProductos[i].productoModel;
      productoModel.productoType = listProductos[i].productoType;
      productoModel.productoSize = listProductos[i].productoSize;
      productoModel.productoMeasure = listProductos[i].productoMeasure;
      productoModel.productoStock = listProductos[i].productoStock;
      productoModel.productoRating = listProductos[i].productoRating;
      productoModel.productoUpdated = listProductos[i].productoUpdated;
      productoModel.productoStatus = listProductos[i].productoStatus;

      

      //crear lista vacia para el modelo de Producto
      final listModelProdModel = List<ModeloProductoModel>();
      final listModeloProd = await modeloProductoDb.obtenerModeloProductoPorIdProducto(listProductos[i].idProducto);

      for (var l = 0; l < listModeloProd.length; l++) {
        final modelProduc = ModeloProductoModel();
        modelProduc.idModeloProducto = listModeloProd[l].idModeloProducto;
        modelProduc.idProducto = listModeloProd[l].idProducto;
        modelProduc.modeloProducto = listModeloProd[l].modeloProducto;
        modelProduc.modeloStatusProducto = listModeloProd[l].modeloStatusProducto;
        modelProduc.estado = listModeloProd[l].estado;

        listModelProdModel.add(modelProduc);
      }

      //crear lista vacia para la marca del Producto
      final listMarcaProdModel = List<MarcaProductoModel>();
      final listMarcaProd = await marcaProductoDb
          .obtenerMarcaProductoPorIdProducto(listProductos[i].idProducto);
      //Recorrer la lista de la tabla productos para obtenr todos los datos
      for (var m = 0; m < listMarcaProd.length; m++) {
        final marcaProdModel = MarcaProductoModel();
        marcaProdModel.idMarcaProducto = listMarcaProd[m].idMarcaProducto;
        marcaProdModel.idProducto = listMarcaProd[m].idProducto;
        marcaProdModel.marcaProducto = listMarcaProd[m].marcaProducto;
        marcaProdModel.marcaStatusProducto = listMarcaProd[m].marcaStatusProducto;
        marcaProdModel.estado = listMarcaProd[m].estado;

        listMarcaProdModel.add(marcaProdModel);
      }

      //crear lista vacia para la talla del Producto
      final listTallaProdModel = List<TallaProductoModel>();
      final listTallaProd = await tallaProductoDb
          .obtenerTallaProductoPorIdProducto(listProductos[i].idProducto);
      //Recorrer la lista de la tabla productos para obtenr todos los datos
      for (var n = 0; n < listTallaProd.length; n++) {
        final tallaProdModel = TallaProductoModel();
        tallaProdModel.idTallaProducto = listTallaProd[n].idTallaProducto;
        tallaProdModel.idProducto = listTallaProd[n].idProducto;
        tallaProdModel.tallaProducto = listTallaProd[n].tallaProducto;
        tallaProdModel.tallaProductoStatus = listTallaProd[n].tallaProductoStatus;
        tallaProdModel.estado = listTallaProd[n].estado;

        listTallaProdModel.add(tallaProdModel);
      }

      
      productoModel.listMarcaProd = listMarcaProdModel;
      productoModel.listModeloProd = listModelProdModel;
      productoModel.listTallaProd = listTallaProdModel;

      listaGeneral.add(productoModel);
    }
    return listaGeneral;
  }

}