


import 'dart:convert';

import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PantallaPrincipalApi{




  final categoryDatabase = CategoryDatabase();
  final subcategoryDatabase = SubcategoryDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final productoDatabase = ProductoDatabase();



  Future<int> obtenerPantallaPrincipal() async {
    //List<CategoriaModel> categoriaList = [];
    try {
      var response = await http.post(Uri.parse("$apiBaseURL/api/Inicio/pantalla_principal"), body: {});
      var res = jsonDecode(response.body);

   
   

      for (var i = 0; i < res.length; i++) {
        
      

        CategoriaModel categ = CategoriaModel();
        categ.idCategory = res[i]["id_category"];
        categ.categoryName = res[i]["category_name"];

        //categoriaList.add(categ);
        await categoryDatabase.insertarCategory(categ);

        SubcategoryModel subcategoryModel = SubcategoryModel();
        subcategoryModel.idCategory = res[i]["id_category"];
        subcategoryModel.idSubcategory = res[i]["id_subcategory"];
        subcategoryModel.subcategoryName = res[i]["subcategory_name"];

        await subcategoryDatabase.insertarSubCategory(subcategoryModel);

        //Insertamos el itemsubcategoria
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
        itemSubCategoriaModel.idItemsubcategory = res[i]['id_itemsubcategory'];
        itemSubCategoriaModel.idSubcategory = res[i]['id_subcategory'];
        itemSubCategoriaModel.itemsubcategoryName = res[i]['itemsubcategory_name'];
        itemSubCategoriaModel.itemsubcategoryImage = res[i]['itemsubcategory_img'];
        await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Inicio/listar_categorias');
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