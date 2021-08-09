import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';

class PantallaPrincipalDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarPantallaPrincipal(PantallaPrincipalModel pantallaPrincipalModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO PantallaPrincipal (idPantalla,nombre,tipo) "
          "VALUES('${pantallaPrincipalModel.idPantalla}', '${pantallaPrincipalModel.nombre}','${pantallaPrincipalModel.tipo}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<PantallaPrincipalModel>> obtenerPantallaPrincipal() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM PantallaPrincipal");

      List<PantallaPrincipalModel> list = res.isNotEmpty ? res.map((c) => PantallaPrincipalModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
