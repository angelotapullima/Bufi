
import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/categoriaModel.dart';

class CategoryDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarCategory(CategoriaModel categoriaModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Category (id_category,category_name) "
          "VALUES('${categoriaModel.idCategory}', '${categoriaModel.categoryName}')"
          );

      return res;
    } catch (e) {
      print("$e Error en la tabla Categoria");
    }
  } 
//------Categorias
  Future<List<CategoriaModel>> obtenerCategorias() async {
    try{
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Category order by id_category");

    List<CategoriaModel> list =
        res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
    return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  }

  //Actualizar Negocio
  Future<List<CategoriaModel>> obtenerCategoriasporNombre(String nombrecateg) async {
    try{
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Category WHERE category_name= '$nombrecateg'");

    List<CategoriaModel> list =
        res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
    return list;

    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  }

  //Actualizar Negocio
  Future<List<CategoriaModel>> obtenerCategoriasporID(String idCategory) async {
    try{
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Category WHERE id_category= '$idCategory'");

    List<CategoriaModel> list =
        res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
    return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  }

  
  

  
}
