import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/modeloProductoModel.dart';



class ModeloProductoDatabase{

final dbprovider = DatabaseProvider.db;

  insertarModeloProducto(ModeloProductoModel modeloProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO ModeloProducto (id_modelo_producto,id_producto,modelo_producto,"
          "modelo_status_producto,estado) "
              "VALUES ('${modeloProductoModel.idModeloProducto}','${modeloProductoModel.idProducto}',"
              "'${modeloProductoModel.modeloProducto}','${modeloProductoModel.modeloStatusProducto}',"
              "'${modeloProductoModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Modelo de Productos");
    }
  }


  updateEstadoa0() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate('UPDATE ModeloProducto SET estado="0"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla ModeloProducto");
    }
  }

  updateEstadoa1(ModeloProductoModel modeloProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate('UPDATE ModeloProducto SET estado="1" where id_modelo_producto="${modeloProductoModel.idModeloProducto}" and id_producto="${modeloProductoModel.idProducto}"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla ModeloProductooo");
    }
  }

  

  Future<List<ModeloProductoModel>> obtenerModeloProducto() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ModeloProducto");

    List<ModeloProductoModel> list = res.isNotEmpty
        ? res.map((c) => ModeloProductoModel.fromJson(c)).toList()
        : [];

    return list;
  } 

  Future<List<ModeloProductoModel>> obtenerModeloProductoPorIdProducto(String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM ModeloProducto where id_producto='$idProducto' order by id_producto");

    List<ModeloProductoModel> list = res.isNotEmpty
        ? res.map((c) => ModeloProductoModel.fromJson(c)).toList()
        : [];

    return list;
  } 

   Future<List<ModeloProductoModel>> obtenerModeloProductoPorIdProductoEnEstado1(String idProducto) async {
    final db = await dbprovider.database;
    final res =
        await db.rawQuery("SELECT * FROM ModeloProducto where id_producto = '$idProducto' and estado='1'");

    List<ModeloProductoModel> list = res.isNotEmpty
        ? res.map((c) => ModeloProductoModel.fromJson(c)).toList()
        : [];

    return list;
  }
}