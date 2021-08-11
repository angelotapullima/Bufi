import 'dart:convert';

import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/pantallaPrincipal/pantalla_principal_database.dart';
import 'package:bufi/src/database/pantallaPrincipal/productos_pantalla_principal.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PantallaPrincipalApi {
  final productoDatabase = ProductoDatabase();
  final pantallaPrincipalDatabase = PantallaPrincipalDatabase();
  final productosPantallaPrincipalDatabase = ProductosPantallaPrincipalDatabase();

  Future<int> obtenerPantallaPrincipal() async {
    //List<CategoriaModel> categoriaList = [];
    try {
      var response = await http.post(Uri.parse("$apiBaseURL/api/Inicio/pantalla_principal"), body: {
        'id_ciudad': '1',
        'app': 'true',
      });
      var res = jsonDecode(response.body);

      if (res['secciones'].length > 0) {
        for (var i = 0; i < res['secciones'].length; i++) {
          PantallaPrincipalModel pantallaPrincipalModel = PantallaPrincipalModel();

          pantallaPrincipalModel.nombre = res['secciones'][i]['titulo'];
          pantallaPrincipalModel.tipo = res['secciones'][i]['tipo'];
          pantallaPrincipalModel.idPantalla = res['secciones'][i]['id'];
          await pantallaPrincipalDatabase.insertarPantallaPrincipal(pantallaPrincipalModel);

          if (res['secciones'][i]['titulo']['productos'].length > 0) {
            for (var x = 0; x < res['secciones'][i]['titulo']['productos'].length; x++) {
              ProductoModel productoModel = ProductoModel();
              productoModel.idProducto = res['secciones'][i]['titulo']['productos'][x]["id_subsidiarygood"];
              productoModel.idSubsidiary = res['secciones'][i]['titulo']['productos'][x]["id_subsidiary"];
              productoModel.idGood = res['secciones'][i]['titulo']['productos'][x]["id_good"];
              productoModel.idItemsubcategory = res['secciones'][i]['titulo']['productos'][x]['id_itemsubcategory'];
              productoModel.productoName = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_name'];
              productoModel.productoPrice = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_price'];
              productoModel.productoCurrency = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_currency'];
              productoModel.productoImage = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_image'];
              productoModel.productoCharacteristics = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_characteristics'];
              productoModel.productoBrand = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_brand'];
              productoModel.productoModel = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_model'];
              productoModel.productoType = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_type'];
              productoModel.productoSize = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_size'];
              productoModel.productoStock = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_stock'];
              productoModel.productoMeasure = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_stock_measure'];
              productoModel.productoRating = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_rating'];
              productoModel.productoUpdated = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_updated'];
              productoModel.productoStatus = res['secciones'][i]['titulo']['productos'][x]['subsidiary_good_status'];

              var productList =
                  await productoDatabase.obtenerProductoPorIdSubsidiaryGood(res['secciones'][i]['titulo']['productos'][x]["id_subsidiarygood"]);

              if (productList.length > 0) {
                productoModel.productoFavourite = productList[0].productoFavourite;
              } else {
                productoModel.productoFavourite = '0';
              }
              await productoDatabase.insertarProducto(productoModel, 'Inicio/pantalla_principal');

              ProductosPantallaModel productosPantallaModel = ProductosPantallaModel();
              productosPantallaModel.idProducto = res['secciones'][i]['titulo']['productos'][x]['id_subsidiarygood'];
              productosPantallaModel.idPantalla = i.toString();
              await productosPantallaPrincipalDatabase.insertarProductosPantallaPrincipal(productosPantallaModel);
            }
          }
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
