import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';

class MarcaProductoDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarMarcaProducto(MarcaProductoModel marcaProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO MarcaProducto (id_marca_producto,id_producto,"
          "marca_producto, marca_status_producto,estado) "
          "VALUES ('${marcaProductoModel.idMarcaProducto}','${marcaProductoModel.idProducto}',"
          "'${marcaProductoModel.marcaProducto}', '${marcaProductoModel.marcaStatusProducto}',"
          "'${marcaProductoModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Marca de Productos");
    }
  }

  updateMarcaProductoDb() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate('UPDATE MarcaProducto SET '
          'estado="0"');
      // 'id_producto="${marcaProductoModel.idProducto}", '
      // 'marca_producto="${marcaProductoModel.marcaProducto}", '
      // 'marca_status_producto="${marcaProductoModel.marcaStatusProducto}", '
      // 'estado="${marcaProductoModel.estado}" '
      // 'WHERE id_marca_producto = "${marcaProductoModel.idMarcaProducto}"');

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  updateEstadoa0() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate('UPDATE MarcaProducto SET estado="0"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Marca de Productos");
    }
  }

  updateEstadoa1(MarcaProductoModel marcaProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate(
          'UPDATE MarcaProducto SET estado="1" where id_marca_producto="${marcaProductoModel.idMarcaProducto}" and id_producto="${marcaProductoModel.idProducto}"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Marca de Productos");
    }
  }

  Future<List<MarcaProductoModel>> obtenerMarcaProducto() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery("SELECT * FROM MarcaProducto");

      List<MarcaProductoModel> list = res.isNotEmpty
          ? res.map((c) => MarcaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<MarcaProductoModel>> obtenerMarcaProductoPorIdProducto(
      String idProducto) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM MarcaProducto where id_producto='$idProducto' order by id_producto");

      List<MarcaProductoModel> list = res.isNotEmpty
          ? res.map((c) => MarcaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<MarcaProductoModel>> obtenerMarcaProductoPorIdProductoEnEstado1(
      String idProducto) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM MarcaProducto where id_producto = '$idProducto' and estado='1'");

      List<MarcaProductoModel> list = res.isNotEmpty
          ? res.map((c) => MarcaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }
}
