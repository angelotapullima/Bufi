import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/searchHistoryModel.dart';

class SearchHistoryDb {
  final dbProvider = DatabaseProvider.db;

  insertarBusqueda(SearchHistoryModel searchHistoryModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO SearchHistory (id_busqueda,nombre_busqueda,tipo_busqueda, img, fecha) "
          "VALUES('${searchHistoryModel.idBusqueda}','${searchHistoryModel.nombreBusqueda}','${searchHistoryModel.tipoBusqueda}','${searchHistoryModel.img}','${searchHistoryModel.fecha}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
    }
  }

  Future<List<SearchHistoryModel>> obtenerBusqueda() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM SearchHistory ORDER BY fecha DESC LIMIT 10");

      List<SearchHistoryModel> list = res.isNotEmpty ? res.map((c) => SearchHistoryModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
