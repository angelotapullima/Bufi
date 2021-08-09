import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/categoriaModel.dart';

class CategoryDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarCategory(CategoriaModel categoriaModel,String funcion ) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO Category (id_category,category_name,category_estado,category_img) "
          "VALUES('${categoriaModel.idCategory}', '${categoriaModel.categoryName}', '${categoriaModel.categoryEstado}', '${categoriaModel.categoryImage}')");

      return res;
    } catch (e) {
      print("$e Error en la tabla Categoria $funcion");
    }
  } 

//------Categorias
  Future<List<CategoriaModel>> obtenerCategorias() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Category order by id_category");

      List<CategoriaModel> list = res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<CategoriaModel>> obtenerCategoriaPorIdCateg(String idCategoria) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Category WHERE id_category='$idCategoria'");

      List<CategoriaModel> list = res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Actualizar Negocio
  Future<List<CategoriaModel>> obtenerCategoriasporNombre(String nombrecateg) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Category WHERE category_name= '$nombrecateg'");

      List<CategoriaModel> list = res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Actualizar Negocio
  Future<List<CategoriaModel>> obtenerCategoriasporID(String idCategory) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Category WHERE id_category= '$idCategory'");

      List<CategoriaModel> list = res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Se utiliza para la busqueda
  Future<List<CategoriaModel>> consultarCategoriaPorQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Category WHERE category_name LIKE '%$query%'");

      List<CategoriaModel> list = res.isNotEmpty ? res.map((c) => CategoriaModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
