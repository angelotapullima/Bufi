import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';

class ProductosPantallaPrincipalDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarProductosPantallaPrincipal(ProductosPantallaModel productosPantallaModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO ProductosPantallaPrincipal (idProducto,idPantalla) "
          "VALUES('${productosPantallaModel.idProducto}','${productosPantallaModel.idPantalla}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<ProductosPantallaModel>> obtenerProductosPantallaPrincipal() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM ProductosPantallaPrincipal");

      List<ProductosPantallaModel> list = res.isNotEmpty ? res.map((c) => ProductosPantallaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
