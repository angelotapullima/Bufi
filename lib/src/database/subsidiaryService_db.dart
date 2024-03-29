import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/subsidiaryService.dart';

import '../models/subsidiaryService.dart';

class SubsidiaryServiceDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarSubsidiaryService(SubsidiaryServiceModel subsidiaryServiceModel) async {
    final db = await dbProvider.database;

    final res = await db.rawInsert("INSERT OR REPLACE INTO Subsidiaryservice (id_subsidiaryservice, id_subsidiary,id_service,id_itemsubcategory,"
        "subsidiary_service_name, subsidiary_service_description,subsidiary_service_price,subsidiary_service_currency,subsidiary_service_image,"
        "subsidiary_service_rating, subsidiary_service_updated,subsidiary_service_status,subsidiary_service_favourite) "
        "VALUES('${subsidiaryServiceModel.idSubsidiaryservice}','${subsidiaryServiceModel.idSubsidiary}','${subsidiaryServiceModel.idService}',"
        "'${subsidiaryServiceModel.idItemsubcategory}','${subsidiaryServiceModel.subsidiaryServiceName}','${subsidiaryServiceModel.subsidiaryServiceDescription}',"
        "'${subsidiaryServiceModel.subsidiaryServicePrice}', '${subsidiaryServiceModel.subsidiaryServiceCurrency}','${subsidiaryServiceModel.subsidiaryServiceImage}',"
        "'${subsidiaryServiceModel.subsidiaryServiceRating}','${subsidiaryServiceModel.subsidiaryServiceUpdated}','${subsidiaryServiceModel.subsidiaryServiceStatus}','${subsidiaryServiceModel.subsidiaryServiceFavourite}')");

    return res;
  }

  updateSubsidiaryService(SubsidiaryServiceModel subServicesModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Subsidiaryservice SET id_subsidiary= '${subServicesModel.idSubsidiary}',"
          "id_service='${subServicesModel.idService}',"
          "id_itemsubcategory='${subServicesModel.idItemsubcategory}',"
          "subsidiary_service_name='${subServicesModel.subsidiaryServiceName}',"
          "subsidiary_service_description='${subServicesModel.subsidiaryServiceDescription}',"
          "subsidiary_service_price='${subServicesModel.subsidiaryServicePrice}',"
          "subsidiary_service_currency='${subServicesModel.subsidiaryServiceCurrency}',"
          "subsidiary_service_image='${subServicesModel.subsidiaryServiceImage}',"
          "subsidiary_service_rating='${subServicesModel.subsidiaryServiceRating}',"
          "subsidiary_service_updated='${subServicesModel.subsidiaryServiceUpdated}',"
          "subsidiary_service_status='${subServicesModel.subsidiaryServiceStatus}',"
          "subsidiary_service_favourite= '${subServicesModel.subsidiaryServiceFavourite}'"
          "WHERE id_subsidiaryservice='${subServicesModel.idSubsidiaryservice}' ");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerSubsidiaryService() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice ");
      //Para ver solo los activos
      //where subsidiary_service_status='1'

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerServiciosPorIdSucursal(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiary= '$id' order by id_subsidiaryservice");

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerServiciosPorIdSucursalService(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiaryservice= '$id'");
      //"SELECT * FROM Subsidiaryservice WHERE id_subsidiaryservice= '$id' and subsidiary_service_status = '1'"
      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deshabilitarSubsidiaryServiceDb(SubsidiaryServiceModel serviceModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Subsidiaryservice SET "
          "subsidiary_service_status='0' "
          "WHERE id_subsidiaryservice = '${serviceModel.idSubsidiaryservice}' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  habilitarSubsidiaryServiceDb(SubsidiaryServiceModel serviceModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Subsidiaryservice SET "
          "subsidiary_service_status='1' "
          "WHERE id_subsidiaryservice = '${serviceModel.idSubsidiaryservice}' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerServicioXIdItemSubcategoria(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_itemsubcategory='$id'");

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerSubsidiarysServicesFavoritos() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE subsidiary_service_favourite = 1 "); //1 cuando es favorito

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubsidiaryServiceModel>> obtenerSubsidiarysServicesFavoritosPorIdSubsidiary(String idSubsidiary) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiary= '$idSubsidiary' and subsidiary_service_favourite ='1'"); //1 cuando es favorito

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Se utiliza para la busqueda
  Future<List<SubsidiaryServiceModel>> consultarServicioPorQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE subsidiary_service_name LIKE '%$query%'");

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Para la busqueda del producto x sucursal
  Future<List<SubsidiaryServiceModel>> obtenerServiciosPorIdSubsidiaryPorQuery(String idSucursal, String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE id_subsidiary= '$idSucursal' and subsidiary_service_name LIKE '%$query%'");

      List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  // Future<List<SubsidiaryServiceModel>> quitarSubsidiarysServicesFavoritos() async {
  //   final db = await dbProvider.database;
  //   final res =await db.rawQuery("SELECT * FROM Subsidiaryservice WHERE subsidiary_service_favourite = 0 "); //1 cuando es favorito

  //   List<SubsidiaryServiceModel> list = res.isNotEmpty ? res.map((c) => SubsidiaryServiceModel.fromJson(c)).toList() : [];

  //   return list;
  // }
}
