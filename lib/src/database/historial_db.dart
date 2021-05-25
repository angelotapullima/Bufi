import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/historialModel.dart';

class HistorialDb {
  final dbProvider = DatabaseProvider.db;

  insertarBusqueda(String historial, String fecha, String page) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Historial (text, fecha, page_busqueda) "
          "VALUES('$historial', '$fecha', '$page')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
    }
  }

  Future<List<HistorialModel>> obtenerBusqueda(String page) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Historial WHERE page_busqueda='$page' ORDER BY fecha DESC");

      List<HistorialModel> list = res.isNotEmpty
          ? res.map((c) => HistorialModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteHistorial(String historial) async {
    try {
      final db = await dbProvider.database;

      final res =
          await db.rawDelete("DELETE FROM Historial WHERE text = '$historial'");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
