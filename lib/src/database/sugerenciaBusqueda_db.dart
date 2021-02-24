





import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/sugerenciaBusquedaModel.dart';

class SugerenciaBusquedaDb{

  final dbProvider = DatabaseProvider.db;

  insertarProducto(SugerenciaBusquedaModel sugerenciaBusqModel) async {
    try {
      final db = await dbProvider.database;
      
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO SugerenciaBusqueda (id_itemsubcategory,nombre_producto,id_producto,tipo) "
          "VALUES('${sugerenciaBusqModel.idItemSubcategoria}','${sugerenciaBusqModel.nombreProducto}','${sugerenciaBusqModel.idProducto}','${sugerenciaBusqModel.tipo}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
      print(e); 
    }
  } 

  Future<List<SugerenciaBusquedaModel>> obtenerSugerencia() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM SugerenciaBusqueda group by id_itemsubcategory");
    
    List<SugerenciaBusquedaModel> list = res.isNotEmpty
        ? res.map((c) => SugerenciaBusquedaModel.fromJson(c)).toList()
        : [];
    return list;
  }

}