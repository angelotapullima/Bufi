import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';

class ItemsubCategoryDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarItemSubCategoria(ItemSubCategoriaModel itemSubCategoriaModel, String funcion) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO ItemSubcategorias (id_itemsubcategory,id_subcategory,itemsubcategory_img,itemsubcategory_estado,itemsubcategory_name) "
          "VALUES('${itemSubCategoriaModel.idItemsubcategory}', '${itemSubCategoriaModel.idSubcategory}', '${itemSubCategoriaModel.itemsubcategoryImage}', '${itemSubCategoriaModel.itemsubcategoryEstado}', '${itemSubCategoriaModel.itemsubcategoryName}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<ItemSubCategoriaModel>> obtenerItemSubCategoria() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM ItemSubcategorias");

      List<ItemSubCategoriaModel> list = res.isNotEmpty ? res.map((c) => ItemSubCategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ItemSubCategoriaModel>> obtenerItemSubCategoriaXIdSubcategoria(String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM ItemSubcategorias WHERE id_subcategory='$id'");

      List<ItemSubCategoriaModel> list = res.isNotEmpty ? res.map((c) => ItemSubCategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ItemSubCategoriaModel>> obtenerItemSubCategoriaXIdItemSubcategoria(String idItemSubcateg) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM ItemSubcategorias WHERE id_itemsubcategory='$idItemSubcateg'");

      List<ItemSubCategoriaModel> list = res.isNotEmpty ? res.map((c) => ItemSubCategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<ItemSubCategoriaModel>> obtenerItemSubCategoriaXQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM ItemSubcategorias WHERE itemsubcategory_name LIKE '%$query%'");

      List<ItemSubCategoriaModel> list = res.isNotEmpty ? res.map((c) => ItemSubCategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datos");
      return [];
    }
  }

  // Future<List<ItemSubCategoriaModel>> obtenerItemSubCategoriaX(String id) async {
  //   final db = await dbProvider.database;
  //   final res = await db.rawQuery("SELECT * FROM ItemSubcategorias i inner join Subsidiarygood sg ON i.id_itemsubcategory= sg.id_itemsubcategory INNER JOIN Subsidiaryservice sc ON i.id_itemsubcategory= sc.id_itemsubcategory WHERE id_itemsubcategory");

  //   List<ItemSubCategoriaModel> list =
  //       res.isNotEmpty ? res.map((c) => ItemSubCategoriaModel.fromJson(c)).toList() : [];
  //   return list;
  // }

}
