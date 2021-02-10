import 'dart:io';



import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:mime_type/mime_type.dart';

class NegociosApi {
  //Instancia de la BD de Company
  final companyDatabase = CompanyDatabase();
  final prefs = Preferences();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future<dynamic> obtenerCompany() async {
    try {
      var response = await http.post(
          "$apiBaseURL/api/Negocio/listar_negocios_resumen",
          body: {'id_ciudad': '1'});

      final decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        final listCompany = await companyDatabase
            .obtenerCompanySubsidiaryPorId(decodedData[i]['id_company']);

        if (listCompany.length > 0) {
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
          smodel.subsidiaryCellphone =
              decodedData[i]['id_subsidiary_cellphone_2'];
          smodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          smodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          smodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          smodel.subsidiaryOpeningHours =
              decodedData[i]['subsidiary_opening_hours'];
          smodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          smodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          smodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
          smodel.subsidiaryFavourite = listCompany[0].subsidiaryFavourite;

          await subsidiaryDatabase.insertarSubsidiary(smodel);
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
          smodel.subsidiaryCellphone =
              decodedData[i]['id_subsidiary_cellphone_2'];
          smodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          smodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          smodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          smodel.subsidiaryOpeningHours =
              decodedData[i]['subsidiary_opening_hours'];
          smodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          smodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          smodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
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
      var response = await http.post(
          "$apiBaseURL/api/Negocio/listar_negocio_por_id",
          body: {'id_user': prefs.idUser, 'id_company': id});

      final decodedData = json.decode(response.body);

      final listCompany =
          await companyDatabase.obtenerCompanySubsidiaryPorId(id);

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
        smodel.subsidiaryCellphone = decodedData['id_subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData['subsidiary_address'];
        smodel.subsidiaryFavourite = listCompany[0].subsidiaryFavourite;

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
        smodel.subsidiaryCellphone = decodedData['id_subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData['subsidiary_address'];
        smodel.subsidiaryFavourite = '0';
        await subsidiaryDatabase.insertarSubsidiary(smodel);
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future registrarNegocio(CompanyModel cmodel) async {
    try {
      final res =
          await http.post("$apiBaseURL/api/Negocio/guardar_negocio", body: {
        'empresa_nombre': '${cmodel.companyName}',
        'empresa_type': '${cmodel.companyType}',
        'id_category': '${cmodel.idCategory}',
        'empresa_cel': '${cmodel.cell}',
        'empresa_direccion': '${cmodel.direccion}',
        'shortcode': '${cmodel.companyShortcode}',
        'delivery': '${cmodel.companyDelivery}',
        'entrega': '${cmodel.companyEntrega}',
        'tarjeta': '${cmodel.companyTarjeta}',
        'token': prefs.token,
        'id_user': prefs.idUser,
        'app': 'true'
      });

      final decodesData = json.decode(res.body);

      final int code = decodesData['result']['code'];

      return code;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> listarCompany() async {
    try {
      var response = await http.post("$apiBaseURL/api/Negocio/listar_negocios",
          body: {'id_ciudad': '1', 'id_user': '1'});

      final decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        final listCompany = await companyDatabase
            .obtenerCompanySubsidiaryPorId(decodedData[i]['id_company']);

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

        SubsidiaryModel smodel = SubsidiaryModel();
        smodel.idCompany = decodedData[i]['id_company'];
        smodel.idSubsidiary = decodedData[i]['id_subsidiary'];
        smodel.subsidiaryName = decodedData[i]['subsidiary_name'];
        smodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
        smodel.subsidiaryCellphone =
            decodedData[i]['id_subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours =
            decodedData[i]['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
        smodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
        await subsidiaryDatabase.insertarSubsidiary(smodel);
        if (listCompany.length > 0) {
          smodel.subsidiaryFavourite = listCompany[0].subsidiaryFavourite;
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

  Future registrarSedes(SubsidiaryModel smodel) async {
    try {
      final res =
          await http.post("$apiBaseURL/api/Negocio/guardar_sede", body: {
        'id': '${smodel.idCompany}',
        'empresa_nombre': '${smodel.subsidiaryName}',
        'empresa_cel': '${smodel.subsidiaryCellphone}',
        'empresa_cel2': '${smodel.subsidiaryCellphone2}',
        'empresa_direccion': '${smodel.subsidiaryAddress}',
        'empresa_email': '${smodel.subsidiaryEmail}',
        'app': 'true',
      });

      final decodedData = json.decode(res.body);

      final int code = decodedData['result']['code'];

      /*  if (code == 1) {
        return 1;
      } else if (code == 2) {
        return 2;
      } else {
        return code;
      } */

      return code;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> listarSedesPorNegocio(String id) async {
    try {
      final response = await http
          .post("$apiBaseURL/api/Negocio/listar_sedes_por_negocio", body: {
        'id_negocio': '$id',
      });
      //final List<SubsidiaryModel> list = [];
      final decodedData = json.decode(response.body);

      for (var i = 0; i < decodedData.length; i++) {
        //se usa cuando no esta completo
        final listsubsidiary = await subsidiaryDatabase
            .obtenerSubsidiaryPorId(decodedData[i]['id_subsidiary']);

        if (listsubsidiary.length > 0) {
          SubsidiaryModel sucmodel = SubsidiaryModel();
          sucmodel.idSubsidiary = decodedData[i]["id_subsidiary"];
          sucmodel.idCompany = decodedData[i]["id_company"];
          sucmodel.subsidiaryName = decodedData[i]['subsidiary_name'];
          sucmodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
          sucmodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
          sucmodel.subsidiaryCellphone2 =
              decodedData[i]['subsidiary_cellphone_2'];
          sucmodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          sucmodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          sucmodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          sucmodel.subsidiaryOpeningHours =
              decodedData[i]['subsidiary_opening_hours'];
          sucmodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          sucmodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          sucmodel.subsidiaryFavourite = listsubsidiary[0].subsidiaryFavourite;
          await subsidiaryDatabase.insertarSubsidiary(sucmodel);
        } else {
          SubsidiaryModel sucmodel = SubsidiaryModel();
          sucmodel.idSubsidiary = decodedData[i]["id_subsidiary"];
          sucmodel.idCompany = decodedData[i]["id_company"];
          sucmodel.subsidiaryName = decodedData[i]['subsidiary_name'];
          sucmodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
          sucmodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
          sucmodel.subsidiaryCellphone2 =
              decodedData[i]['subsidiary_cellphone_2'];
          sucmodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
          sucmodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
          sucmodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
          sucmodel.subsidiaryOpeningHours =
              decodedData[i]['subsidiary_opening_hours'];
          sucmodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
          sucmodel.subsidiaryFavourite = '0';
          sucmodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
          await subsidiaryDatabase.insertarSubsidiary(sucmodel);
        }
      }

      //list.add(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> guardarProducto(
      String idSucursal,
      String idGood,
      String categoria,
      String nombreProducto,
      String precio,
      String moneda,
      String medida,
      String marca,
      String modelo,
      String size,
      String stock,
      File imagen) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Negocio/guardar_producto');
      final mimeType = mime(imagen.path).split('/'); //image/jpeg

      final imageUploadRequest = http.MultipartRequest('POST', url)
        ..fields['id_user'] = prefs.idUser
        ..fields['id_sucursal'] = idSucursal
        ..fields['id_good'] = idGood
        ..fields['categoria'] = categoria
        ..fields['nombre'] = nombreProducto
        ..fields['precio'] = precio
        ..fields['currency'] = moneda
        ..fields['measure'] = medida
        ..fields['marca'] = marca
        ..fields['modelo'] = modelo
        ..fields['size'] = size
        ..fields['stock'] = stock;

      final file = await http.MultipartFile.fromPath(
          'producto_img', imagen.path,
          contentType: MediaType(mimeType[0], mimeType[1]));

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      print(streamResponse);
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
      }

      final code = json.decode(resp.body)["result"]["code"];

      if (code == 1) {
        return 1;
      } else if (code == 2) {
        return 2;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future updateNegocio(CompanySubsidiaryModel csmodel) async {
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

  Future<dynamic> listarSubsidiaryPorId(String id) async {
    try {
      final response = await http
          .post("$apiBaseURL/api/Negocio/listar_sucursal_por_id", body: {
        'id_sucural': '$id',
      });

      final decodedData = json.decode(response.body);
      print(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}
