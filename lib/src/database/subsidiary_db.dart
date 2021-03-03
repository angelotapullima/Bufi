import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';

class SubsidiaryDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarSubsidiary(SubsidiaryModel subsidiaryModel) async {
     try {
    final db = await dbProvider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Subsidiary (id_subsidiary,id_company,subsidiary_name,subsidiary_address,"
        "subsidiary_cellphone,subsidiary_cellphone_2,subsidiary_email,subsidiary_coord_x,subsidiary_coord_y,"
        "subsidiary_opening_hours,subsidiary_principal,subsidiary_status,subsidiary_favourite) "
        "VALUES('${subsidiaryModel.idSubsidiary}','${subsidiaryModel.idCompany}','${subsidiaryModel.subsidiaryName}',"
        "'${subsidiaryModel.subsidiaryAddress}','${subsidiaryModel.subsidiaryCellphone}','${subsidiaryModel.subsidiaryCellphone2}',"
        "'${subsidiaryModel.subsidiaryEmail}','${subsidiaryModel.subsidiaryCoordX}','${subsidiaryModel.subsidiaryCoordY}',"
        "'${subsidiaryModel.subsidiaryOpeningHours}','${subsidiaryModel.subsidiaryPrincipal}','${subsidiaryModel.subsidiaryStatus}',"
        "'${subsidiaryModel.subsidiaryFavourite}')");

    return res;} catch (exception) {
      print(exception);
    }
  }

 Future<List<SubsidiaryModel>> obtenerSubsidiary() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiary");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryModel>> obtenerSubsidiaryPorIdCompany(String id) async {
    final db = await dbProvider.database;
    final res = await db
        .rawQuery("SELECT * FROM Subsidiary WHERE id_company= '$id' order by id_subsidiary");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryModel>> obtenerSubsidiaryPorId(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiary WHERE id_subsidiary= '$id' ");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }

  updateSubsidiary(SubsidiaryModel subsidiaryModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate(
          "UPDATE Subsidiary SET id_company= '${subsidiaryModel.idCompany}',"
          "subsidiary_name='${subsidiaryModel.subsidiaryName}',"
          "subsidiary_address='${subsidiaryModel.subsidiaryAddress}',"
          "subsidiary_cellphone='${subsidiaryModel.subsidiaryCellphone}',"
          "subsidiary_cellphone_2='${subsidiaryModel.subsidiaryCellphone2}',"
          "subsidiary_email='${subsidiaryModel.subsidiaryEmail}',"
          "subsidiary_coord_x='${subsidiaryModel.subsidiaryCoordX}',"
          "subsidiary_coord_y='${subsidiaryModel.subsidiaryCoordY}',"
          "subsidiary_opening_hours='${subsidiaryModel.subsidiaryOpeningHours}',"
          "subsidiary_principal='${subsidiaryModel.subsidiaryPrincipal}',"
          "subsidiary_status= '${subsidiaryModel.subsidiaryStatus}',"
          "subsidiary_favourite= '${subsidiaryModel.subsidiaryFavourite}' "
          "WHERE id_subsidiary='${subsidiaryModel.idSubsidiary}' ");

     // print('database actualizada $res');
      return res;
    } catch (exception) {
      print(exception);
    }
  }

 Future<List<SubsidiaryModel>> obtenerSubsidiaryFavoritas() async {
    final db = await dbProvider.database;
    final res = await db
        .rawQuery("SELECT * FROM Subsidiary where subsidiary_favourite=1 order by id_subsidiary");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<SubsidiaryModel>> obtenerSubsidiarysFavoritasAgrupadas() async {
    final db = await dbProvider.database;
    final res = await db
        .rawQuery("SELECT * FROM Subsidiary WHERE subsidiary_favourite=1 group by id_subsidiary ");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }





  Future<List<SubsidiaryModel>> obtenerSubdiaryPrincipal(String idCompany) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Subsidiary WHERE id_subsidiary= '$idCompany' and subsidiary_principal='1'");

    List<SubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => SubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  }


  // Future<List<SubsidiaryModel>> obtenerProductoPorSucursal() async {
  //   final db = await dbProvider.database;
  //   final res = await db.rawQuery("SELECT * FROM Subsidiarygood");

  //   List<SubsidiaryModel> list =
  //       res.isNotEmpty ? res.map((c) => SubsidiaryModel.fromJson(c)).toList() : [];
  //   return list;
  // } 
}
