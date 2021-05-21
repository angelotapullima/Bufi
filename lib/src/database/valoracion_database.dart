import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/ValoracionModel.dart';

class ValoracionDataBase {
  final dbprovider = DatabaseProvider.db;

  insertarValoracion(ValoracionModel valoracionModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Valoracion (id_valoracion,id_pedido,id_producto,valoracion_rating,valoracion_comentario,valoracion_imagen,valoracion_datetime) "
          "VALUES('${valoracionModel.idValoracion}','${valoracionModel.idPedido}','${valoracionModel.idProducto}',"
          "'${valoracionModel.valoracionRating}','${valoracionModel.comentario}','${valoracionModel.imagen}',"
          "'${valoracionModel.valoracionDatetime}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ValoracionModel>> obtenerValoracion() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Valoracion ORDER BY valoracion_datetime DESC ");

      List<ValoracionModel> list = res.isNotEmpty
          ? res.map((c) => ValoracionModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ValoracionModel>> obtenerValoracionXIdProducto(
      String idproducto) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Valoracion where id_producto= '$idproducto' ORDER BY valoracion_datetime DESC ");

      List<ValoracionModel> list = res.isNotEmpty
          ? res.map((c) => ValoracionModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ValoracionModel>> obtenerValoracionPendientes() async {
    try {
      final db = await dbprovider.database;
      final res = await db
          .rawQuery("SELECT * FROM Valoracion where notificacion_estado='0'");

      List<ValoracionModel> list = res.isNotEmpty
          ? res.map((c) => ValoracionModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
