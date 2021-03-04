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


}