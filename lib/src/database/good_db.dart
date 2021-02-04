

import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/goodModel.dart';

class GoodDatabase{


  final dbProvider = DatabaseProvider.db;

  insertarGood(BienesModel bienesModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Good (id_good,good_name,good_synonyms) "
          "VALUES('${bienesModel.idGood}', '${bienesModel.goodName}', '${bienesModel.goodSynonyms}')"
          );

      return res;
    } catch (e) {
      print("Error en la base de datos");
    }
  }

  Future<List<BienesModel>> obtenerGood() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Good");

    List<BienesModel> list =
        res.isNotEmpty ? res.map((c) => BienesModel.fromJson(c)).toList() : [];
    return list;
  }




}