
import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/productoModel.dart';

class  ProductoDatabase{


  final dbProvider = DatabaseProvider.db;

  insertarSubsidiaryGood(ProductoModel producto) async {
    final db = await dbProvider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Producto (id_producto, id_subsidiary, id_good, id_itemsubcategory,"
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
  }


  Future<List<ProductoModel>> obtenerSubsidiaryGood() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Producto");

    List<ProductoModel> list =
        res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
    return list;
  } 

  Future<List<ProductoModel>> obtenerProductoPorIdSubsidiaryGood(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Producto WHERE id_producto= '$id'");

    List<ProductoModel> list =
        res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
    return list;
  } 

 Future<List<ProductoModel>> obtenerProductosPorIdSubsidiary(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Producto WHERE id_subsidiary= '$id' order by id_producto");

    List<ProductoModel> list =
        res.isNotEmpty ? res.map((c) => ProductoModel.fromJson(c)).toList() : [];
    return list;
  } 

deshabilitarSubsidiaryProductoDb(ProductoModel goodModel)async{
    final db = await dbProvider.database;

    final res = await db.rawUpdate("UPDATE Producto SET " 
     
    "producto_status='0' "
    "WHERE id_producto = '${goodModel.idProducto}' " 
    );

    return res;
  }

habilitarSubsidiaryProductoDb(ProductoModel goodModel)async{
    final db = await dbProvider.database;

    final res = await db.rawUpdate("UPDATE Producto SET " 
     
    "producto_status='1' "
    "WHERE id_producto = '${goodModel.idProducto}' " 
    );

    return res;
  }

//Se utiliza para la busqueda
  Future<List<ProductoModel>> consultarProductoPorQuery(String query) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE producto_name LIKE '%$query%'");

    List<ProductoModel> list = res.isNotEmpty
        ? res.map((c) => ProductoModel.fromJson(c)).toList()
        : [];

    return list;
  }

  Future<List<ProductoModel>> obtenerProductoXIdItemSubcategoria(String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Producto WHERE id_itemsubcategory='$id'");

    List<ProductoModel> list = res.isNotEmpty
        ? res.map((c) => ProductoModel.fromJson(c)).toList()
        : [];

    return list;
  }
  
  

  

}