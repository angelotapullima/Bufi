import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/productoModel.dart';

class ProductoDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarProducto(ProductoModel producto, String funcion) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Producto (id_producto, id_subsidiary, id_good, id_itemsubcategory,"
          " producto_name, producto_price, producto_currency, producto_image, producto_characteristics,"
          "producto_brand, producto_model,producto_type,producto_size,producto_stock,"
          "producto_measure,producto_rating,producto_updated,producto_status, producto_favourite) "
          "VALUES('${producto.idProducto}', '${producto.idSubsidiary}','${producto.idGood}',"
          "'${producto.idItemsubcategory}','${producto.productoName}','${producto.productoPrice}',"
          "'${producto.productoCurrency}', '${producto.productoImage}','${producto.productoCharacteristics}',"
          "'${producto.productoBrand}', '${producto.productoModel}','${producto.productoType}',"
          "'${producto.productoSize}', '${producto.productoStock}','${producto.productoMeasure}',"
          " '${producto.productoRating}','${producto.productoUpdated}', '${producto.productoStatus}', '${producto.productoFavourite}')");

      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace --- error en la funcion $funcion");

      return 0;
      //return categoriaList;
    }
  }

  updateProducto(ProductoModel productoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Producto SET id_subsidiary= '${productoModel.idSubsidiary}',"
          "id_good='${productoModel.idGood}',"
          "id_itemsubcategory='${productoModel.idItemsubcategory}',"
          "producto_name='${productoModel.productoName}',"
          "producto_price='${productoModel.productoPrice}',"
          "producto_currency='${productoModel.productoCurrency}',"
          "producto_image='${productoModel.productoImage}',"
          "producto_characteristics='${productoModel.productoCharacteristics}',"
          "producto_brand='${productoModel.productoBrand}',"
          "producto_model='${productoModel.productoModel}',"
          "producto_type= '${productoModel.productoType}',"
          "producto_size='${productoModel.productoSize}',"
          "producto_stock='${productoModel.productoStock}',"
          "producto_measure='${productoModel.productoMeasure}',"
          "producto_rating='${productoModel.productoRating}',"
          "producto_updated= '${productoModel.productoUpdated}',"
          "producto_status='${productoModel.productoStatus}',"
          "producto_favourite= '${productoModel.productoFavourite}' "
          "WHERE id_producto='${productoModel.idProducto}' ");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ProductoModel>> obtenerSubsidiaryGood() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto order by id_producto");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> obtenerProductoPorIdSubsidiaryGood(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_producto= '$id'");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> obtenerProductosPorIdSubsidiary(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_subsidiary= '$id' order by id_producto");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
 
  Future<List<ProductoModel>> obtenerProductosFavoritosPorIdSubsidiary(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_subsidiary= '$id' and producto_favourite='1' order by id_producto");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deshabilitarSubsidiaryProductoDb(ProductoModel goodModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Producto SET "
          "producto_status='0' "
          "WHERE id_producto = '${goodModel.idProducto}' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  habilitarSubsidiaryProductoDb(ProductoModel goodModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Producto SET "
          "producto_status='1' "
          "WHERE id_producto = '${goodModel.idProducto}' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

//Se utiliza para la busqueda con el nombre del producto
  Future<List<ProductoModel>> consultarProductoPorQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE producto_name LIKE '%$query%'");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Se utiliza para la busqueda con el nombre del itemSubcategoria
  Future<List<ProductoModel>> consultarProductoPorIdItemsub(String idItemSubcategoria) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto  WHERE id_itemsubcategory= '$idItemSubcategoria'");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Para la busqueda del producto x sucursal
  Future<List<ProductoModel>> obtenerProductosPorIdSubsidiaryPorQuery(String idSucursal, String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_subsidiary= '$idSucursal' and producto_name LIKE '%$query%'");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> obtenerProductoXIdItemSubcategoria(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_itemsubcategory='$id' order by id_producto");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> obtenerProductosFavoritos() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE producto_favourite=1");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> deleteProductosFavoritos() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE producto_favourite=0");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> sqlConsulta(String sql) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery(sql);

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ProductoModel>> obtenerProductosPorIdGood(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Producto WHERE id_good= '$id'");

      List<ProductoModel> list = res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
