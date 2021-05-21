import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/historialModel.dart';

class HistorialDb {
  final dbProvider = DatabaseProvider.db;

  insertarBusqueda(String historial, String fecha) async {
    try {
      final db = await dbProvider.database;

      final res =
          await db.rawInsert("INSERT OR REPLACE INTO Historial (text, fecha) "
              "VALUES('$historial', '$fecha')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
      print(e);
    }
  }

  Future<List<HistorialModel>> obtenerBusqueda() async {
    try {
      final db = await dbProvider.database;
      final res =
          await db.rawQuery("SELECT * FROM Historial ORDER BY fecha DESC");

      List<HistorialModel> list = res.isNotEmpty
          ? res.map((c) => HistorialModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
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
      print(e);
      return [];
    }
  }
}
