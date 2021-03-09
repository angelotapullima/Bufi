import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/galeriaProductoModel.dart';


class GaleriaProductoDatabase{

final dbprovider = DatabaseProvider.db;

  insertarGaleriaProducto(GaleriaProductoModel galeriaProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO galeriaProducto (id_producto_galeria,id_producto,"
          "galeria_foto,estado) "
              "VALUES ('${galeriaProductoModel.idGaleriaProducto}','${galeriaProductoModel.idProducto}',"
              "'${galeriaProductoModel.galeriaFoto}',"
              "'${galeriaProductoModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Galeria de Productos");
    }
  }

  Future<List<GaleriaProductoModel>> obtenergaleriaProducto() async {
    try{
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM galeriaProducto");

    List<GaleriaProductoModel> list = res.isNotEmpty
        ? res.map((c) => GaleriaProductoModel.fromJson(c)).toList()
        : [];

    return list;} catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  } 

  Future<List<GaleriaProductoModel>> obtenerGaleriaProductoPorIdProducto(String idProducto) async {
    try{
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM galeriaProducto where id_producto='$idProducto' order by id_producto");

    List<GaleriaProductoModel> list = res.isNotEmpty
        ? res.map((c) => GaleriaProductoModel.fromJson(c)).toList()
        : [];

    return list;} catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  } 


}