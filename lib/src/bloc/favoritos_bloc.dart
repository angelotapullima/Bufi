import 'package:bufi/src/api/point_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:rxdart/rxdart.dart';

class PointsBloc {
  final pointApi = PointApi();
  final productoDb = ProductoDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();
  final _listPoints = BehaviorSubject<List<SubsidiaryModel>>();
  final _favController = BehaviorSubject<List<PointModel>>();
  //final _prodController = BehaviorSubject<List<ProductoModel>>();
  

  Stream<List<SubsidiaryModel>> get pointsStrema => _listPoints.stream;
  Stream<List<PointModel>> get favProductoStrem => _favController.stream;

  List<SubsidiaryModel> get page => _listPoints.value;

  dispose() {
    _listPoints?.close();
    _favController?.close();
    //_prodController?.close();
  }

//Sucursales favoritas:
  void obtenerPoints() async {
    _listPoints.sink.add(await subsidiaryDatabase.obtenerSubsidiaryFavoritas());
  }

  void savePoints(String id) async {
    await subsidiaryDatabase.obtenerSubsidiaryFavoritas();
    await pointApi.savePoint(id);
    obtenerPoints();
  }

  void deletePoints(String id) async {
    await subsidiaryDatabase.obtenerSubsidiaryFavoritas();
    await pointApi.deletePoint(id);
    obtenerPoints();
  }

  //Productos y Sucursales Fav
  void obtenerPointsProductosXSucursal() async {
    _favController.sink.add(await favoritoPorSucursal());
  }

   //Servicios y Sucursales Fav
  void obtenerPointsServiciosXSucursal() async {
    _favController.sink.add(await favoritoPorSucursal());
  }

  //  void deletePointsProductosXSucursal() async {
  //   _favController.sink.add(await productoDb.);
  // }
}



Future<List<PointModel>> favoritoPorSucursal() async { 
  final sucursalDb = SubsidiaryDatabase();
  final productoDb = ProductoDatabase();

  final listGeneral = List<PointModel>();
  //Obtener lista de sucursales favoritas
  final listsucursal = await sucursalDb.obtenerSubsidiaryFavoritas();
  for (var k = 0; k < listsucursal.length; k++) {
    final pointModel = PointModel();
    pointModel.idSubsidiary = listsucursal[k].idSubsidiary;
    pointModel.idCompany = listsucursal[k].idCompany;
    pointModel.subsidiaryName = listsucursal[k].subsidiaryName;
    pointModel.subsidiaryCellphone = listsucursal[k].subsidiaryCellphone;
    pointModel.subsidiaryCellphone2 = listsucursal[k].subsidiaryCellphone2;
    pointModel.subsidiaryEmail = listsucursal[k].subsidiaryEmail;
    pointModel.subsidiaryCoordX = listsucursal[k].subsidiaryCoordX;
    pointModel.subsidiaryCoordY = listsucursal[k].subsidiaryCoordY;
    pointModel.subsidiaryOpeningHours = listsucursal[k].subsidiaryOpeningHours;
    pointModel.subsidiaryPrincipal = listsucursal[k].subsidiaryPrincipal;
    pointModel.subsidiaryStatus = listsucursal[k].subsidiaryStatus;
    pointModel.subsidiaryAddress = listsucursal[k].subsidiaryAddress;
    pointModel.subsidiaryImg = listsucursal[k].subsidiaryImg;

 //Creamos la lista para agregar los productos obtenidos por sucursal
    final listProductosFavoritos = List<ProductoModel>();
   
    final listprod = await productoDb.obtenerProductosFavoritosPorIdSubsidiary(listsucursal[k].idSubsidiary);
    for (var i = 0; i < listprod.length; i++) {
      final productoModel = ProductoModel();
      productoModel.idProducto = listprod[i].idProducto;
      productoModel.idSubsidiary = listprod[i].idSubsidiary;
      productoModel.idGood = listprod[i].idGood;
      productoModel.idItemsubcategory = listprod[i].idItemsubcategory;
      productoModel.productoName = listprod[i].productoName;
      productoModel.productoPrice = listprod[i].productoPrice;
      productoModel.productoCurrency = listprod[i].productoCurrency;
      productoModel.productoImage = listprod[i].productoImage;
      productoModel.productoCharacteristics =listprod[i].productoCharacteristics;
      productoModel.productoBrand = listprod[i].productoBrand;
      productoModel.productoModel = listprod[i].productoModel;
      productoModel.productoType = listprod[i].productoType;
      productoModel.productoSize = listprod[i].productoSize;
      productoModel.productoStock = listprod[i].productoStock;
      productoModel.productoMeasure = listprod[i].productoMeasure;
      productoModel.productoRating = listprod[i].productoRating;
      productoModel.productoUpdated = listprod[i].productoUpdated;
      productoModel.productoStatus = listprod[i].productoStatus;
      productoModel.productoFavourite = '1';

      listProductosFavoritos.add(productoModel);
    }

    //Creamos la lista para agregar los servicios obtenidos por sucursal
    final listServiciosFavModel = List<SubsidiaryServiceModel>();
     final servicioDb = SubsidiaryServiceDatabase();
   
    final listServicioFav = await servicioDb.obtenerSubsidiarysServicesFavoritosPorIdSubsidiary(listsucursal[k].idSubsidiary);
    for (var j = 0; j < listServicioFav.length; j++) {
      final servicioModel = SubsidiaryServiceModel();
      servicioModel.idSubsidiaryservice = listServicioFav[j].idSubsidiaryservice;
      servicioModel.idSubsidiary = listServicioFav[j].idSubsidiary;
      servicioModel.idService = listServicioFav[j].idService;
      servicioModel.idItemsubcategory = listServicioFav[j].idItemsubcategory;
      servicioModel.subsidiaryServiceName = listServicioFav[j].subsidiaryServiceName;
      servicioModel.subsidiaryServicePrice = listServicioFav[j].subsidiaryServicePrice;
      servicioModel.subsidiaryServiceDescription = listServicioFav[j].subsidiaryServiceDescription;
      servicioModel.subsidiaryServiceCurrency = listServicioFav[j].subsidiaryServiceCurrency;
      servicioModel.subsidiaryServiceImage = listServicioFav[j].subsidiaryServiceImage;
      servicioModel.subsidiaryServiceRating = listServicioFav[j].subsidiaryServiceRating;
      servicioModel.subsidiaryServiceUpdated = listServicioFav[j].subsidiaryServiceUpdated;
      servicioModel.subsidiaryServiceStatus = listServicioFav[j].subsidiaryServiceStatus;
      servicioModel.subsidiaryServiceFavourite = '1';

      listServiciosFavModel.add(servicioModel);
    }
    pointModel.listProducto = listProductosFavoritos;
    pointModel.listServicio = listServiciosFavModel;
    listGeneral.add(pointModel);
  }
  return listGeneral;
}


// class FavoritosPointBloc {

//   final subsidiaryGoodDatabase = SubisdiaryGoodDatabase();
//   final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();

//   final _subsidiaryGoodsFavoritosController = new BehaviorSubject<List<SubsidiaryGoodModel>>();
//   final _subsidiaryServicesFavoritosController = new BehaviorSubject<List<SubsidiaryServiceModel>>();

//   Stream<List<SubsidiaryGoodModel>> get subsidiarygoodFavoritosStream =>
//       _subsidiaryGoodsFavoritosController.stream;

//    Stream<List<SubsidiaryServiceModel>> get subsidiaryserviceFavoritosStream =>
//       _subsidiaryServicesFavoritosController.stream;

//   dispose() {

//      _subsidiaryGoodsFavoritosController?.close();
//       _subsidiaryServicesFavoritosController?.close();

//   }

//   void obtenerSucursalBienesFavoritos() async {
//     _subsidiaryGoodsFavoritosController.sink
//         .add(await subsidiaryGoodDatabase.obtenerSubsidiarysGoodsFavoritos());
//   }

//   void obtenerSucursalServiciosFavoritos() async {
//     _subsidiaryServicesFavoritosController.sink
//         .add(await subsidiaryServiceDatabase.obtenerSubsidiarysServicesFavoritos());
//   }

// }
