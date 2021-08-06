import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NegociosApi {
  //Instancia de la BD de Company
  final companyDatabase = CompanyDatabase();
  final prefs = Preferences();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future<dynamic> obtenerCompany() async {
    try {
      var response = await http.post(Uri.parse("$apiBaseURL/api/Negocio/listar_negocios_resumen"), body: {'id_ciudad': '1'});

      final decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        final listCompany = await companyDatabase.obtenerCompanyPorIdCompany(decodedData[i]['id_company']);

        if (listCompany.length > 0) {
          CompanyModel cmodel = CompanyModel();
          cmodel.idCompany = decodedData[i]['id_company'];
          cmodel.idUser = decodedData[i]['id_user'];
          cmodel.idCity = decodedData[i]['id_city'];
          cmodel.idCategory = decodedData[i]['id_category'];
          cmodel.companyName = decodedData[i]['company_name'];
          cmodel.companyRuc = decodedData[i]['company_ruc'];
          cmodel.companyImage = decodedData[i]['company_image'];
          cmodel.companyType = decodedData[i]['company_type'];
          cmodel.companyShortcode = decodedData[i]['company_shortcode'];
          cmodel.companyDelivery = decodedData[i]['company_delivery'];
          cmodel.companyEntrega = decodedData[i]['company_entrega'];
          cmodel.companyTarjeta = decodedData[i]['company_tarjeta'];
          cmodel.companyVerified = decodedData[i]['company_verified'];
          cmodel.companyRating = decodedData[i]['company_rating'];
          cmodel.companyCreatedAt = decodedData[i]['company_created_at'];
          cmodel.companyJoin = decodedData[i]['company_join'];
          cmodel.companyStatus = decodedData[i]['company_status'];
          cmodel.companyMt = decodedData[i]['company_mt'];
          cmodel.miNegocio = decodedData[i]['mi_negocio'].toString();

          await companyDatabase.insertarCompany(cmodel);

          final listSucursal = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData[i]['id_subsidiary']);

          if (listSucursal.length > 0) {
            SubsidiaryModel smodel = SubsidiaryModel();
            smodel.idSubsidiary = decodedData[i]['id_subsidiary'];
            smodel.idCompany = decodedData[i]['id_company'];
            smodel.subsidiaryName = decodedData[i]['subsidiary_name'];
            smodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
            smodel.subsidiaryCellphone2 = decodedData[i]['subsidiary_cellphone_2'];
            smodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
            smodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
            smodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
            smodel.subsidiaryOpeningHours = decodedData[i]['subsidiary_opening_hours'];
            smodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
            smodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
            smodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
            smodel.subsidiaryImg = decodedData[i]['subsidiary_img'];
            smodel.subsidiaryFavourite = listSucursal[0].subsidiaryFavourite;
            await subsidiaryDatabase.insertarSubsidiary(smodel);
          }
        } else {
          CompanyModel cmodel = CompanyModel();
          SubsidiaryModel smodel = SubsidiaryModel();
          cmodel.idCompany = decodedData[i]['id_company'];
          cmodel.idUser = decodedData[i]['id_user'];
          cmodel.idCity = decodedData[i]['id_city'];
          cmodel.idCategory = decodedData[i]['id_category'];
          cmodel.companyName = decodedData[i]['company_name'];
          cmodel.companyRuc = decodedData[i]['company_ruc'];
          cmodel.companyImage = decodedData[i]['company_image'];
          cmodel.companyType = decodedData[i]['company_type'];
          cmodel.companyShortcode = decodedData[i]['company_shortcode'];
          cmodel.companyDelivery = decodedData[i]['company_delivery'];
          cmodel.companyEntrega = decodedData[i]['company_entrega'];
          cmodel.companyTarjeta = decodedData[i]['company_tarjeta'];
          cmodel.companyVerified = decodedData[i]['company_verified'];
          cmodel.companyRating = decodedData[i]['company_rating'];
          cmodel.companyCreatedAt = decodedData[i]['company_created_at'];
          cmodel.companyJoin = decodedData[i]['company_join'];
          cmodel.companyStatus = decodedData[i]['company_status'];
          cmodel.companyMt = decodedData[i]['company_mt'];
          cmodel.miNegocio = decodedData[i]['mi_negocio'].toString();

          await companyDatabase.insertarCompany(cmodel);

          smodel.idSubsidiary = decodedData[i]['id_subsidiary'];
          smodel.idCompany = decodedData[i]['id_company'];
          smodel.subsidiaryName = decodedData[i]['subsidiary_name'];
          smodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
          smodel.subsidiaryCellphone2 = decodedData[i]['subsidiary_cellphone_2'];
          smodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          smodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          smodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          smodel.subsidiaryOpeningHours = decodedData[i]['subsidiary_opening_hours'];
          smodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          smodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          smodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
          smodel.subsidiaryImg = decodedData[i]['subsidiary_img'];
          smodel.subsidiaryFavourite = '0';
          await subsidiaryDatabase.insertarSubsidiary(smodel);
        }
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> obtenerNegocioPorId(String id) async {
    try {
      var response = await http.post(Uri.parse("$apiBaseURL/api/Negocio/listar_negocio_por_id"), body: {'id_company': id});

      final decodedData = json.decode(response.body);

      final listCompany = await companyDatabase.obtenerCompanyPorIdCompany(id);
      final listSucursal = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData['id_subsidiary']);

      if (listCompany.length > 0) {
        CompanyModel cmodel = CompanyModel();
        SubsidiaryModel smodel = SubsidiaryModel();
        cmodel.idCompany = decodedData['id_company'];
        cmodel.idUser = decodedData['id_user'];
        cmodel.idCity = decodedData['id_city'];
        cmodel.idCategory = decodedData['id_category'];
        cmodel.companyName = decodedData['company_name'];
        cmodel.companyRuc = decodedData['company_ruc'];
        cmodel.companyImage = decodedData['company_image'];
        cmodel.companyType = decodedData['company_type'];
        cmodel.companyShortcode = decodedData['company_shortcode'];
        cmodel.companyDelivery = decodedData['company_delivery'];
        cmodel.companyEntrega = decodedData['company_entrega'];
        cmodel.companyTarjeta = decodedData['company_tarjeta'];
        cmodel.companyVerified = decodedData['company_verified'];
        cmodel.companyRating = decodedData['company_rating'];
        cmodel.companyCreatedAt = decodedData['company_created_at'];
        cmodel.companyJoin = decodedData['company_join'];
        cmodel.companyStatus = decodedData['company_status'];
        cmodel.companyMt = decodedData['company_mt'];
        cmodel.miNegocio = listCompany[0].miNegocio;

        await companyDatabase.insertarCompany(cmodel);

        smodel.idCompany = decodedData['id_company'];
        smodel.idSubsidiary = decodedData['id_subsidiary'];
        smodel.subsidiaryName = decodedData['subsidiary_name'];
        smodel.subsidiaryCellphone = decodedData['subsidiary_cellphone'];
        smodel.subsidiaryCellphone2 = decodedData['subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData['subsidiary_address'];
        smodel.subsidiaryImg = decodedData['subsidiary_img'];
        smodel.subsidiaryFavourite = listSucursal[0].subsidiaryFavourite;

        await subsidiaryDatabase.insertarSubsidiary(smodel);
      } else {
        CompanyModel cmodel = CompanyModel();
        SubsidiaryModel smodel = SubsidiaryModel();
        cmodel.idCompany = decodedData['id_company'].toString().trim();
        cmodel.idUser = decodedData['id_user'];
        cmodel.idCity = decodedData['id_city'];
        cmodel.idCategory = decodedData['id_category'];
        cmodel.companyName = decodedData['company_name'];
        cmodel.companyRuc = decodedData['company_ruc'];
        cmodel.companyImage = decodedData['company_image'];
        cmodel.companyType = decodedData['company_type'];
        cmodel.companyShortcode = decodedData['company_shortcode'];
        cmodel.companyDelivery = decodedData['company_delivery'];
        cmodel.companyEntrega = decodedData['company_entrega'];
        cmodel.companyTarjeta = decodedData['company_tarjeta'];
        cmodel.companyVerified = decodedData['company_verified'];
        cmodel.companyRating = decodedData['company_rating'];
        cmodel.companyCreatedAt = decodedData['company_created_at'];
        cmodel.companyJoin = decodedData['company_join'];
        cmodel.companyStatus = decodedData['company_status'];
        cmodel.companyMt = decodedData['company_mt'];
        cmodel.miNegocio = decodedData['mi_negocio'].toString();

        await companyDatabase.insertarCompany(cmodel);

        smodel.idSubsidiary = decodedData['id_subsidiary'];
        smodel.idCompany = decodedData['id_company'];
        smodel.subsidiaryName = decodedData['subsidiary_name'];
        smodel.subsidiaryCellphone = decodedData['subsidiary_cellphone'];
        smodel.subsidiaryCellphone2 = decodedData['subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData['subsidiary_address'];
        smodel.subsidiaryImg = decodedData['subsidiary_img'];
        smodel.subsidiaryFavourite = '0';
        await subsidiaryDatabase.insertarSubsidiary(smodel);
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> listarCompany() async {
    try {
      //funcion para obtener el producto con el id mas alto de la lista
      final companys = await companyDatabase.obtenerCompany();

      double mayor = 0;
      double mayor2 = 0;
      double menor = 0;
      if (companys.length > 0) {
        for (var i = 0; i < companys.length; i++) {
          if (double.parse(companys[i].idCompany) > mayor) {
            mayor = double.parse(companys[i].idCompany);
          }
        }
      }
      mayor2 = mayor;

      if (companys.length > 0) {
        for (var x = 0; x < companys.length; x++) {
          if (double.parse(companys[x].idCompany) < mayor2) {
            menor = double.parse(companys[x].idCompany);
            mayor2 = menor;
          } else {
            menor = mayor2;
          }
        }
      }

      var response = await http.post(Uri.parse("$apiBaseURL/api/Negocio/listar_negocios"), body: {
        'id_ciudad': '1',
        'limite_sup': mayor.toString(),
        'limite_inf': menor.toString()
        //menor.toString()
      });

      final decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData['results'].length; i++) {
        CompanyModel cmodel = CompanyModel();

        cmodel.idCompany = decodedData['results'][i]['id_company'].toString();
        cmodel.idUser = decodedData['results'][i]['id_user'].toString();
        cmodel.idCity = decodedData['results'][i]['id_city'].toString();
        cmodel.idCategory = decodedData['results'][i]['id_category'].toString();
        cmodel.companyName = decodedData['results'][i]['company_name'].toString();
        cmodel.companyRuc = decodedData['results'][i]['company_ruc'].toString();
        cmodel.companyImage = decodedData['results'][i]['company_image'].toString();
        cmodel.companyType = decodedData['results'][i]['company_type'].toString();
        cmodel.companyShortcode = decodedData['results'][i]['company_shortcode'].toString();
        cmodel.companyDelivery = decodedData['results'][i]['company_delivery'].toString();
        cmodel.companyEntrega = decodedData['results'][i]['company_entrega'].toString();
        cmodel.companyTarjeta = decodedData['results'][i]['company_tarjeta'].toString();
        cmodel.companyVerified = decodedData['results'][i]['company_verified'].toString();
        cmodel.companyRating = decodedData['results'][i]['company_rating'].toString();
        cmodel.companyCreatedAt = decodedData['results'][i]['company_created_at'].toString();
        cmodel.companyJoin = decodedData['results'][i]['company_join'].toString();
        cmodel.companyStatus = decodedData['results'][i]['company_status'].toString();
        cmodel.companyMt = decodedData['results'][i]['company_mt'].toString();
        cmodel.miNegocio = decodedData['results'][i]['mi_negocio'].toString();

        await companyDatabase.insertarCompany(cmodel);

        SubsidiaryModel smodel = SubsidiaryModel();
        smodel.idCompany = decodedData['results'][i]['id_company'];
        smodel.idSubsidiary = decodedData['results'][i]['id_subsidiary'];
        smodel.subsidiaryName = decodedData['results'][i]['subsidiary_name'];
        smodel.subsidiaryCellphone = decodedData['results'][i]['subsidiary_cellphone'];
        smodel.subsidiaryCellphone2 = decodedData['results'][i]['subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['results'][i]['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['results'][i]['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['results'][i]['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours = decodedData['results'][i]['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData['results'][i]['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['results'][i]['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData['results'][i]['subsidiary_address'];
        smodel.subsidiaryImg = decodedData['results'][i]['subsidiary_img'];
        //await subsidiaryDatabase.insertarSubsidiary(smodel);

        // final listCompany = await companyDatabase
        //     .obtenerCompanyPorIdCompany(decodedData['results'][i]['id_company']);
        final listSucursal = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData['results'][i]['id_subsidiary']);

        if (listSucursal.length > 0) {
          smodel.subsidiaryFavourite = listSucursal[0].subsidiaryFavourite;
        } else {
          smodel.subsidiaryFavourite = '0';
        }

        await subsidiaryDatabase.insertarSubsidiary(smodel);
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> listarSedesPorNegocio(String id) async {
    try {
      final response = await http.post(Uri.parse("$apiBaseURL/api/Negocio/listar_sedes_por_negocio"), body: {
        'id_negocio': '$id',
      });
      //final List<SubsidiaryModel> list = [];
      final decodedData = json.decode(response.body);

      for (var i = 0; i < decodedData.length; i++) {
        //se usa cuando no esta completo
        final listsubsidiary = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData[i]['id_subsidiary']);

        if (listsubsidiary.length > 0) {
          SubsidiaryModel sucmodel = SubsidiaryModel();
          sucmodel.idSubsidiary = decodedData[i]["id_subsidiary"];
          sucmodel.idCompany = decodedData[i]["id_company"];
          sucmodel.subsidiaryName = decodedData[i]['subsidiary_name'];
          sucmodel.subsidiaryImg = decodedData[i]['subsidiary_img'];
          sucmodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
          sucmodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
          sucmodel.subsidiaryCellphone2 = decodedData[i]['subsidiary_cellphone_2'];
          sucmodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          sucmodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          sucmodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          sucmodel.subsidiaryOpeningHours = decodedData[i]['subsidiary_opening_hours'];
          sucmodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          sucmodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          sucmodel.subsidiaryImg = decodedData[i]['subsidiary_img'];

          if (listsubsidiary.length > 0) {
            sucmodel.subsidiaryFavourite = listsubsidiary[0].subsidiaryFavourite;
          } else {
            sucmodel.subsidiaryFavourite = '0';
          }

          await subsidiaryDatabase.insertarSubsidiary(sucmodel);
        }
      }

      //list.add(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  /* Future updateNegocio(CompanySubsidiaryModel csmodel) async {
    try {
      final res =
          await http.post("$apiBaseURL/api/Negocio/update_negocio", body: {
        'id_company': '${csmodel.idCompany}',
        'empresa_nombre': '${csmodel.companyName}',
        'empresa_type': '${csmodel.companyType}',
        "id_category": '${csmodel.idCategory}',
        "empresa_cel": '${csmodel.subsidiaryCellphone}',
        "empresa_ruc": '${csmodel.companyRuc}',
        "calle_x": '${csmodel.subsidiaryCoordX}',
        "calle_y": '${csmodel.subsidiaryCoordY}',
        "actual_opening_hours": '${csmodel.subsidiaryOpeningHours}',
        'empresa_cel2': '${csmodel.subsidiaryCellphone2}',
        'empresa_direccion': '${csmodel.subsidiaryAddress}',
        'shortcode': '${csmodel.companyShortcode}',
        'delivery': '${csmodel.companyDelivery}',
        "entrega": '${csmodel.companyShortcode}',
        "tarjeta": '${csmodel.companyTarjeta}',
        "app": 'true',
        "tn": prefs.token,
      });
      final code = json.decode(res.body);
      //final int code = decodesData;
      if (code == 1) {
        return 1;
      } else if (code == 2) {
        return 2;
      } else {
        return code;
      }
      // return code;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
   */
  Future<dynamic> listarSubsidiaryPorId(String id) async {
    try {
      final response = await http.post(Uri.parse("$apiBaseURL/api/Negocio/listar_sucursal_por_id"), body: {
        'id_sucursal': '$id',
      });

      final decodedData = json.decode(response.body);

      CompanyModel cmodel = CompanyModel();
      cmodel.idCompany = decodedData['id_company'];
      cmodel.idUser = decodedData['id_user'];
      cmodel.idCity = decodedData['id_city'];
      cmodel.idCategory = decodedData['id_category'];
      cmodel.companyName = decodedData['company_name'];
      cmodel.companyRuc = decodedData['company_ruc'];
      cmodel.companyImage = decodedData['company_image'];
      cmodel.companyType = decodedData['company_type'];
      cmodel.companyShortcode = decodedData['company_shortcode'];
      cmodel.companyDelivery = decodedData['company_delivery'];
      cmodel.companyEntrega = decodedData['company_entrega'];
      cmodel.companyTarjeta = decodedData['company_tarjeta'];
      cmodel.companyVerified = decodedData['company_verified'];
      cmodel.companyRating = decodedData['company_rating'];
      cmodel.companyCreatedAt = decodedData['company_created_at'];
      cmodel.companyJoin = decodedData['company_join'];
      cmodel.companyStatus = decodedData['company_status'];
      cmodel.companyMt = decodedData['company_mt'];
      cmodel.miNegocio = decodedData['mi_negocio'].toString();

      await companyDatabase.insertarCompany(cmodel);

      final listSucursal = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData['id_subsidiary']);
      SubsidiaryModel smodel = SubsidiaryModel();
      smodel.idSubsidiary = decodedData['id_subsidiary'];
      smodel.idCompany = decodedData['id_company'];
      smodel.subsidiaryName = decodedData['subsidiary_name'];
      smodel.subsidiaryCellphone = decodedData['subsidiary_cellphone'];
      smodel.subsidiaryCellphone2 = decodedData['subsidiary_cellphone_2'];
      smodel.subsidiaryEmail = decodedData['subsidiary_email'];
      smodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
      smodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
      smodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
      smodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
      smodel.subsidiaryStatus = decodedData['subsidiary_status'];
      smodel.subsidiaryAddress = decodedData['subsidiary_address'];
      smodel.subsidiaryImg = decodedData['subsidiary_img'];
      if (listSucursal.length > 0) {
        smodel.subsidiaryFavourite = listSucursal[0].subsidiaryFavourite;
      } else {
        smodel.subsidiaryFavourite = '0';
      }
      await subsidiaryDatabase.insertarSubsidiary(smodel);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}
