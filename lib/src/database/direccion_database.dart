

import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/direccionModel.dart';

class DireccionDatabase{

final dbprovider = DatabaseProvider.db;

  insertarDireccion(DireccionModel direccionModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Direccion (address,referencia,distrito,"
          "coord_x,coord_y,estado) "
              "VALUES ('${direccionModel.address}','${direccionModel.referencia}','${direccionModel.distrito}',"
              "'${direccionModel.coordx}','${direccionModel.coordy}',"
              "'${direccionModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<DireccionModel>> obtenerDirecciones() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Direccion");

    List<DireccionModel> list = res.isNotEmpty
        ? res.map((c) => DireccionModel.fromJson(c)).toList()
        : [];

    return list;
  } 


  Future<List<DireccionModel>> obtenerdireccionSeleccionada(String idPedido) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Direccion where estado ='1' ");

    List<DireccionModel> list = res.isNotEmpty
        ? res.map((c) => DireccionModel.fromJson(c)).toList()
        : [];

    return list;
  } 



}