import 'dart:convert';

import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/pantallaPrincipal/pantalla_principal_database.dart';
import 'package:bufi/src/database/pantallaPrincipal/productos_pantalla_principal.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PantallaPrincipalApi {
  final productoDatabase = ProductoDatabase();
  final pantallaPrincipalDatabase = PantallaPrincipalDatabase();
  final productosPantallaPrincipalDatabase = ProductosPantallaPrincipalDatabase();
  final companyDatabase = CompanyDatabase();
  final prefs = Preferences();

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

          pantallaPrincipalModel.nombre = res['secciones'][i]['titulo'].toString();
          pantallaPrincipalModel.tipo = res['secciones'][i]['tipo'].toString();
          pantallaPrincipalModel.idPantalla = res['secciones'][i]['id'].toString();
          await pantallaPrincipalDatabase.insertarPantallaPrincipal(pantallaPrincipalModel);

          if (res['secciones'][i]['productos'].length > 0) {
            for (var x = 0; x < res['secciones'][i]['productos'].length; x++) {
              ProductoModel productoModel = ProductoModel();
              productoModel.idProducto = res['secciones'][i]['productos'][x]["id_subsidiarygood"];
              productoModel.idSubsidiary = res['secciones'][i]['productos'][x]["id_subsidiary"];
              productoModel.idGood = res['secciones'][i]['productos'][x]["id_good"];
              productoModel.idItemsubcategory = res['secciones'][i]['productos'][x]['id_itemsubcategory'];
              productoModel.productoName = res['secciones'][i]['productos'][x]['subsidiary_good_name'];
              productoModel.productoPrice = res['secciones'][i]['productos'][x]['subsidiary_good_price'];
              productoModel.productoCurrency = res['secciones'][i]['productos'][x]['subsidiary_good_currency'];
              productoModel.productoImage = res['secciones'][i]['productos'][x]['subsidiary_good_image'];
              productoModel.productoCharacteristics = res['secciones'][i]['productos'][x]['subsidiary_good_characteristics'];
              productoModel.productoBrand = res['secciones'][i]['productos'][x]['subsidiary_good_brand'];
              productoModel.productoModel = res['secciones'][i]['productos'][x]['subsidiary_good_model'];
              productoModel.productoType = res['secciones'][i]['productos'][x]['subsidiary_good_type'];
              productoModel.productoSize = res['secciones'][i]['productos'][x]['subsidiary_good_size'];
              productoModel.productoStock = res['secciones'][i]['productos'][x]['subsidiary_good_stock'];
              productoModel.productoMeasure = res['secciones'][i]['productos'][x]['subsidiary_good_stock_measure'];
              productoModel.productoRating = res['secciones'][i]['productos'][x]['subsidiary_good_rating'];
              productoModel.productoUpdated = res['secciones'][i]['productos'][x]['subsidiary_good_updated'];
              productoModel.productoStatus = res['secciones'][i]['productos'][x]['subsidiary_good_status'];

              var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(res['secciones'][i]['productos'][x]["id_subsidiarygood"]);

              if (productList.length > 0) {
                productoModel.productoFavourite = productList[0].productoFavourite;
              } else {
                productoModel.productoFavourite = '0';
              }
              await productoDatabase.insertarProducto(productoModel, 'Inicio/pantalla_principal');

              CompanyModel companyModel = CompanyModel();

              companyModel.idCompany = res['secciones'][i]['productos'][x]['id_company'];
              companyModel.idUser = res['secciones'][i]['productos'][x]['id_user'];
              companyModel.idCity = res['secciones'][i]['productos'][x]['id_city'];
              companyModel.idCategory = res['secciones'][i]['productos'][x]['id_category'];
              companyModel.companyName = res['secciones'][i]['productos'][x]['company_name'];
              companyModel.companyRuc = res['secciones'][i]['productos'][x]['company_ruc'];
              companyModel.companyImage = res['secciones'][i]['productos'][x]['company_image'];
              companyModel.companyType = res['secciones'][i]['productos'][x]['company_type'];
              companyModel.companyShortcode = res['secciones'][i]['productos'][x]['company_shortcode'];
              companyModel.companyDeliveryPropio = res['secciones'][i]['productos'][x]['company_delivery_propio'];
              companyModel.companyDelivery = res['secciones'][i]['productos'][x]['company_delivery'];
              companyModel.companyEntrega = res['secciones'][i]['productos'][x]['company_entrega'];
              companyModel.companyTarjeta = res['secciones'][i]['productos'][x]['company_tarjeta'];
              companyModel.companyVerified = res['secciones'][i]['productos'][x]['company_verified'];
              companyModel.companyRating = res['secciones'][i]['productos'][x]['company_rating'];
              companyModel.companyCreatedAt = res['secciones'][i]['productos'][x]['company_created_at'];
              companyModel.companyJoin = res['secciones'][i]['productos'][x]['company_join'];
              companyModel.companyStatus = res['secciones'][i]['productos'][x]['company_status'];

              if (companyModel.idUser == prefs.idUser) {
                companyModel.miNegocio = '1';
              } else {
                companyModel.miNegocio = '0';
              }
              //companyModel.miNegocio= decodedData[]
              await companyDatabase.insertarCompany(companyModel,'Inicio/pantalla_principal');

              ProductosPantallaModel productosPantallaModel = ProductosPantallaModel();
              productosPantallaModel.idProducto = res['secciones'][i]['productos'][x]['id_subsidiarygood'];
              productosPantallaModel.idPantalla = pantallaPrincipalModel.idPantalla;
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
