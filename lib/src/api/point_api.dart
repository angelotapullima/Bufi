import 'dart:convert';

import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PointApi {
  final prefs = Preferences();

  //Guardar favorito
  Future<dynamic> savePoint(String id) async {
    try {
      final res = await http
          .post(Uri.parse("$apiBaseURL/api/Negocio/save_point"), body: {
        'id_subsidiary': id,
        'app': 'true',
        'tn': prefs.token,
      });
      print("user : '${prefs.idUser}' subsidiary: '$id'");

      final response = json.decode(res.body);
      print(response);
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 0;
  }

  //eliminar favorito
  Future<dynamic> deletePoint(String id) async {
    try {
      final res = await http.post(
          Uri.parse("$apiBaseURL/api/Negocio/delete_point"),
          body: {'id_subsidiary': id, 'app': 'true', 'tn': prefs.token});
      print("user : '${prefs.idUser}' subsidiary: '$id'");

      final response = json.decode(res.body);
      print(response);
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 0;
  }

//Listar favorito
  Future<dynamic> listarPoints() async {
    try {
      final res = await http.post(
          Uri.parse("$apiBaseURL/api/Negocio/listar_mis_points"),
          body: {'app': 'true', 'tn': prefs.token});

      List response = json.decode(res.body);

      for (var i = 0; i < response.length; i++) {
        final pointModel = PointModel();
        //final pointDb= SubsidiaryDatabase();
        //List listPoint= await pointDb.obtenerSubsidiaryFavoritas();
        pointModel.idPoint = response[i]["id_point"];
        pointModel.idUser = response[i]["id_user"];
        pointModel.idSubsidiary = response[i]["id_subsidiary"];
        pointModel.idCompany = response[i]["id_company"];
        pointModel.subsidiaryName = response[i]["subsidiary_name"];
        pointModel.subsidiaryAddress = response[i]['subsidiary_address'];
        pointModel.subsidiaryCellphone = response[i]['subsidiary_cellphone'];
        pointModel.subsidiaryCellphone2 = response[i]['subsidiary_cellphone_2'];
        pointModel.subsidiaryEmail = response[i]['subsidiary_email'];
        pointModel.subsidiaryCoordX = response[i]['subsidiary_coord_x'];
        pointModel.subsidiaryCoordY = response[i]['subsidiary_coord_y'];
        pointModel.subsidiaryOpeningHours =
            response[i]['subsidiary_opening_hours'];
        pointModel.subsidiaryPrincipal = response[i]['subsidiary_principal'];
        pointModel.subsidiaryStatus = response[i]['subsidiary_status'];

        pointModel.idCity = response[i]['id_city'];
        pointModel.idCategory = response[i]['id_category'];
        pointModel.companyName = response[i]['company_name'];
        pointModel.companyRuc = response[i]['company_ruc'];
        pointModel.companyImage = response[i]['company_image'];
        pointModel.companyType = response[i]['company_type'];
        pointModel.companyShortcode = response[i]['company_shortcode'];
        pointModel.companyDelivery = response[i]['company_delivery'];
        pointModel.companyEntrega = response[i]['company_entrega'];
        pointModel.companyTarjeta = response[i]['company_tarjeta'];
        pointModel.companyVerified = response[i]['company_verified'];
        pointModel.companyRating = response[i]['company_rating'];
        pointModel.companyCreatedAt = response[i]['company_created_at'];
        pointModel.companyJoin = response[i]['company_join'];
        pointModel.companyStatus = response[i]['company_status'];
        pointModel.companyMt = response[i]['company_mt'];
        pointModel.companyMt = response[i]['category_name'];
      }

      print(response);
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 0;
  }
}
