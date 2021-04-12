import 'package:bufi/src/api/busqueda/busqueda_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaXSucursalBloc {
  final busquedaApi = BusquedaApi();
  final productoDb = ProductoDatabase();
  final subisdiaryServiceDb = SubsidiaryServiceDatabase();

  final busquedaXSucursalController =
      BehaviorSubject<List<BusquedaPorSucursalModel>>();

  // final busquedaServicioXSucursalController =
  //     BehaviorSubject<List<BusquedaServicioPorSucursalModel>>();

  Stream<List<BusquedaPorSucursalModel>> get busquedaXSucursalStream =>
      busquedaXSucursalController.stream;

  // Stream<List<BusquedaServicioPorSucursalModel>>
  //     get busquedaServXSucursalStream =>
  //         busquedaServicioXSucursalController.stream;

  void dispose() {
    busquedaXSucursalController?.close();
    //busquedaServicioXSucursalController?.close();
  }

  void obtenerResultadoBusquedaXSucursal(
      String idSucursal, String query) async {
    busquedaXSucursalController.sink.add([]);
    busquedaXSucursalController.sink
        .add(await obtnerResultBusquedaPorSucursal(idSucursal, query));
  }

  Future<List<BusquedaPorSucursalModel>> obtnerResultBusquedaPorSucursal(
      String idSucursal, String query) async {
    List<BusquedaPorSucursalModel> listaGeneral = [];
    final busqXSucursalModel = BusquedaPorSucursalModel();

    //función para obtener los productos por sucursal
    final listProductos = await productoDb
        .obtenerProductosPorIdSubsidiaryPorQuery(idSucursal, query);
    //Lista vacía
    final List<ProductoModel> listProductoModel = [];

    //función para obtener los servicios por sucursal
    final listServicios = await subisdiaryServiceDb
        .obtenerServiciosPorIdSubsidiaryPorQuery(idSucursal, query);
    //Lista vacía
    final List<SubsidiaryServiceModel> listServicioModel = [];

    if (listProductos.length > 0) {
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
        productoModel.productoCharacteristics =
            listProductos[i].productoCharacteristics;
        productoModel.productoBrand = listProductos[i].productoBrand;
        productoModel.productoModel = listProductos[i].productoModel;
        productoModel.productoType = listProductos[i].productoType;
        productoModel.productoSize = listProductos[i].productoSize;
        productoModel.productoMeasure = listProductos[i].productoMeasure;
        productoModel.productoStock = listProductos[i].productoStock;
        productoModel.productoRating = listProductos[i].productoRating;
        productoModel.productoUpdated = listProductos[i].productoUpdated;
        productoModel.productoStatus = listProductos[i].productoStatus;

        listProductoModel.add(productoModel);
      }
    } else if (listServicios.length > 0) {
      //Recorremos la lista general
      for (var j = 0; j < listServicios.length; j++) {
        final servicioModel = SubsidiaryServiceModel();
        servicioModel.idSubsidiaryservice =
            listServicios[j].idSubsidiaryservice;
        servicioModel.idSubsidiary = listServicios[j].idSubsidiary;
        servicioModel.idService = listServicios[j].idService;
        servicioModel.subsidiaryServiceName =
            listServicios[j].subsidiaryServiceName;
        servicioModel.subsidiaryServiceDescription =
            listServicios[j].subsidiaryServiceDescription;
        servicioModel.subsidiaryServicePrice =
            listServicios[j].subsidiaryServicePrice;
        servicioModel.subsidiaryServiceCurrency =
            listServicios[j].subsidiaryServiceCurrency;
        servicioModel.subsidiaryServiceImage =
            listServicios[j].subsidiaryServiceImage;
        servicioModel.subsidiaryServiceRating =
            listServicios[j].subsidiaryServiceRating;
        servicioModel.subsidiaryServiceUpdated =
            listServicios[j].subsidiaryServiceUpdated;
        servicioModel.subsidiaryServiceStatus =
            listServicios[j].subsidiaryServiceStatus;
        servicioModel.subsidiaryServiceFavourite =
            listServicios[j].subsidiaryServiceFavourite;

        listServicioModel.add(servicioModel);
      }
    }

    busqXSucursalModel.listProducto = listProductoModel;
    busqXSucursalModel.listServicios = listServicioModel;
    listaGeneral.add(busqXSucursalModel);

    return listaGeneral;
  }
}
