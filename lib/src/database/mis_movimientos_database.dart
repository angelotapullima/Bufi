


import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/mis_movimientos_model.dart';

class MisMovimientosDatabase{

final dbprovider = DatabaseProvider.db;

  insertarMisMovimientos(MisMovimientosModel misMovimientosModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO MisMovimientos (nroOperacion,concepto,tipoPago,"
          "monto,comision,fecha,soloFecha,ind) "
              "VALUES ('${misMovimientosModel.nroOperacion}','${misMovimientosModel.concepto}',"
              "'${misMovimientosModel.tipoPago}','${misMovimientosModel.monto}',"
              "'${misMovimientosModel.comision}','${misMovimientosModel.fecha}',"
              "'${misMovimientosModel.soloFecha}','${misMovimientosModel.ind}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<MisMovimientosModel>> obtenerMisMovimientos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM MisMovimientos ");

    List<MisMovimientosModel> list = res.isNotEmpty
        ? res.map((c) => MisMovimientosModel.fromJson(c)).toList()
        : [];

    return list;
  } 

  Future<List<MisMovimientosModel>> obtenerMisMovimientosPorNoperacion(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM MisMovimientos where nroOperacion='$id'");

    List<MisMovimientosModel> list = res.isNotEmpty
        ? res.map((c) => MisMovimientosModel.fromJson(c)).toList()
        : [];

    return list;
  } 

  


Future<List<MisMovimientosModel>> obtenerMisMovimientosSoloFecha() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM MisMovimientos GROUP BY soloFecha");

    List<MisMovimientosModel> list = res.isNotEmpty
        ? res.map((c) => MisMovimientosModel.fromJson(c)).toList()
        : [];

    return list;
  } 



  deleteMisMovimientos() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM MisMovimientos');

    return res;
  }


}