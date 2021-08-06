import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/direccionModel.dart';

class DireccionDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarDireccion(DireccionModel direccionModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Direccion (address,referencia,distrito,"
          "coord_x,coord_y,estado) "
          "VALUES ('${direccionModel.address}','${direccionModel.referencia}','${direccionModel.distrito}',"
          "'${direccionModel.coordx}','${direccionModel.coordy}',"
          "'${direccionModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateDireccion(DireccionModel direccionModel) async {
    try {
      final db = await dbprovider.database;
      // final res = await db.rawUpdate('UPDATE Direccion SET '
      //     'estado="0"');
      final res = await db.rawUpdate("UPDATE Direccion SET address='${direccionModel.address}',"
          "referencia='${direccionModel.referencia}',"
          "distrito='${direccionModel.distrito}',"
          "coord_x='${direccionModel.coordx}',"
          "coord_y='${direccionModel.coordy}',"
          "estado='${direccionModel.estado}'"
          "WHERE address='${direccionModel.address}' ");

      // print('database actualizada $res');
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<DireccionModel>> obtenerDirecciones() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery("SELECT * FROM Direccion");

      List<DireccionModel> list = res.isNotEmpty ? res.map((c) => DireccionModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteDireccion() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawDelete("DELETE FROM Direccion");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteDireccionPorID(String id) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawDelete("DELETE FROM Direccion where id_direccion =$id");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<DireccionModel>> obtenerdireccionEstado1() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery("SELECT * FROM Direccion where estado ='1' ");

      List<DireccionModel> list = res.isNotEmpty ? res.map((c) => DireccionModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<DireccionModel>> obtenerDireccionEstado0() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery("SELECT * FROM Direccion where estado ='0'");

      List<DireccionModel> list = res.isNotEmpty ? res.map((c) => DireccionModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
