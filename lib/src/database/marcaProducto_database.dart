import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';

class MarcaProductoDatabase{

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

  Future<List<MarcaProductoModel>> obtenerMarcaProducto() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM MarcaProducto");

    List<MarcaProductoModel> list = res.isNotEmpty
        ? res.map((c) => MarcaProductoModel.fromJson(c)).toList()
        : [];

    return list;
  } 

  Future<List<MarcaProductoModel>> obtenerMarcaProductoPorIdProducto(String idProducto) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM MarcaProducto where id_producto='$idProducto' order by id_producto");

    List<MarcaProductoModel> list = res.isNotEmpty
        ? res.map((c) => MarcaProductoModel.fromJson(c)).toList()
        : [];

    return list;
  } 


}