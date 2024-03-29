import 'package:bufi/src/api/notificaciones_api.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/carritoDelivery_db.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/detallePedido_database.dart';
import 'package:bufi/src/database/direccion_database.dart';
import 'package:bufi/src/database/historial_db.dart';
import 'package:bufi/src/database/notificaciones_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/searchHistory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/database/sugerenciaBusqueda_db.dart';
import 'package:bufi/src/database/tipo_pago_database.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/direccionModel.dart';
import 'package:bufi/src/models/notificacionModel.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/searchHistoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/models/sugerenciaBusquedaModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.Dart';



void showToast1(String msg, int duration, ToastGravity gravity) {
  Fluttertoast.showToast(
      msg: '$msg', toastLength: Toast.LENGTH_SHORT, gravity: gravity, timeInSecForIosWeb: duration, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

//Guardar solo sucursal
void guardarSubsidiaryFavorito(BuildContext context, SubsidiaryModel sucursalModel) async {
  final pointsBloc = ProviderBloc.points(context);
  //final subsidiaryBloc = ProviderBloc.sucursal(context);
  //final savePointApi = PointApi();

  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
  final sucursalDataBase = SubsidiaryDatabase();

  subsidiaryModel.idSubsidiary = sucursalModel.idSubsidiary;
  subsidiaryModel.idCompany = sucursalModel.idCompany;
  subsidiaryModel.subsidiaryName = sucursalModel.subsidiaryName;
  subsidiaryModel.subsidiaryCellphone = sucursalModel.subsidiaryCellphone;
  subsidiaryModel.subsidiaryCellphone2 = sucursalModel.subsidiaryCellphone2;
  subsidiaryModel.subsidiaryEmail = sucursalModel.subsidiaryEmail;
  subsidiaryModel.subsidiaryCoordX = sucursalModel.subsidiaryCoordX;
  subsidiaryModel.subsidiaryCoordY = sucursalModel.subsidiaryCoordY;
  subsidiaryModel.subsidiaryOpeningHours = sucursalModel.subsidiaryOpeningHours;
  subsidiaryModel.subsidiaryPrincipal = sucursalModel.subsidiaryPrincipal;
  subsidiaryModel.subsidiaryStatus = sucursalModel.subsidiaryStatus;
  subsidiaryModel.subsidiaryFavourite = "1";

  await sucursalDataBase.updateSubsidiary(subsidiaryModel);

  //subsidiaryBloc.obtenerSucursalporIdCompany(subsidiaryModel.idSubsidiary);
  pointsBloc.obtenerPoints();
  //llama a la funcion que dibuja todo el widget en pointPage
  pointsBloc.obtenerPointsProductosXSucursal();
  // pointsBloc.savePoints(sucursalModel.idSubsidiary);

  //savePointApi.savePoint(subsidiaryModel.idSubsidiary);
}

//Cuando se elimina la sucursal desde pointPage
void quitarSubsidiaryFavoritodePointPage(BuildContext context, PointModel pointModel) async {
  final sucursalBloc = ProviderBloc.sucursal(context);
  final pointsBloc = ProviderBloc.points(context);

  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
  final sucursalDataBase = SubsidiaryDatabase();

  subsidiaryModel.idSubsidiary = pointModel.idSubsidiary;
  subsidiaryModel.idCompany = pointModel.idCompany;
  subsidiaryModel.subsidiaryName = pointModel.subsidiaryName;
  subsidiaryModel.subsidiaryCellphone = pointModel.subsidiaryCellphone;
  subsidiaryModel.subsidiaryCellphone2 = pointModel.subsidiaryCellphone2;
  subsidiaryModel.subsidiaryEmail = pointModel.subsidiaryEmail;
  subsidiaryModel.subsidiaryCoordX = pointModel.subsidiaryCoordX;
  subsidiaryModel.subsidiaryCoordY = pointModel.subsidiaryCoordY;
  subsidiaryModel.subsidiaryOpeningHours = pointModel.subsidiaryOpeningHours;
  subsidiaryModel.subsidiaryPrincipal = pointModel.subsidiaryPrincipal;
  subsidiaryModel.subsidiaryStatus = pointModel.subsidiaryStatus;
  subsidiaryModel.subsidiaryFavourite = "0";

  final res = await sucursalDataBase.updateSubsidiary(subsidiaryModel);
  print('update $res');

  sucursalBloc.obtenerSucursalporIdCompany(pointModel.idSubsidiary);
  pointsBloc.obtenerPoints();
  pointsBloc.obtenerPointsProductosXSucursal();
  //deletePoint.deletePoint(subsidiaryModel.idSubsidiary);
}

void guardarProductoFavorito(BuildContext context, ProductoModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);
  final bienesBloc = ProviderBloc.bienesServicios(context);
  final productoBloc = ProviderBloc.productos(context);
  final sucursalNegocio = ProviderBloc.sucursal(context);

  final productoModel = ProductoModel();
  final productoDb = ProductoDatabase();
  final sucursalDataBase = SubsidiaryDatabase();

  productoModel.idProducto = dataModel.idProducto;
  productoModel.idSubsidiary = dataModel.idSubsidiary;
  productoModel.idGood = dataModel.idGood;
  productoModel.idItemsubcategory = dataModel.idItemsubcategory;
  productoModel.productoName = dataModel.productoName;
  productoModel.productoPrice = dataModel.productoPrice;
  productoModel.productoCurrency = dataModel.productoCurrency;
  productoModel.productoImage = dataModel.productoImage;
  productoModel.productoCharacteristics = dataModel.productoCharacteristics;
  productoModel.productoBrand = dataModel.productoBrand;
  productoModel.productoModel = dataModel.productoModel;
  productoModel.productoType = dataModel.productoType;
  productoModel.productoSize = dataModel.productoSize;
  productoModel.productoStock = dataModel.productoStock;
  productoModel.productoMeasure = dataModel.productoMeasure;
  productoModel.productoRating = dataModel.productoRating;
  productoModel.productoUpdated = dataModel.productoUpdated;
  productoModel.productoStatus = dataModel.productoStatus;
  productoModel.productoFavourite = "1";

//Se actualiza el producto con los datos enviados
  await productoDb.updateProducto(productoModel);

  //Obtenemos la lista de sucursales por id
  final sucursal = await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
  final subModel = SubsidiaryModel();
  subModel.idSubsidiary = sucursal[0].idSubsidiary;
  subModel.idCompany = sucursal[0].idCompany;
  subModel.subsidiaryName = sucursal[0].subsidiaryName;
  subModel.subsidiaryCellphone = sucursal[0].subsidiaryCellphone;
  subModel.subsidiaryCellphone2 = sucursal[0].subsidiaryCellphone2;
  subModel.subsidiaryEmail = sucursal[0].subsidiaryEmail;
  subModel.subsidiaryCoordX = sucursal[0].subsidiaryCoordX;
  subModel.subsidiaryCoordY = sucursal[0].subsidiaryCoordY;
  subModel.subsidiaryOpeningHours = sucursal[0].subsidiaryOpeningHours;
  subModel.subsidiaryPrincipal = sucursal[0].subsidiaryPrincipal;
  subModel.subsidiaryStatus = sucursal[0].subsidiaryStatus;
  subModel.subsidiaryFavourite = '1';

  await sucursalDataBase.updateSubsidiary(subModel);

  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsProductosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  bienesBloc.obtenerBienesServiciosResumen();
  //Para dibujar el widget de favorito en la vista de detalle de negocio
  sucursalNegocio.obtenerSucursalporIdCompany(sucursal[0].idCompany);
  //Para dibujar el widget de favorito en la vista de productos por sucursal
  productoBloc.listarProductosPorSucursal(dataModel.idSubsidiary);
}

void quitarProductoFavorito(BuildContext context, ProductoModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);
  final bienesBloc = ProviderBloc.bienesServicios(context);
  final productoBloc = ProviderBloc.productos(context);
  // final deletePoint = PointApi();

  final productoDb = ProductoDatabase();

  final productoModel = ProductoModel();
  productoModel.idProducto = dataModel.idProducto;
  productoModel.idSubsidiary = dataModel.idSubsidiary;
  productoModel.idGood = dataModel.idGood;
  productoModel.idItemsubcategory = dataModel.idItemsubcategory;
  productoModel.productoName = dataModel.productoName;
  productoModel.productoPrice = dataModel.productoPrice;
  productoModel.productoCurrency = dataModel.productoCurrency;
  productoModel.productoImage = dataModel.productoImage;
  productoModel.productoCharacteristics = dataModel.productoCharacteristics;
  productoModel.productoBrand = dataModel.productoBrand;
  productoModel.productoModel = dataModel.productoModel;
  productoModel.productoType = dataModel.productoType;
  productoModel.productoSize = dataModel.productoSize;
  productoModel.productoStock = dataModel.productoStock;
  productoModel.productoMeasure = dataModel.productoMeasure;
  productoModel.productoRating = dataModel.productoRating;
  productoModel.productoUpdated = dataModel.productoUpdated;
  productoModel.productoStatus = dataModel.productoStatus;
  productoModel.productoFavourite = '0';

  await productoDb.updateProducto(productoModel);

  // final sucursal =await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
  // final subModel = SubsidiaryModel();
  // subModel.idSubsidiary = sucursal[0].idSubsidiary;
  // subModel.idCompany = sucursal[0].idCompany;
  // subModel.subsidiaryName = sucursal[0].subsidiaryName;
  // subModel.subsidiaryCellphone = sucursal[0].subsidiaryCellphone;
  // subModel.subsidiaryCellphone2 = sucursal[0].subsidiaryCellphone2;
  // subModel.subsidiaryEmail = sucursal[0].subsidiaryEmail;
  // subModel.subsidiaryCoordX = sucursal[0].subsidiaryCoordX;
  // subModel.subsidiaryCoordY = sucursal[0].subsidiaryCoordY;
  // subModel.subsidiaryOpeningHours = sucursal[0].subsidiaryOpeningHours;
  // subModel.subsidiaryPrincipal = sucursal[0].subsidiaryPrincipal;
  // subModel.subsidiaryStatus = sucursal[0].subsidiaryStatus;
  // subModel.subsidiaryFavourite = '0';

  // await sucursalDataBase.updateSubsidiary(subModel);

  // await sucursalDataBase.obtenerSubsidiaryPorId(productoModel.idSubsidiary);
  // pointsProdBloc.obtenerPointsProductosXSucursal();
  // productoDb.obtenerProductosFavoritos();

  pointsProdBloc.obtenerPointsProductosXSucursal();
  bienesBloc.obtenerBienesServiciosResumen();
  //Para dibujar el widget de favorito en la vista de productos por sucursal
  productoBloc.listarProductosPorSucursal(dataModel.idSubsidiary);
}

void guardarServicioFavorito(BuildContext context, SubsidiaryServiceModel dataModel) async {
  final servicioModel = SubsidiaryServiceModel();
  final subservicesDb = SubsidiaryServiceDatabase();
  final sucursalDataBase = SubsidiaryDatabase();

  final pointsProdBloc = ProviderBloc.points(context);
  final serviciosBloc = ProviderBloc.bienesServicios(context);
  final sucursalNegocio = ProviderBloc.sucursal(context);
  final serviceBloc = ProviderBloc.servi(context);
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);

  servicioModel.idSubsidiaryservice = dataModel.idSubsidiaryservice;
  servicioModel.idSubsidiary = dataModel.idSubsidiary;
  servicioModel.idService = dataModel.idService;
  servicioModel.idItemsubcategory = dataModel.idItemsubcategory;
  servicioModel.subsidiaryServiceName = dataModel.subsidiaryServiceName;
  servicioModel.subsidiaryServicePrice = dataModel.subsidiaryServicePrice;
  servicioModel.subsidiaryServiceDescription = dataModel.subsidiaryServiceDescription;
  servicioModel.subsidiaryServiceCurrency = dataModel.subsidiaryServiceCurrency;
  servicioModel.subsidiaryServiceImage = dataModel.subsidiaryServiceImage;
  servicioModel.subsidiaryServiceRating = dataModel.subsidiaryServiceRating;
  servicioModel.subsidiaryServiceUpdated = dataModel.subsidiaryServiceUpdated;
  servicioModel.subsidiaryServiceStatus = dataModel.subsidiaryServiceStatus;
  servicioModel.subsidiaryServiceFavourite = "1";

  await subservicesDb.updateSubsidiaryService(servicioModel);

  //Obtenemos la lista de sucursales por id
  final sucursal = await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
  final subModel = SubsidiaryModel();
  subModel.idSubsidiary = sucursal[0].idSubsidiary;
  subModel.idCompany = sucursal[0].idCompany;
  subModel.subsidiaryName = sucursal[0].subsidiaryName;
  subModel.subsidiaryCellphone = sucursal[0].subsidiaryCellphone;
  subModel.subsidiaryCellphone2 = sucursal[0].subsidiaryCellphone2;
  subModel.subsidiaryEmail = sucursal[0].subsidiaryEmail;
  subModel.subsidiaryCoordX = sucursal[0].subsidiaryCoordX;
  subModel.subsidiaryCoordY = sucursal[0].subsidiaryCoordY;
  subModel.subsidiaryOpeningHours = sucursal[0].subsidiaryOpeningHours;
  subModel.subsidiaryPrincipal = sucursal[0].subsidiaryPrincipal;
  subModel.subsidiaryStatus = sucursal[0].subsidiaryStatus;
  subModel.subsidiaryFavourite = '1';

  await sucursalDataBase.updateSubsidiary(subModel);
  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsServiciosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  serviciosBloc.obtenerBienesServiciosResumen();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de detalle de negocio
  sucursalNegocio.obtenerSucursalporIdCompany(sucursal[0].idCompany);
  //Para dibujar el widget de favorito en la vista de servicios por sucursal
  serviceBloc.listarServiciosPorSucursal(sucursal[0].idSubsidiary);
}

void quitarServicioFavorito(BuildContext context, SubsidiaryServiceModel dataModel) async {
  final servicioModel = SubsidiaryServiceModel();
  final subservicesDb = SubsidiaryServiceDatabase();

  final pointsProdBloc = ProviderBloc.points(context);
  final serviciosBloc = ProviderBloc.bienesServicios(context);
  //final sucursalNegocio = ProviderBloc.sucursal(context);
  final serviceBloc = ProviderBloc.servi(context);
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);

  servicioModel.idSubsidiaryservice = dataModel.idSubsidiaryservice;
  servicioModel.idSubsidiary = dataModel.idSubsidiary;
  servicioModel.idService = dataModel.idService;
  servicioModel.idItemsubcategory = dataModel.idItemsubcategory;
  servicioModel.subsidiaryServiceName = dataModel.subsidiaryServiceName;
  servicioModel.subsidiaryServicePrice = dataModel.subsidiaryServicePrice;
  servicioModel.subsidiaryServiceDescription = dataModel.subsidiaryServiceDescription;
  servicioModel.subsidiaryServiceCurrency = dataModel.subsidiaryServiceCurrency;
  servicioModel.subsidiaryServiceImage = dataModel.subsidiaryServiceImage;
  servicioModel.subsidiaryServiceRating = dataModel.subsidiaryServiceRating;
  servicioModel.subsidiaryServiceUpdated = dataModel.subsidiaryServiceUpdated;
  servicioModel.subsidiaryServiceStatus = dataModel.subsidiaryServiceStatus;
  servicioModel.subsidiaryServiceFavourite = "0";

  await subservicesDb.updateSubsidiaryService(servicioModel);

  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsServiciosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  serviciosBloc.obtenerBienesServiciosResumen();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de servicios por sucursal
  serviceBloc.listarServiciosPorSucursal(dataModel.idSubsidiary);
}

//---------------"De acuerdo a lo que buscaste"-----------------------
void guardarProductoFavorito2(BuildContext context, BienesServiciosModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);
  final bienesBloc = ProviderBloc.bienesServicios(context);
  final productoBloc = ProviderBloc.productos(context);
  final sucursalNegocio = ProviderBloc.sucursal(context);
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);

  final productoModel = ProductoModel();
  final productoDb = ProductoDatabase();
  final sucursalDataBase = SubsidiaryDatabase();

  productoModel.idProducto = dataModel.idSubsidiarygood;
  productoModel.idSubsidiary = dataModel.idSubsidiary;
  productoModel.idGood = dataModel.idGood;
  productoModel.idItemsubcategory = dataModel.idItemsubcategory;
  productoModel.productoName = dataModel.subsidiaryGoodName;
  productoModel.productoPrice = dataModel.subsidiaryGoodPrice;
  productoModel.productoCurrency = dataModel.subsidiaryGoodCurrency;
  productoModel.productoImage = dataModel.subsidiaryGoodImage;
  productoModel.productoCharacteristics = dataModel.subsidiaryGoodCharacteristics;
  productoModel.productoBrand = dataModel.subsidiaryGoodBrand;
  productoModel.productoModel = dataModel.subsidiaryGoodModel;
  productoModel.productoType = dataModel.subsidiaryGoodType;
  productoModel.productoSize = dataModel.subsidiaryGoodSize;
  productoModel.productoStock = dataModel.subsidiaryGoodStock;
  productoModel.productoMeasure = dataModel.subsidiaryGoodMeasure;
  productoModel.productoRating = dataModel.subsidiaryGoodRating;
  productoModel.productoUpdated = dataModel.subsidiaryGoodUpdated;
  productoModel.productoStatus = dataModel.subsidiaryGoodStatus;
  productoModel.productoFavourite = "1";

//Se actualiza el producto con los datos enviados
  await productoDb.updateProducto(productoModel);

  //Obtenemos la lista de sucursales por id
  final sucursal = await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
  final subModel = SubsidiaryModel();
  subModel.idSubsidiary = sucursal[0].idSubsidiary;
  subModel.idCompany = sucursal[0].idCompany;
  subModel.subsidiaryName = sucursal[0].subsidiaryName;
  subModel.subsidiaryCellphone = sucursal[0].subsidiaryCellphone;
  subModel.subsidiaryCellphone2 = sucursal[0].subsidiaryCellphone2;
  subModel.subsidiaryEmail = sucursal[0].subsidiaryEmail;
  subModel.subsidiaryCoordX = sucursal[0].subsidiaryCoordX;
  subModel.subsidiaryCoordY = sucursal[0].subsidiaryCoordY;
  subModel.subsidiaryOpeningHours = sucursal[0].subsidiaryOpeningHours;
  subModel.subsidiaryPrincipal = sucursal[0].subsidiaryPrincipal;
  subModel.subsidiaryStatus = sucursal[0].subsidiaryStatus;
  subModel.subsidiaryFavourite = '1';

  await sucursalDataBase.updateSubsidiary(subModel);

  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsProductosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  bienesBloc.obtenerBienesServiciosResumen();
  //bienesBloc.obtenerServiciosAllPorCiudad();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de detalle de negocio
  sucursalNegocio.obtenerSucursalporIdCompany(sucursal[0].idCompany);
  //Para dibujar el widget de favorito en la vista de productos por sucursal
  productoBloc.listarProductosPorSucursal(dataModel.idSubsidiary);
}

void quitarProductoFavorito2(BuildContext context, BienesServiciosModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);
  final bienesBloc = ProviderBloc.bienesServicios(context);
  final productoBloc = ProviderBloc.productos(context);
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);

  final productoDb = ProductoDatabase();

  final productoModel = ProductoModel();
  productoModel.idProducto = dataModel.idSubsidiarygood;
  productoModel.idSubsidiary = dataModel.idSubsidiary;
  productoModel.idGood = dataModel.idGood;
  productoModel.idItemsubcategory = dataModel.idItemsubcategory;
  productoModel.productoName = dataModel.subsidiaryGoodName;
  productoModel.productoPrice = dataModel.subsidiaryGoodPrice;
  productoModel.productoCurrency = dataModel.subsidiaryGoodCurrency;
  productoModel.productoImage = dataModel.subsidiaryGoodImage;
  productoModel.productoCharacteristics = dataModel.subsidiaryGoodCharacteristics;
  productoModel.productoBrand = dataModel.subsidiaryGoodBrand;
  productoModel.productoModel = dataModel.subsidiaryGoodModel;
  productoModel.productoType = dataModel.subsidiaryGoodType;
  productoModel.productoSize = dataModel.subsidiaryGoodSize;
  productoModel.productoStock = dataModel.subsidiaryGoodStock;
  productoModel.productoMeasure = dataModel.subsidiaryGoodMeasure;
  productoModel.productoRating = dataModel.subsidiaryGoodRating;
  productoModel.productoUpdated = dataModel.subsidiaryGoodUpdated;
  productoModel.productoStatus = dataModel.subsidiaryGoodStatus;
  productoModel.productoFavourite = '0';

  await productoDb.updateProducto(productoModel);

  pointsProdBloc.obtenerPointsProductosXSucursal();
  bienesBloc.obtenerBienesServiciosResumen();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de productos por sucursal
  productoBloc.listarProductosPorSucursal(dataModel.idSubsidiary);
}

void guardarServicioFavorito2(BuildContext context, BienesServiciosModel dataModel) async {
  final servicioModel = SubsidiaryServiceModel();
  final subservicesDb = SubsidiaryServiceDatabase();
  final sucursalDataBase = SubsidiaryDatabase();

  final pointsProdBloc = ProviderBloc.points(context);
  final serviciosBloc = ProviderBloc.bienesServicios(context);
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);
  final sucursalNegocio = ProviderBloc.sucursal(context);
  final serviceBloc = ProviderBloc.servi(context);

  servicioModel.idSubsidiaryservice = dataModel.idSubsidiaryservice;
  servicioModel.idSubsidiary = dataModel.idSubsidiary;
  servicioModel.idService = dataModel.idService;
  servicioModel.idItemsubcategory = dataModel.idItemsubcategory;
  servicioModel.subsidiaryServiceName = dataModel.subsidiaryServiceName;
  servicioModel.subsidiaryServicePrice = dataModel.subsidiaryServicePrice;
  servicioModel.subsidiaryServiceDescription = dataModel.subsidiaryServiceDescription;
  servicioModel.subsidiaryServiceCurrency = dataModel.subsidiaryServiceCurrency;
  servicioModel.subsidiaryServiceImage = dataModel.subsidiaryServiceImage;
  servicioModel.subsidiaryServiceRating = dataModel.subsidiaryServiceRating;
  servicioModel.subsidiaryServiceUpdated = dataModel.subsidiaryServiceUpdated;
  servicioModel.subsidiaryServiceStatus = dataModel.subsidiaryServiceStatus;
  servicioModel.subsidiaryServiceFavourite = "1";

  await subservicesDb.updateSubsidiaryService(servicioModel);

  //Obtenemos la lista de sucursales por id
  final sucursal = await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
  final subModel = SubsidiaryModel();
  subModel.idSubsidiary = sucursal[0].idSubsidiary;
  subModel.idCompany = sucursal[0].idCompany;
  subModel.subsidiaryName = sucursal[0].subsidiaryName;
  subModel.subsidiaryCellphone = sucursal[0].subsidiaryCellphone;
  subModel.subsidiaryCellphone2 = sucursal[0].subsidiaryCellphone2;
  subModel.subsidiaryEmail = sucursal[0].subsidiaryEmail;
  subModel.subsidiaryCoordX = sucursal[0].subsidiaryCoordX;
  subModel.subsidiaryCoordY = sucursal[0].subsidiaryCoordY;
  subModel.subsidiaryOpeningHours = sucursal[0].subsidiaryOpeningHours;
  subModel.subsidiaryPrincipal = sucursal[0].subsidiaryPrincipal;
  subModel.subsidiaryStatus = sucursal[0].subsidiaryStatus;
  subModel.subsidiaryFavourite = '1';

  await sucursalDataBase.updateSubsidiary(subModel);
  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsServiciosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  serviciosBloc.obtenerBienesServiciosResumen();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de detalle de negocio
  sucursalNegocio.obtenerSucursalporIdCompany(sucursal[0].idCompany);
  //Para dibujar el widget de favorito en la vista de servicios por sucursal
  serviceBloc.listarServiciosPorSucursal(sucursal[0].idSubsidiary);
}

void quitarServicioFavorito2(BuildContext context, BienesServiciosModel dataModel) async {
  final servicioModel = SubsidiaryServiceModel();
  final subservicesDb = SubsidiaryServiceDatabase();
  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);
  final pointsProdBloc = ProviderBloc.points(context);
  final serviciosBloc = ProviderBloc.bienesServicios(context);
  //final sucursalNegocio = ProviderBloc.sucursal(context);
  final serviceBloc = ProviderBloc.servi(context);

  servicioModel.idSubsidiaryservice = dataModel.idSubsidiaryservice;
  servicioModel.idSubsidiary = dataModel.idSubsidiary;
  servicioModel.idService = dataModel.idService;
  servicioModel.idItemsubcategory = dataModel.idItemsubcategory;
  servicioModel.subsidiaryServiceName = dataModel.subsidiaryServiceName;
  servicioModel.subsidiaryServicePrice = dataModel.subsidiaryServicePrice;
  servicioModel.subsidiaryServiceDescription = dataModel.subsidiaryServiceDescription;
  servicioModel.subsidiaryServiceCurrency = dataModel.subsidiaryServiceCurrency;
  servicioModel.subsidiaryServiceImage = dataModel.subsidiaryServiceImage;
  servicioModel.subsidiaryServiceRating = dataModel.subsidiaryServiceRating;
  servicioModel.subsidiaryServiceUpdated = dataModel.subsidiaryServiceUpdated;
  servicioModel.subsidiaryServiceStatus = dataModel.subsidiaryServiceStatus;
  servicioModel.subsidiaryServiceFavourite = "0";

  await subservicesDb.updateSubsidiaryService(servicioModel);

  //Para dibujar el widget de favorito en la vista de Point
  pointsProdBloc.obtenerPointsServiciosXSucursal();
  //Para dibujar el widget de favorito en la vista principal
  serviciosBloc.obtenerBienesServiciosResumen();
  //Mostrar en De acuerdo lo que buscaste
  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //Para dibujar el widget de favorito en la vista de servicios por sucursal
  serviceBloc.listarServiciosPorSucursal(dataModel.idSubsidiary);
}

void leerNotificacion(BuildContext context, NotificacionesModel notificaciones) async {
  final notiDb = NotificacionesDataBase();
  final notiApi = NotificacionesApi();
  final notificacionesBloc = ProviderBloc.notificaciones(context);

  final notificacionModel = NotificacionesModel();
  notificacionModel.idNotificacion = notificaciones.idNotificacion;
  notificacionModel.idUsuario = notificaciones.idUsuario;
  notificacionModel.notificacionTipo = notificaciones.notificacionTipo;
  notificacionModel.notificacionIdRel = notificaciones.notificacionIdRel;
  notificacionModel.notificacionMensaje = notificaciones.notificacionMensaje;
  notificacionModel.notificacionImagen = notificaciones.notificacionImagen;
  notificacionModel.notificacionDatetime = notificaciones.notificacionDatetime;
  notificacionModel.notificacionEstado = "1";

  await notiDb.updateNotificaciones(notificacionModel);
  notificacionesBloc.listarNotificaciones();
  notificacionesBloc.listarNotificacionesPendientes();

  notiApi.notificacionesVistas(notificaciones.idNotificacion);
}

//----------------------Carrito-------------------------------------
Future<int> agregarAlCarrito(BuildContext context, String idSubsidiarygood, String talla, String modelo, String marca) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  final productCarrito = await carritoDb.obtenerProductoXCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);

  final producto = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);
  CarritoModel c = CarritoModel();

  c.idSubsidiaryGood = producto[0].idProducto;
  c.idSubsidiary = producto[0].idSubsidiary;
  c.precio = producto[0].productoPrice;
  c.nombre = producto[0].productoName;
  c.marca = marca;
  c.modelo = modelo;
  c.talla = talla;
  c.image = producto[0].productoImage;
  c.moneda = producto[0].productoCurrency;
  //c.size = producto[0].productoSize;
  c.stock = producto[0].productoStock;

  if (productCarrito.length > 0) {
    //await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
    await carritoDb.deleteCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);
    c.cantidad = (int.parse(productCarrito[0].cantidad) + 1).toString();

    c.estadoSeleccionado = productCarrito[0].estadoSeleccionado;
  } else {
    c.cantidad = '1';
    c.estadoSeleccionado = '0';
  }

  await carritoDb.insertarProducto(c);

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();

  return 0;
}

Future<int> agregarAlCarritoDesdePedirAhora(BuildContext context, String idSubsidiarygood, String talla, String modelo, String marca) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  final productCarrito = await carritoDb.obtenerProductoXCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);

  final producto = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);
  CarritoModel c = CarritoModel();

  c.idSubsidiaryGood = producto[0].idProducto;
  c.idSubsidiary = producto[0].idSubsidiary;
  c.precio = producto[0].productoPrice;
  c.nombre = producto[0].productoName;
  c.marca = marca;
  c.modelo = modelo;
  c.talla = talla;
  c.image = producto[0].productoImage;
  c.moneda = producto[0].productoCurrency;
  //c.size = producto[0].productoSize;
  c.stock = producto[0].productoStock;

  if (productCarrito.length > 0) {
    //await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
    await carritoDb.deleteCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);
    c.cantidad = (int.parse(productCarrito[0].cantidad) + 1).toString();
    if (productCarrito[0].estadoSeleccionado == '0') {
      c.estadoSeleccionado = '1';
    } else {
      c.estadoSeleccionado = productCarrito[0].estadoSeleccionado;
    }
  } else {
    c.cantidad = '1';
    c.estadoSeleccionado = '1';
  }

  await carritoDb.insertarProducto(c);

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();

  return 0;
}

void borrarCarrito(BuildContext context, String idSubsidiarygood) async {
  CarritoDb carritoDb = CarritoDb();
  if (idSubsidiarygood == '0') {
    await carritoDb.deleteCarritoPorEstadoSeleccion();
  } else {
    await carritoDb.deleteCarritoPorIdProductoEstadoSeleccion(idSubsidiarygood);
  }

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();
  carritoBloc.carritoPorSucursalSeleccionado('0');
}

void agregarAlCarritoContador(BuildContext context, String idSubsidiarygood, String talla, String modelo, String marca, int cantidad) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  if (cantidad == 0) {
    //eliminar producto del carrito
    //await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
    await carritoDb.deleteCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);
  } else {
    final producto = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);

    final carritoList = await carritoDb.obtenerProductoXCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);

    CarritoModel c = CarritoModel();

    c.idSubsidiaryGood = producto[0].idProducto;
    c.idSubsidiary = producto[0].idSubsidiary;
    c.precio = producto[0].productoPrice;
    c.nombre = producto[0].productoName;
    c.marca = marca;
    c.modelo = modelo;
    c.talla = talla;
    c.image = producto[0].productoImage;
    c.moneda = producto[0].productoCurrency;
    //c.size = producto[0].productoSize;
    c.stock = producto[0].productoStock;
    c.estadoSeleccionado = carritoList[0].estadoSeleccionado;
    c.cantidad = cantidad.toString();

    await carritoDb.updateCarritoPorIdSudsidiaryGoodTalla(c);
  }

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();
  carritoBloc.carritoPorSucursalSeleccionado('0');
}

void deleteProductoCarrito(BuildContext context, String idSubsidiarygood, String talla, String modelo, String marca) async {
  CarritoDb carritoDb = CarritoDb();
  await carritoDb.deleteCarritoPorIdProductoTalla(idSubsidiarygood, talla, modelo, marca);
  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();
  carritoBloc.carritoPorSucursalSeleccionado('0');
}

void porcentaje(BuildContext context, double porcen) async {
  final porcentajeBloc = ProviderBloc.porcentaje(context);
  porcentajeBloc.changePorcentaje(porcen);
}

void agregarPSaSugerencia(BuildContext context, String idProduct, String tipo) async {
  final sugerenciaBusquedaDb = SugerenciaBusquedaDb();
  final productoDatabase = ProductoDatabase();
  final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();

  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);
  //final bienesBloc = ProviderBloc.bienesServicios(context);

  if (tipo == 'bien') {
    final bienList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(idProduct);

    SugerenciaBusquedaModel sugerenciaBusquedaModel = SugerenciaBusquedaModel();
    sugerenciaBusquedaModel.idItemSubcategoria = bienList[0].idItemsubcategory;
    sugerenciaBusquedaModel.nombreProducto = bienList[0].productoName;
    sugerenciaBusquedaModel.idProducto = bienList[0].idProducto;
    sugerenciaBusquedaModel.tipo = tipo;

    await sugerenciaBusquedaDb.insertarProducto(sugerenciaBusquedaModel);
  } else {
    final serviceList = await subsidiaryServiceDatabase.obtenerServiciosPorIdSucursalService(idProduct);

    SugerenciaBusquedaModel sugerenciaBusquedaModel = SugerenciaBusquedaModel();
    sugerenciaBusquedaModel.idItemSubcategoria = serviceList[0].idItemsubcategory;
    sugerenciaBusquedaModel.nombreProducto = serviceList[0].subsidiaryServiceName;
    sugerenciaBusquedaModel.idProducto = serviceList[0].idSubsidiaryservice;
    sugerenciaBusquedaModel.tipo = tipo;

    await sugerenciaBusquedaDb.insertarProducto(sugerenciaBusquedaModel);
  }

  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
  //bienesBloc.obtenerBienesAllPorCiudad();
}

void agregarHistorialBusqueda(BuildContext context, String idBusqueda, String tipoBusqueda, String nombreBusqueda, String img) async {
  final searchBusquedaDB = SearchHistoryDb();
  final searchBloc = ProviderBloc.searHistory(context);
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd H:m');
  String formattedDate = formatter.format(now);
  SearchHistoryModel searchHistoryModel = SearchHistoryModel();
  searchHistoryModel.idBusqueda = idBusqueda;
  searchHistoryModel.nombreBusqueda = nombreBusqueda;
  searchHistoryModel.tipoBusqueda = tipoBusqueda;
  searchHistoryModel.fecha = formattedDate;
  searchHistoryModel.img = img;

  searchBusquedaDB.insertarBusqueda(searchHistoryModel);
  searchBloc.listarSearchHistory();
}

void agregarHistorial(BuildContext context, String text, String page) async {
  final historialDB = HistorialDb();
  final searchBloc = ProviderBloc.searHistory(context);

  if (text != '') {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd H:m');
    String formattedDate = formatter.format(now);
    historialDB.insertarBusqueda(text, formattedDate, page);
  }

  await historialDB.obtenerBusqueda(page);

  searchBloc.obtenerAllHistorial(page);
}

void eliminarHistorial(BuildContext context, String text, String page) async {
  final historialDB = HistorialDb();
  final searchBloc = ProviderBloc.searHistory(context);

  await historialDB.deleteHistorial(text);

  searchBloc.obtenerAllHistorial(page);
}

void irADetalleProducto(BienesServiciosModel model, BuildContext context) {
  ProductoModel productoModel = ProductoModel();
  productoModel.idProducto = model.idSubsidiarygood;
  productoModel.idSubsidiary = model.idSubsidiary;
  productoModel.idGood = model.idGood;
  productoModel.idItemsubcategory = model.idItemsubcategory;
  productoModel.productoName = model.subsidiaryGoodName;
  productoModel.productoPrice = model.subsidiaryGoodPrice;
  productoModel.productoCurrency = model.subsidiaryGoodCurrency;
  productoModel.productoImage = model.subsidiaryGoodImage;
  productoModel.productoCharacteristics = model.subsidiaryGoodCharacteristics;
  productoModel.productoBrand = model.subsidiaryGoodBrand;
  productoModel.productoModel = model.subsidiaryGoodModel;
  productoModel.productoType = model.subsidiaryGoodType;
  productoModel.productoSize = model.subsidiaryGoodSize;
  productoModel.productoStock = model.subsidiaryGoodStock;
  productoModel.productoMeasure = model.subsidiaryGoodMeasure;
  productoModel.productoRating = model.subsidiaryGoodRating;
  productoModel.productoUpdated = model.subsidiaryGoodUpdated;
  productoModel.productoStatus = model.subsidiaryGoodStatus;

  productoModel.productoFavourite = model.subsidiaryGoodFavourite;

  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) {
        return DetalleProductos(idProducto: model.idSubsidiarygood);
        //return DetalleProductitos(productosData: productosData);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void cambiarEstadoCarrito(BuildContext context, String idProducto, String talla, String modelo, String marca, String estado) async {
  final carritoBloc = ProviderBloc.productosCarrito(context);
  final carritodb = CarritoDb();

  await carritodb.updateSeleccionado(idProducto, estado, talla, modelo, marca);

  carritoBloc.obtenerCarritoPorSucursal();
}

void deseleccionarTiposPago() async {
  final tiposPagoDatabase = TiposPagoDatabase();
  await tiposPagoDatabase.deseleccionarTiposPago();
}

void seleccionarTiposPago(BuildContext context, String idTiposPago) async {
  final tiposPagoBloc = ProviderBloc.tiPago(context);
  final tiposPagoDatabase = TiposPagoDatabase();
  await tiposPagoDatabase.deseleccionarTiposPago();
  await tiposPagoDatabase.updateSeleccionarTiposPago(idTiposPago);

  tiposPagoBloc.obtenerTipoPagoSeleccionado();
  tiposPagoBloc.obtenerTiposPago();
}

void updateStatusDelivery(BuildContext context, String idSubsidiary, String seleccion) async {
  final carritoBloc = ProviderBloc.productosCarrito(context);
  final carritoDeliveryDB = CarritoDeliveryDB();

  await carritoDeliveryDB.updateSeleccionado(idSubsidiary, seleccion);

  carritoBloc.obtenerCarritoConfirmacion('1');
}

void updateStatusDeliveryPedirAhora(BuildContext context, String idSubsidiary, String seleccion, String idProducto) async {
  final carritoBloc = ProviderBloc.productosCarrito(context);
  final carritoDeliveryDB = CarritoDeliveryDB();

  await carritoDeliveryDB.updateSeleccionado(idSubsidiary, seleccion);

  carritoBloc.confirmacionPedidoProducto(idProducto, '1');
}

// void agregarDireccion(BuildContext context, String direccion, String referencia,
//     String distrito) async {
//   final direccionDatabase = DireccionDatabase();

//   DireccionModel direccionModel = DireccionModel();

//   direccionModel.address = direccion;
//   direccionModel.referencia = referencia;
//   direccionModel.distrito = distrito;
//   direccionModel.estado = '1';

//   await direccionDatabase.insertarDireccion(direccionModel);

//   Navigator.pop(context);
// }

void agregarDireccion(BuildContext context, String direccion, String referencia, String distrito) async {
  final direccionesBloc = ProviderBloc.direc(context);
  final direccionDatabase = DireccionDatabase();

  DireccionModel direccionModel = DireccionModel();

  direccionModel.address = direccion;
  direccionModel.referencia = referencia;
  direccionModel.distrito = distrito;
  direccionModel.estado = '1';

  await direccionDatabase.insertarDireccion(direccionModel);

  direccionesBloc.obtenerDireccionEstado1();
  Navigator.pop(context);
}

void eliminarDireccion(BuildContext context, DireccionModel direccion) async {
  final direccionesBloc = ProviderBloc.direc(context);
  final direccionDatabase = DireccionDatabase();

  // DireccionModel direccionModel = DireccionModel();

  // direccionModel.address = direccion.address;
  // direccionModel.referencia = direccion.referencia;
  // direccionModel.distrito = direccion.distrito;
  // direccionModel.estado = '0';

  final res = await direccionDatabase.deleteDireccionPorID(direccion.idDireccion);
  //final res = await direccionDatabase.updateDireccion(direccionModel);
  print('update $res');

  //direccionesBloc.deleteDireccion();
  direccionesBloc.obtenerDirecciones();
}

void eliminarTodasLasDirecciones(BuildContext context) async {
  final direccionesBloc = ProviderBloc.direc(context);
  final direccionDatabase = DireccionDatabase();

  await direccionDatabase.deleteDireccion();

  direccionesBloc.obtenerDirecciones();
}

Future<List<ProductoModel>> filtrarListaProductos(List<ProductoModel> lista) async {
  final List<ProductoModel> listAlgo = [];

  final List<String> listString = [];
  for (var a = 0; a < lista.length; a++) {
    listString.add(lista[a].idProducto);
  }
  var listString2 = listString.toSet().toList();

  for (var x = 0; x < listString2.length; x++) {
    for (var i = 0; i < lista.length; i++) {
      if (listString2[x] != lista[i].idProducto) {
        bool valor = false;

        for (var y = 0; y < listAlgo.length; y++) {
          if (lista[i].idProducto == listAlgo[y].idProducto) {
            valor = true;
          }
        }

        if (valor) {
        } else {
          ProductoModel productoModel = ProductoModel();
          productoModel.idProducto = lista[i].idProducto;
          productoModel.idSubsidiary = lista[i].idSubsidiary;
          productoModel.idGood = lista[i].idGood;
          productoModel.idItemsubcategory = lista[i].idItemsubcategory;
          productoModel.productoName = lista[i].productoName;
          productoModel.productoPrice = lista[i].productoPrice;
          productoModel.productoCurrency = lista[i].productoCurrency;
          productoModel.productoImage = lista[i].productoImage;
          productoModel.productoCharacteristics = lista[i].productoCharacteristics;
          productoModel.productoBrand = lista[i].productoBrand;
          productoModel.productoModel = lista[i].productoModel;
          productoModel.productoType = lista[i].productoType;
          productoModel.productoSize = lista[i].productoSize;
          productoModel.productoStock = lista[i].productoStock;
          productoModel.productoStockStatus = lista[i].productoStockStatus;
          productoModel.productoMeasure = lista[i].productoMeasure;
          productoModel.productoRating = lista[i].productoRating;
          productoModel.productoUpdated = lista[i].productoUpdated;
          productoModel.productoStatus = lista[i].productoStatus;

          listAlgo.add(productoModel);
        }
      } else {}
    }
  }

  return listAlgo;
}

Future<List<CompanyModel>> filtrarListaNegocios(List<CompanyModel> lista) async {
  final List<CompanyModel> listAlgo = [];

  final List<String> listString = [];
  for (var a = 0; a < lista.length; a++) {
    listString.add(lista[a].idCompany);
  }
  var listString2 = listString.toSet().toList();

  for (var x = 0; x < listString2.length; x++) {
    for (var i = 0; i < lista.length; i++) {
      if (listString2[x] != lista[i].idCompany) {
        bool valor = false;

        for (var y = 0; y < listAlgo.length; y++) {
          if (lista[i].idCompany == listAlgo[y].idCompany) {
            valor = true;
          }
        }

        if (valor) {
          print('Contenido');
        } else {
          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = lista[i].idCompany;
          companyModel.idUser = lista[i].idUser;
          companyModel.idCity = lista[i].idCity;
          companyModel.idCategory = lista[i].idCategory;
          companyModel.companyName = lista[i].companyName;
          companyModel.companyRuc = lista[i].companyRuc;
          companyModel.companyImage = lista[i].companyImage;
          companyModel.companyType = lista[i].companyType;
          companyModel.companyShortcode = lista[i].companyShortcode;
          companyModel.companyDelivery = lista[i].companyDelivery;
          companyModel.companyEntrega = lista[i].companyEntrega;
          companyModel.companyTarjeta = lista[i].companyTarjeta;
          companyModel.companyVerified = lista[i].companyVerified;
          companyModel.companyRating = lista[i].companyRating;
          companyModel.companyCreatedAt = lista[i].companyCreatedAt;
          companyModel.companyJoin = lista[i].companyJoin;
          companyModel.companyStatus = lista[i].companyStatus;
          companyModel.companyMt = lista[i].companyMt;
          companyModel.idCountry = lista[i].idCountry;
          companyModel.cityName = lista[i].cityName;
          companyModel.distancia = lista[i].distancia;

          listAlgo.add(companyModel);
        }
      } else {
        print('entra arriba abajo $x');
      }
    }
  }

  return listAlgo;
}

obtenerFechaHora(String date) {
  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy, H:m', 'es');

  return fech.format(fecha);
}

obtenerFecha(String date) {
  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMMM yyyy', 'es');

  return fech.format(fecha);
}

actualizarEstadoValoracion(String idPedido) async {
  final detallePedidoDb = DetallePedidoDatabase();
  detallePedidoDb.updateStadoValoracion(idPedido);
}

// void quitarSubsidiaryFavorito(
//     BuildContext context, SubsidiaryModel subsidiaryModel) async {
//   final sucursalBloc = ProviderBloc.sucursal(context);
//   final pointsBloc = ProviderBloc.points(context);

//   SubsidiaryModel companysubsidiaryModel = SubsidiaryModel();
//   final sucursalDataBase = SubsidiaryDatabase();
//   final deletePoint = PointApi();

//   companysubsidiaryModel.idSubsidiary = subsidiaryModel.idSubsidiary;
//   companysubsidiaryModel.idCompany = subsidiaryModel.idCompany;
//   companysubsidiaryModel.subsidiaryName = subsidiaryModel.subsidiaryName;
//   companysubsidiaryModel.subsidiaryCellphone =
//       subsidiaryModel.subsidiaryCellphone;
//   companysubsidiaryModel.subsidiaryCellphone2 =
//       subsidiaryModel.subsidiaryCellphone2;
//   companysubsidiaryModel.subsidiaryEmail = subsidiaryModel.subsidiaryEmail;
//   companysubsidiaryModel.subsidiaryCoordX = subsidiaryModel.subsidiaryCoordX;
//   companysubsidiaryModel.subsidiaryCoordY = subsidiaryModel.subsidiaryCoordY;
//   companysubsidiaryModel.subsidiaryOpeningHours =
//       subsidiaryModel.subsidiaryOpeningHours;
//   companysubsidiaryModel.subsidiaryPrincipal =
//       subsidiaryModel.subsidiaryPrincipal;
//   companysubsidiaryModel.subsidiaryStatus = subsidiaryModel.subsidiaryStatus;
//   companysubsidiaryModel.subsidiaryFavourite = "0";

//   final res = await sucursalDataBase.updateSubsidiary(companysubsidiaryModel);
//   print('update $res');

//   sucursalBloc.obtenerSucursalporIdCompany(subsidiaryModel.idSubsidiary);
//   pointsBloc.obtenerPoints();
//   deletePoint.deletePoint(companysubsidiaryModel.idSubsidiary);
// }
