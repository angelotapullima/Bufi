import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:flutter/material.dart';
import '../bloc/provider_bloc.dart';
import '../database/producto_bd.dart';
import '../database/subsidiaryService_db.dart';
import '../models/bienesServiciosModel.dart';
import '../models/productoModel.dart';
import '../models/subsidiaryService.dart';

void guardarProductoFavorito(
    BuildContext context, ProductoModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);

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
  final sucursal =
      await sucursalDataBase.obtenerSubsidiaryPorId(dataModel.idSubsidiary);
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

  await sucursalDataBase.obtenerSubsidiaryPorId(productoModel.idSubsidiary);
  pointsProdBloc.obtenerPointsProductosXSucursal();
}

void quitarProductoFavorito(
    BuildContext context, ProductoModel dataModel) async {
  final pointsProdBloc = ProviderBloc.points(context);

  final sucursalDataBase = SubsidiaryDatabase();
  //final deletePoint = PointApi();

  final productoModel = ProductoModel();
  final productoDb = ProductoDatabase();

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

  await sucursalDataBase.obtenerSubsidiaryPorId(productoModel.idSubsidiary);
  //pointsProdBloc.obtenerPointsProductosXSucursal();
  productoDb.obtenerProductosFavoritos();
}

void guardarServicioFavorito(
    BuildContext context, BienesServiciosModel dataModel) async {
  final servicioModel = SubsidiaryServiceModel();
  final subservicesDb = SubsidiaryServiceDatabase();

  servicioModel.idSubsidiaryservice = dataModel.idSubsidiaryservice;
  servicioModel.idSubsidiary = dataModel.idSubsidiary;
  servicioModel.idItemsubcategory = dataModel.idItemsubcategory;
  servicioModel.subsidiaryServiceName = dataModel.subsidiaryServiceName;
  servicioModel.subsidiaryServicePrice = dataModel.subsidiaryServicePrice;
  servicioModel.subsidiaryServiceDescription =
      dataModel.subsidiaryServiceDescription;
  servicioModel.subsidiaryServiceCurrency = dataModel.subsidiaryServiceCurrency;
  servicioModel.subsidiaryServiceImage = dataModel.subsidiaryServiceImage;
  servicioModel.subsidiaryServiceRating = dataModel.subsidiaryServiceRating;
  servicioModel.subsidiaryServiceUpdated = dataModel.subsidiaryServiceUpdated;
  servicioModel.subsidiaryServiceStatus = dataModel.subsidiaryServiceStatus;
  servicioModel.subsidiaryServiceFavourite = "1";

  await subservicesDb.updateSubsidiaryService(servicioModel);
}
