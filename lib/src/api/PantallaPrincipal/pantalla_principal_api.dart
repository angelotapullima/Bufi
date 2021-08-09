import 'dart:convert';

import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/pantalla_principal_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PantallaPrincipalApi {
  final categoryDatabase = CategoryDatabase();
  final subcategoryDatabase = SubcategoryDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final productoDatabase = ProductoDatabase();
  final pantallaPrincipalDatabase =PantallaPrincipalDatabase();

  Future<int> obtenerPantallaPrincipal() async {
    //List<CategoriaModel> categoriaList = [];
    try {
      var response = await http.post(Uri.parse("$apiBaseURL/api/Inicio/pantalla_principal"), body: {});
      var res = jsonDecode(response.body);

      if (res['categorias'].length > 0) {
        for (var i = 0; i < res['categorias'].length; i++) {
          CategoriaModel categ = CategoriaModel();
          categ.idCategory = res['categorias'][i]["id_category"];
          categ.categoryName = res['categorias'][i]["category_name"];
          categ.categoryImage = res['categorias'][i]["category_img"];
          categ.categoryEstado = res['categorias'][i]["category_estado"];

          //categoriaList.add(categ);
          await categoryDatabase.insertarCategory(categ,'Inicio/pantalla_principal');

          SubcategoryModel subcategoryModel = SubcategoryModel();
          subcategoryModel.idCategory = res['categorias'][i]["id_category"];
          subcategoryModel.idSubcategory = res['categorias'][i]["id_subcategory"];
          subcategoryModel.subcategoryName = res['categorias'][i]["subcategory_name"];

          await subcategoryDatabase.insertarSubCategory(subcategoryModel,'Inicio/pantalla_principal');

          //Insertamos el itemsubcategoria
          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idItemsubcategory = res['categorias'][i]['id_itemsubcategory'];
          itemSubCategoriaModel.idSubcategory = res['categorias'][i]['id_subcategory'];
          itemSubCategoriaModel.itemsubcategoryName = res['categorias'][i]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = res['categorias'][i]['itemsubcategory_img'];
          itemSubCategoriaModel.itemsubcategoryEstado = res['categorias'][i]['itemsubcategory_estado'];
          await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Inicio/pantalla_principal');

          PantallaPrincipalModel pantallaPrincipalModel = PantallaPrincipalModel();

          pantallaPrincipalModel.nombre =  itemSubCategoriaModel.itemsubcategoryName;
          pantallaPrincipalModel.tipo = '1';//categorias
          pantallaPrincipalModel.idPantalla = itemSubCategoriaModel.idItemsubcategory;


          await pantallaPrincipalDatabase.insertarPantallaPrincipal(pantallaPrincipalModel);
        }
      }

      return 0;
      //return categoriaList;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
      //return categoriaList;
    }
  }
}
