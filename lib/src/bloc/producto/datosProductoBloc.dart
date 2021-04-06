import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/galeriaProducto_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/models/galeriaProductoModel.dart';

import 'package:bufi/src/models/productoModel.dart';

import 'package:rxdart/rxdart.dart';

class DatosProductoBloc {
  final galeriaProductoModel = GaleriaProductoModel();
  final productoDb = ProductoDatabase();
  final galeriaProductoDb = GaleriaProductoDatabase();
  final productoApi = ProductosApi();

  final _datosProductoController = BehaviorSubject<List<ProductoModel>>();
  

  Stream<List<ProductoModel>> get datosProdStream => _datosProductoController.stream;
  

  void dispose() {
    _datosProductoController?.close();
    
  }

  void listarDatosProducto(String idProducto) async {
    _datosProductoController.sink.add(await obtenerDatosProductosRelacionados(idProducto));
    await productoApi.listarDetalleProductoPorIdProducto(idProducto);
    _datosProductoController.sink.add(await obtenerDatosProductosRelacionados(idProducto));
  }


  Future<List<ProductoModel>> obtenerDatosProductosRelacionados(
      String idProducto) async {

        //await tallaProductoDb.updateEstadoa0();
    List<ProductoModel> listaGeneral = List<ProductoModel>();

    //obtener todos los productos de la bd
    final listProductos = await productoDb.obtenerSubsidiaryGood();

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < 4; i++) {
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

      //funcion que llama desde la bd a la lista de fotos del producto pasando el idPedido como argumento
      final listGaleria = await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(listProductos[i].idProducto);
      //crear lista vacia para llenar las fotos del producto
      final listGaleriaModel = List<GaleriaProductoModel>();

      // recorrer la tabla galeria
      for (var j = 0; j < listGaleria.length; j++) {
        final galeriaProductos = GaleriaProductoModel();
        galeriaProductos.idGaleriaProducto = listGaleria[j].idGaleriaProducto;
        galeriaProductos.idProducto = listGaleria[j].idProducto;
        galeriaProductos.galeriaFoto = listGaleria[j].galeriaFoto;
        galeriaProductos.estado = listGaleria[j].estado;

        listGaleriaModel.add(galeriaProductos);
      }

     
     
     

      productoModel.listFotos = listGaleriaModel;
      

      listaGeneral.add(productoModel);
    }
    return listaGeneral;
  }



}