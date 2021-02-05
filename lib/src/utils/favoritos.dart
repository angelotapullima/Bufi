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

final pointsProdBloc = ProviderBloc.pointProdServicios(context);
    
  final productoModel = ProductoModel();
  final productoDb = ProductoDatabase();
  final sucursalDataBase = SubsidiaryDatabase();
  final subsidiaryModel = SubsidiaryModel();

  productoModel.idProducto = dataModel.idProducto;
  productoModel.idSubsidiary = dataModel.idSubsidiary;
  productoModel.idGood = dataModel.idGood;
  productoModel.idItemsubcategory = dataModel.idItemsubcategory;
  productoModel.productoName = dataModel.productoName;
  productoModel.productoPrice = dataModel.productoPrice;
  productoModel.productoCurrency = dataModel.productoCurrency;
  productoModel.productoImage = dataModel.productoImage;
  productoModel.productoCharacteristics =
      dataModel.productoCharacteristics;
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

  await productoDb.updateProducto(productoModel);
  await sucursalDataBase.obtenerSubsidiaryPorId(productoModel.idSubsidiary);
  //await productoDb.obtenerProductosFavoritos();
  pointsProdBloc.obtenerProductosFav();
  
//   final listSucursalesFav =await sucursalDataBase.obtenerSubsidiaryPorId(productoModel.idSubsidiary);
// for (var i = 0; i < listSucursalesFav.length; i++) {

// }

  // await sucursalDataBase.updateSubsidiary();
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
