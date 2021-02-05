


import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/subsidiaryService.dart';

import '../models/subsidiaryService.dart';

class SubsidiaryServiceDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarSubsidiaryService(
      SubsidiaryServiceModel subsidiaryServiceModel) async {
    final db = await dbProvider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Subsidiaryservice (id_subsidiaryservice, id_subsidiary, id_service, id_itemsubcategory,"
        "subsidiary_service_name, subsidiary_service_description, subsidiary_service_price, subsidiary_service_currency, subsidiary_service_image,"
        "subsidiary_service_rating, subsidiary_service_updated,subsidiary_service_status, subsidiary_service_favourite) "
        "VALUES('${subsidiaryServiceModel.idSubsidiaryservice}','${subsidiaryServiceModel.idSubsidiary}','${subsidiaryServiceModel.idService}',"
        "'${subsidiaryServiceModel.idItemsubcategory}','${subsidiaryServiceModel.subsidiaryServiceName}','${subsidiaryServiceModel.subsidiaryServiceDescription}',"
        "'${subsidiaryServiceModel.subsidiaryServicePrice}', '${subsidiaryServiceModel.subsidiaryServiceCurrency}','${subsidiaryServiceModel.subsidiaryServiceImage}',"
        "'${subsidiaryServiceModel.subsidiaryServiceRating}','${subsidiaryServiceModel.subsidiaryServiceUpdated}','${subsidiaryServiceModel.subsidiaryServiceStatus}','${subsidiaryServiceModel.subsidiaryServiceFavourite}')");

    return res;
  }

updateSubsidiaryService(SubsidiaryServiceModel subServicesModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate(
          "UPDATE Subsidiary SET id_subsidiary= '${subServicesModel.idSubsidiary}',"
          "id_service='${subServicesModel.idService}',"
          "id_itemsubcategory='${subServicesModel.idItemsubcategory}',"
          "subsidiary_service_name='${subServicesModel.subsidiaryServiceName}',"
          "subsidiary_service_description='${subServicesModel.subsidiaryServiceDescription}',"
          "subsidiary_service_price='${subServicesModel.subsidiaryServicePrice}',"
          "subsidiary_service_currency='${subServicesModel.subsidiaryServiceCurrency}',"
          "subsidiary_service_rating='${subServicesModel.subsidiaryServiceRating}',"
          "subsidiary_service_updated='${subServicesModel.subsidiaryServiceUpdated}',"
          "subsidiary_service_status='${subServicesModel.subsidiaryServiceStatus}',"
          "subsidiary_service_favourite= '${subServicesModel.subsidiaryServiceFavourite}'"
          "WHERE id_subsidiaryservice='${subServicesModel.idSubsidiaryservice}' ");

      print('database $res');
      return res;
    } catch (exception) {
      print(exception);
    }
  }
  Future<List<SubsidiaryServiceModel>> obtenerSubsidiaryService() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiaryservice ");
    //Para ver solo los activos 
    //where subsidiary_service_status='1'

    List<SubsidiaryServiceModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryServiceModel>> obtenerServiciosPorIdSucursal(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiary= '$id' order by id_subsidiaryservice");

    List<SubsidiaryServiceModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryServiceModel>> obtenerServiciosPorIdSucursalService(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiaryservice= '$id'");
  //"SELECT * FROM Subsidiaryservice WHERE id_subsidiaryservice= '$id' and subsidiary_service_status = '1'"
    List<SubsidiaryServiceModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList()
        : [];
    return list;
  }

  deshabilitarSubsidiaryServiceDb(SubsidiaryServiceModel serviceModel)async{
    final db = await dbProvider.database;

    final res = await db.rawUpdate("UPDATE Subsidiaryservice SET " 
     
    "subsidiary_service_status='0' "
    "WHERE id_subsidiaryservice = '${serviceModel.idSubsidiaryservice}' " 
    );

    return res;
  }

  habilitarSubsidiaryServiceDb(SubsidiaryServiceModel serviceModel)async{
    final db = await dbProvider.database;

    final res = await db.rawUpdate("UPDATE Subsidiaryservice SET " 
     
    "subsidiary_service_status='1' "
    "WHERE id_subsidiaryservice = '${serviceModel.idSubsidiaryservice}' " 
    );

    return res;
  }

  Future<List<SubsidiaryServiceModel>> obtenerServicioXIdItemSubcategoria(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_itemsubcategory='$id'");

    List<SubsidiaryServiceModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryServiceModel>> obtenerSubsidiarysServicesFavoritos() async {
    final db = await dbProvider.database;
    final res =await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE subsidiary_service_favourite = 1 "); //1 cuando es favorito

    List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

    return list;
  }

  // Future<List<SubsidiaryServiceModel>> quitarSubsidiarysServicesFavoritos() async {
  //   final db = await dbProvider.database;
  //   final res =await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE subsidiary_service_favourite = 0 "); //1 cuando es favorito

  //   List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

  //   return list;
  // }
}
