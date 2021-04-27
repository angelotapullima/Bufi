import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/valoracion_database.dart';
import 'package:bufi/src/models/ValoracionModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/subjects.dart';

class ProductoBloc {
  final productoDatabase = ProductoDatabase();
  final serviceDatabase = SubsidiaryServiceDatabase();
  final productosApi = ProductosApi();
  final carritoDatabase = CarritoDb();
  final valoracionProductoDb = ValoracionDataBase();

  final _productosSubsidiaryCarritoController =
      BehaviorSubject<List<BienesServiciosModel>>();
  final _productoController = BehaviorSubject<List<ProductoModel>>();
  final _detailsproductoController = BehaviorSubject<List<ProductoModel>>();

  //Valoracion, rating
  final _valoracionController = BehaviorSubject<List<ValoracionModel>>();

  Stream<List<BienesServiciosModel>> get productoSubsidiaryCarritoStream =>
      _productosSubsidiaryCarritoController.stream;
  Stream<List<ProductoModel>> get detailsproductostream =>
      _detailsproductoController.stream;
  Stream<List<ProductoModel>> get productoStream => _productoController.stream;

  //Valoracion, rating
  Stream<List<ValoracionModel>> get valoracionStream =>
      _valoracionController.stream;

  void dispose() {
    _productosSubsidiaryCarritoController?.close();
    _detailsproductoController?.close();
    _productoController?.close();
    _valoracionController?.close();
  }

//función que se llama al mostrar la vista de los paneles negro y blanco luego de agregar un producto al carrito
  void listarProductosPorSucursalCarrito(String id) async {
    _productosSubsidiaryCarritoController.sink.add(await datosSucursal(id));
    await productosApi.listarProductosPorSucursal(id);
    _productosSubsidiaryCarritoController.sink.add(await datosSucursal(id));
  }

  //funcion que se llama cuando muestras los productos por sucursal
  void listarProductosPorSucursal(String id) async {
    print('ihbrgiubergr $id');
    _productoController.sink
        .add(await productoDatabase.obtenerProductosPorIdSubsidiary(id));
    await productosApi.listarProductosPorSucursal(id);
    _productoController.sink
        .add(await productoDatabase.obtenerProductosPorIdSubsidiary(id));
  }

  void listarProductosPorSucursalFiltrado(List<String> tallas,
      List<String> modelos, List<String> marcas, String idSucursal) async {
    final List<ProductoModel> listFinal = [];
    final List<String> listIdSinRepetir = [];
    String consultaTallas = '';
    String consultaMarcas = '';
    String consultaModelos = '';
    listFinal.clear();
    listIdSinRepetir.clear();

    if (marcas.length > 0) {
      for (var x = 0; x < marcas.length; x++) {
        if (x == 0) {
          consultaMarcas += "'${marcas[x]}' ";
        } else {
          consultaMarcas += "or producto_brand = '${marcas[x]}' ";
        }
      }
      String sqlMarcas =
          'SELECT * FROM Producto where  producto_brand = $consultaMarcas and id_subsidiary="$idSucursal"';

      final productitosMarcas = await productoDatabase.sqlConsulta(sqlMarcas);

      for (var i = 0; i < productitosMarcas.length; i++) {
        listIdSinRepetir.add(productitosMarcas[i].idProducto);
      }
    }

    if (tallas.length > 0) {
      for (var i = 0; i < tallas.length; i++) {
        if (i == tallas.length - 1) {
          consultaTallas += "'${tallas[i]}' ";
        } else {
          consultaTallas += "or producto_size = ${tallas[i]} ";
        }
      }

      String sqlTallas =
          'SELECT * FROM Producto where producto_size  = $consultaTallas and id_subsidiary="$idSucursal"';

      final productitosTallas = await productoDatabase.sqlConsulta(sqlTallas);

      for (var i = 0; i < productitosTallas.length; i++) {
        listIdSinRepetir.add(productitosTallas[i].idProducto);
      }
    }

    if (modelos.length > 0) {
      for (var y = 0; y < modelos.length; y++) {
        if (y == modelos.length - 1) {
          consultaModelos += "'${modelos[y]}' ";
        } else {
          consultaModelos += "or producto_model = '${modelos[y]}' ";
        }
      }

      String sqlModelos =
          'SELECT * FROM Producto where producto_model = $consultaModelos and id_subsidiary="$idSucursal"';

      final productitosModelo = await productoDatabase.sqlConsulta(sqlModelos);

      for (var i = 0; i < productitosModelo.length; i++) {
        listIdSinRepetir.add(productitosModelo[i].idProducto);
      }
    }

    final listGeneral = listIdSinRepetir.toSet().toList();

    for (var i = 0; i < listGeneral.length; i++) {
      final producto = await productoDatabase
          .obtenerProductoPorIdSubsidiaryGood(listGeneral[i]);

      ProductoModel productoModel = ProductoModel();
      productoModel.idProducto = producto[0].idProducto;
      productoModel.idSubsidiary = producto[0].idSubsidiary;
      productoModel.idGood = producto[0].idGood;
      productoModel.idItemsubcategory = producto[0].idItemsubcategory;
      productoModel.productoName = producto[0].productoName;
      productoModel.productoPrice = producto[0].productoPrice;
      productoModel.productoCurrency = producto[0].productoCurrency;
      productoModel.productoImage = producto[0].productoImage;
      productoModel.productoCharacteristics =
          producto[0].productoCharacteristics;
      productoModel.productoBrand = producto[0].productoBrand;
      productoModel.productoModel = producto[0].productoModel;
      productoModel.productoType = producto[0].productoType;
      productoModel.productoSize = producto[0].productoSize;
      productoModel.productoStock = producto[0].productoStock;
      productoModel.productoMeasure = producto[0].productoMeasure;
      productoModel.productoRating = producto[0].productoRating;
      productoModel.productoUpdated = producto[0].productoUpdated;
      productoModel.productoStatus = producto[0].productoStatus;
      productoModel.productoFavourite = producto[0].productoFavourite;

      listFinal.add(productoModel);
    }

    _productoController.sink.add(listFinal);
  }

  Future<List<BienesServiciosModel>> datosSucursal(String idSubsidiary) async {
    final List<BienesServiciosModel> listGeneral = [];

    final productSubsidiary =
        await productoDatabase.obtenerProductosPorIdSubsidiary(idSubsidiary);
    final serviceSubsidiary =
        await serviceDatabase.obtenerServiciosPorIdSucursal(idSubsidiary);
    final carritoList = await carritoDatabase.obtenerCarrito();

    if (carritoList.length > 0) {
      for (var x = 0; x < carritoList.length; x++) {
        for (var i = 0; i < productSubsidiary.length; i++) {
          if (carritoList[x].idSubsidiaryGood !=
              productSubsidiary[i].idProducto) {
            final bienesServiciosModel = BienesServiciosModel();

            //Para Bienes
            bienesServiciosModel.idSubsidiarygood =
                productSubsidiary[i].idProducto;
            bienesServiciosModel.idSubsidiary =
                productSubsidiary[i].idSubsidiary;
            bienesServiciosModel.idGood = productSubsidiary[i].idGood;
            bienesServiciosModel.idItemsubcategory =
                productSubsidiary[i].idItemsubcategory;
            bienesServiciosModel.subsidiaryGoodName =
                productSubsidiary[i].productoName;
            bienesServiciosModel.subsidiaryGoodPrice =
                productSubsidiary[i].productoPrice;
            bienesServiciosModel.subsidiaryGoodCurrency =
                productSubsidiary[i].productoCurrency;
            bienesServiciosModel.subsidiaryGoodImage =
                productSubsidiary[i].productoImage;
            bienesServiciosModel.subsidiaryGoodCharacteristics =
                productSubsidiary[i].productoCharacteristics;
            bienesServiciosModel.subsidiaryGoodBrand =
                productSubsidiary[i].productoBrand;
            bienesServiciosModel.subsidiaryGoodModel =
                productSubsidiary[i].productoModel;
            bienesServiciosModel.subsidiaryGoodType =
                productSubsidiary[i].productoType;
            bienesServiciosModel.subsidiaryGoodSize =
                productSubsidiary[i].productoSize;
            bienesServiciosModel.subsidiaryGoodStock =
                productSubsidiary[i].productoStock;
            bienesServiciosModel.subsidiaryGoodMeasure =
                productSubsidiary[i].productoMeasure;
            bienesServiciosModel.subsidiaryGoodRating =
                productSubsidiary[i].productoRating;
            bienesServiciosModel.subsidiaryGoodUpdated =
                productSubsidiary[i].productoUpdated;
            bienesServiciosModel.subsidiaryGoodStatus =
                productSubsidiary[i].productoStatus;
            bienesServiciosModel.tipo = 'bienes';

            listGeneral.add(bienesServiciosModel);
          }
        }
        //Servicios
        for (var j = 0; j < serviceSubsidiary.length; j++) {
          final bienesServiciosModel = BienesServiciosModel();

          bienesServiciosModel.idSubsidiaryservice =
              serviceSubsidiary[j].idSubsidiaryservice;
          bienesServiciosModel.idSubsidiary = serviceSubsidiary[j].idSubsidiary;
          bienesServiciosModel.idService = serviceSubsidiary[j].idService;
          bienesServiciosModel.subsidiaryServiceName =
              serviceSubsidiary[j].subsidiaryServiceName;
          bienesServiciosModel.subsidiaryServiceDescription =
              serviceSubsidiary[j].subsidiaryServiceDescription;
          bienesServiciosModel.subsidiaryServicePrice =
              serviceSubsidiary[j].subsidiaryServicePrice;
          bienesServiciosModel.subsidiaryServiceCurrency =
              serviceSubsidiary[j].subsidiaryServiceCurrency;
          bienesServiciosModel.subsidiaryServiceImage =
              serviceSubsidiary[j].subsidiaryServiceImage;
          bienesServiciosModel.subsidiaryServiceRating =
              serviceSubsidiary[j].subsidiaryServiceRating;
          bienesServiciosModel.subsidiaryServiceUpdated =
              serviceSubsidiary[j].subsidiaryServiceUpdated;
          bienesServiciosModel.subsidiaryServiceStatus =
              serviceSubsidiary[j].subsidiaryServiceStatus;
          bienesServiciosModel.tipo = 'servicios';

          listGeneral.add(bienesServiciosModel);
        }
      }
    } else {
      for (var i = 0; i < productSubsidiary.length; i++) {
        if (productSubsidiary[i].idProducto != '1') {
          final bienesServiciosModel = BienesServiciosModel();

          //Para Bienes
          bienesServiciosModel.idSubsidiarygood =
              productSubsidiary[i].idProducto;
          bienesServiciosModel.idSubsidiary = productSubsidiary[i].idSubsidiary;
          bienesServiciosModel.idGood = productSubsidiary[i].idGood;
          bienesServiciosModel.idItemsubcategory =
              productSubsidiary[i].idItemsubcategory;
          bienesServiciosModel.subsidiaryGoodName =
              productSubsidiary[i].productoName;
          bienesServiciosModel.subsidiaryGoodPrice =
              productSubsidiary[i].productoPrice;
          bienesServiciosModel.subsidiaryGoodCurrency =
              productSubsidiary[i].productoCurrency;
          bienesServiciosModel.subsidiaryGoodImage =
              productSubsidiary[i].productoImage;
          bienesServiciosModel.subsidiaryGoodCharacteristics =
              productSubsidiary[i].productoCharacteristics;
          bienesServiciosModel.subsidiaryGoodBrand =
              productSubsidiary[i].productoBrand;
          bienesServiciosModel.subsidiaryGoodModel =
              productSubsidiary[i].productoModel;
          bienesServiciosModel.subsidiaryGoodType =
              productSubsidiary[i].productoType;
          bienesServiciosModel.subsidiaryGoodSize =
              productSubsidiary[i].productoSize;
          bienesServiciosModel.subsidiaryGoodStock =
              productSubsidiary[i].productoStock;
          bienesServiciosModel.subsidiaryGoodMeasure =
              productSubsidiary[i].productoMeasure;
          bienesServiciosModel.subsidiaryGoodRating =
              productSubsidiary[i].productoRating;
          bienesServiciosModel.subsidiaryGoodUpdated =
              productSubsidiary[i].productoUpdated;
          bienesServiciosModel.subsidiaryGoodStatus =
              productSubsidiary[i].productoStatus;
          bienesServiciosModel.tipo = 'bienes';

          listGeneral.add(bienesServiciosModel);
        }
      }
      //Servicios
      for (var j = 0; j < serviceSubsidiary.length; j++) {
        final bienesServiciosModel = BienesServiciosModel();

        bienesServiciosModel.idSubsidiaryservice =
            serviceSubsidiary[j].idSubsidiaryservice;
        bienesServiciosModel.idSubsidiary = serviceSubsidiary[j].idSubsidiary;
        bienesServiciosModel.idService = serviceSubsidiary[j].idService;
        bienesServiciosModel.subsidiaryServiceName =
            serviceSubsidiary[j].subsidiaryServiceName;
        bienesServiciosModel.subsidiaryServiceDescription =
            serviceSubsidiary[j].subsidiaryServiceDescription;
        bienesServiciosModel.subsidiaryServicePrice =
            serviceSubsidiary[j].subsidiaryServicePrice;
        bienesServiciosModel.subsidiaryServiceCurrency =
            serviceSubsidiary[j].subsidiaryServiceCurrency;
        bienesServiciosModel.subsidiaryServiceImage =
            serviceSubsidiary[j].subsidiaryServiceImage;
        bienesServiciosModel.subsidiaryServiceRating =
            serviceSubsidiary[j].subsidiaryServiceRating;
        bienesServiciosModel.subsidiaryServiceUpdated =
            serviceSubsidiary[j].subsidiaryServiceUpdated;
        bienesServiciosModel.subsidiaryServiceStatus =
            serviceSubsidiary[j].subsidiaryServiceStatus;
        bienesServiciosModel.tipo = 'servicios';

        listGeneral.add(bienesServiciosModel);
      }
    }

    return listGeneral;
  }

//   void detalleProductosPorIdSubsidiaryGood(String id) async {
//     _detailsproductoController.sink
//         .add(await productoDatabase.obtenerProductoPorIdSubsidiaryGood(id));
//     await productosApi.detailsProductoPorIdSubsidiaryGood(id);
//     _detailsproductoController.sink
//         .add(await productoDatabase.obtenerProductoPorIdSubsidiaryGood(id));
//   }
//

//Para listar las valoraciones por idProducto
void listarValoracionPorIdProducto(String idProducto) async {
      _valoracionController.sink.add(await valoracionProductoDb.obtenerValoracionXIdProducto(idProducto));
    await productosApi.listarValoracionPorIdProducto(idProducto);
    _valoracionController.sink.add(await valoracionProductoDb.obtenerValoracionXIdProducto(idProducto));
  }
}
