import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/subcategoryModel.dart';

class SubcategoryDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarSubCategory(SubcategoryModel subcategoryModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Subcategory (id_subcategory,id_category,subcategory_name) "
          "VALUES('${subcategoryModel.idSubcategory}', '${subcategoryModel.idCategory}', '${subcategoryModel.subcategoryName}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<SubcategoryModel>> obtenerSubcategorias() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Subcategory");

      List<SubcategoryModel> list = res.isNotEmpty
          ? res.map((c) => SubcategoryModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

//Lsitar subactegorias por Id Categorias
  Future<List<SubcategoryModel>> obtenerSubcategoriasPorIdCategoria(
      String id) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Subcategory WHERE id_category= '$id' order by id_subcategory ");

      List<SubcategoryModel> list = res.isNotEmpty
          ? res.map((c) => SubcategoryModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<SubcategoryModel>> obtenerSubCategoriaXQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Subcategory WHERE subcategory_name LIKE '%$query%'");

      List<SubcategoryModel> list = res.isNotEmpty
          ? res.map((c) => SubcategoryModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datos");
      return [];
    }
  }
}
