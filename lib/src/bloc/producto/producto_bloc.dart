

import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/subjects.dart';

class ProductoBloc {
  final productoDatabase = ProductoDatabase();
  final serviceDatabase = SubsidiaryServiceDatabase();
  final productosApi = ProductosApi();
  final carritoDatabase = CarritoDb();

  final _productosSubsidiaryCarritoController =
      BehaviorSubject<List<BienesServiciosModel>>();
  final _productoController = BehaviorSubject<List<ProductoModel>>();
  final _detailsproductoController = BehaviorSubject<List<ProductoModel>>();

  Stream<List<BienesServiciosModel>> get productoSubsidiaryCarritoStream =>
      _productosSubsidiaryCarritoController.stream;
  Stream<List<ProductoModel>> get detailsproductostream =>
      _detailsproductoController.stream;
  Stream<List<ProductoModel>> get productoStream => _productoController.stream;

  void dispose() {
    _productosSubsidiaryCarritoController?.close();
    _detailsproductoController?.close();
    _productoController?.close();
  }

  void listarProductosPorSucursalCarrito(String id) async {
    _productosSubsidiaryCarritoController.sink.add(await datosSucursal(id));
    await productosApi.listarProductosPorSucursal(id);
    _productosSubsidiaryCarritoController.sink.add(await datosSucursal(id));
  }

  void listarProductosPorSucursal(String id) async {
    _productoController.sink
        .add(await productoDatabase.obtenerProductosPorIdSubsidiary(id));
    await productosApi.listarProductosPorSucursal(id);
    _productoController.sink
        .add(await productoDatabase.obtenerProductosPorIdSubsidiary(id));
  }

  Future<List<BienesServiciosModel>> datosSucursal(String idSubsidiary) async {
    final listGeneral = List<BienesServiciosModel>();

    final productSubsidiary =
        await productoDatabase.obtenerProductosPorIdSubsidiary(idSubsidiary);
    final serviceSubsidiary =
        await serviceDatabase.obtenerServiciosPorIdSucursal(idSubsidiary);
    final carritoList = await carritoDatabase.obtenerProductoXCarrito();

    if (carritoList.length > 0) {
      for (var x = 0; x < carritoList.length; x++) {


        for (var i = 0; i < productSubsidiary.length; i++) {


          if(carritoList[x].idSubsidiaryGood != productSubsidiary[i].idProducto){

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
    }else{


      for (var i = 0; i < productSubsidiary.length; i++) {


        if(productSubsidiary[i].idProducto != '1'){
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

  void detalleProductosPorIdSubsidiaryGood(String id) async {
    _detailsproductoController.sink
        .add(await productoDatabase.obtenerProductoPorIdSubsidiaryGood(id));
    await productosApi.detailsProductoPorIdSubsidiaryGood(id);
    _detailsproductoController.sink
        .add(await productoDatabase.obtenerProductoPorIdSubsidiaryGood(id));
  }
}
