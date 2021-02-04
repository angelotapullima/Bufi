import 'dart:convert';
import 'dart:io';


import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/service_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ServiceApi {
  final prefs = Preferences();

  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  final serviceModel = ServiciosModel();
  final serviceDatabase = ServiceDatabase();

  Future<dynamic> obtenerServicesAll() async {
    try {
      var response =
          await http.post("$apiBaseURL/api/Negocio/listar_all_servicio");

      List decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        final listService = await serviceDatabase.obtenerService();

        if (listService.length > 0) {
          ServiciosModel servicemodel = ServiciosModel();

          servicemodel.idService = decodedData[i]['id_service'];
          servicemodel.serviceName = decodedData[i]['service_name'];
          servicemodel.serviceSynonyms = decodedData[i]['service_synonyms'];

          await serviceDatabase.obtenerService();
        } else {
          ServiciosModel servicemodel = ServiciosModel();

          servicemodel.idService = decodedData[i]['id_service'];
          servicemodel.serviceName = decodedData[i]['service_name'];
          servicemodel.serviceSynonyms = decodedData[i]['service_synonyms'];

          await serviceDatabase.obtenerService();
        }
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> listarServiciosPorSucursal(String id) async {
    final response = await http
        .post('$apiBaseURL/api/Negocio/listar_servicios_por_sucursal', body: {
      'id_sucursal': '$id',
    });

    final decodedData = json.decode(response.body);

    for (var i = 0; i < decodedData.length; i++) {
      // //   final listsubsidiary = await subisdiaryServiceDatabase
      // //       .obtenerServiciosPorIdSucursal(decodedData[i]['id_subsidiary']);

      // //   if (listsubsidiary.length > 0) {
      // //     //SubsidiaryServicesModel
      SubsidiaryServiceModel subsidiaryServiceModel = SubsidiaryServiceModel();

      subsidiaryServiceModel.idSubsidiaryservice =
          decodedData[i]['id_subsidiaryservice'];
      subsidiaryServiceModel.idSubsidiary = decodedData[i]['id_subsidiary'];
      subsidiaryServiceModel.idService = decodedData[i]['id_service'];
      subsidiaryServiceModel.idItemsubcategory =
          decodedData[i]['id_itemsubcategory'];
      subsidiaryServiceModel.subsidiaryServiceName =
          decodedData[i]['subsidiary_service_name'];
      subsidiaryServiceModel.subsidiaryServiceDescription =
          decodedData[i]['subsidiary_service_description'];
      subsidiaryServiceModel.subsidiaryServicePrice =
          decodedData[i]['subsidiary_service_price'];
      subsidiaryServiceModel.subsidiaryServiceCurrency =
          decodedData[i]['subsidiary_service_currency'];
      subsidiaryServiceModel.subsidiaryServiceImage =
          decodedData[i]['subsidiary_service_image'];
      subsidiaryServiceModel.subsidiaryServiceRating =
          decodedData[i]['subsidiary_service_rating'].toString();
      subsidiaryServiceModel.subsidiaryServiceUpdated =
          decodedData[i]['subsidiary_service_updated'];
      subsidiaryServiceModel.subsidiaryServiceStatus =
          decodedData[i]['subsidiary_service_status'];
      await subisdiaryServiceDatabase
          .insertarSubsidiaryService(subsidiaryServiceModel);

      //SubsidiaryModel
      SubsidiaryModel subsidiaryModel = SubsidiaryModel();
      final subisdiaryDatabase = SubsidiaryDatabase();

      subsidiaryModel.idSubsidiary = decodedData[i]['id_subsidiary'];
      subsidiaryModel.idCompany = decodedData[i]['id_company'];
      subsidiaryModel.subsidiaryName = decodedData[i]['subsidiary_name'];
      subsidiaryModel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
      subsidiaryModel.subsidiaryCellphone =
          decodedData[i]['subsidiary_cellphone'];
      subsidiaryModel.subsidiaryCellphone2 =
          decodedData[i]['subsidiary_cellphone_2'];
      subsidiaryModel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
      subsidiaryModel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
      subsidiaryModel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
      subsidiaryModel.subsidiaryOpeningHours =
          decodedData[i]['subsidiary_opening_hours'];
      subsidiaryModel.subsidiaryPrincipal =
          decodedData[i]['subsidiary_principal'];
      subsidiaryModel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
      subsidiaryModel.subsidiaryFavourite = '0';

      await subisdiaryDatabase.insertarSubsidiary(subsidiaryModel);

      //ServicesModel

      serviceModel.idService = decodedData[i]['id_service'];
      serviceModel.serviceName = decodedData[i]['service_name'];
      serviceModel.serviceSynonyms = decodedData[i]['service_synonyms'];

      await serviceDatabase.insertarService(serviceModel);

      //ItemSubCategoriaModel

      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      final itemsubCategoryDatabase = ItemsubCategoryDatabase();

      itemSubCategoriaModel.idItemsubcategory =
          decodedData[i]['id_itemsubcategory'];
      itemSubCategoriaModel.idSubcategory = decodedData[i]['id_subcategory'];
      itemSubCategoriaModel.itemsubcategoryName =
          decodedData[i]['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);
      //}
    }
    return 0;
  }

  Future<int> guardarServicio(
      String idUser,
      String idSucursal2,
      String idServicio,
      String categoria,
      String nombreServicio,
      String precio,
      String currency,
      String descripcion,
      File imagen) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Negocio/guardar_servicio');
      final mimeType = mime(imagen.path).split('/'); //image/jpeg

      final imageUploadRequest = http.MultipartRequest('POST', url)
        ..fields['id_user'] = prefs.idUser
        ..fields['id_sucursal2'] = idSucursal2
        ..fields['id_servicio'] = idServicio
        ..fields['categoria_s'] = categoria
        ..fields['nombre_s'] = nombreServicio
        ..fields['precio_s'] = precio
        ..fields['currency_s'] = currency
        ..fields['descripcion'] = descripcion;

      final file = await http.MultipartFile.fromPath(
          'servicio_img', imagen.path,
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

  Future<dynamic> detalleSerivicioPorIdSubsidiaryService(String id) async {
    try {
      final response = await http
          .post('$apiBaseURL/api/Negocio/listar_detalle_servicio', body: {
        'id': '$id',
      });

      final decodedData = json.decode(response.body);
      print(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> deshabilitarSubsidiaryService(String id) async {
    try {
      final response = await http
          .post('$apiBaseURL/api/Negocio/deshabilitar_servicio', body: {
        'id_subsidiaryservice': '$id',
      });

      final decodedData = json.decode(response.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> listarServiciosAllPorCiudad() async {
    final response = await http.post(
        "$apiBaseURL/api/Login/listar_servicios_por_id_ciudad",
        body: {'id_ciudad': '1'});

    final decodedData = json.decode(response.body);

    for (int i = 0; i < decodedData["servicios"].length; i++) {
      //ingresamos subcategorias
      SubcategoryModel subcategoryModel = SubcategoryModel();
      final subcategoryDatabase = SubcategoryDatabase();

      subcategoryModel.idSubcategory =
          decodedData['servicios'][i]['id_subcategory'];
      subcategoryModel.subcategoryName =
          decodedData['servicios'][i]['subcategory_name'];
      subcategoryModel.idCategory = decodedData['servicios'][i]['id_category'];
      await subcategoryDatabase.insertarSubCategory(subcategoryModel);

      //ingresamos ItemSubCategorias
      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      final itemsubCategoryDatabase = ItemsubCategoryDatabase();
      itemSubCategoriaModel.idItemsubcategory =
          decodedData['servicios'][i]['id_itemsubcategory'];
      itemSubCategoriaModel.idSubcategory =
          decodedData['servicios'][i]['id_subcategory'];
      itemSubCategoriaModel.itemsubcategoryName =
          decodedData['servicios'][i]['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);

      //completo
      CompanyModel companyModel = CompanyModel();
      final companyDatabase = CompanyDatabase();
      companyModel.idCompany = decodedData['servicios'][i]['id_company'];
      companyModel.idUser = decodedData['servicios'][i]['id_user'];
      companyModel.idCity = decodedData['servicios'][i]['id_city'];
      companyModel.idCategory = decodedData['servicios'][i]['id_category'];
      companyModel.companyName = decodedData['servicios'][i]['company_name'];
      companyModel.companyRuc = decodedData['servicios'][i]['company_ruc'];
      companyModel.companyImage = decodedData['servicios'][i]['company_image'];
      companyModel.companyType = decodedData['servicios'][i]['company_type'];
      companyModel.companyShortcode =
          decodedData['servicios'][i]['company_shortcode'];
      companyModel.companyDelivery =
          decodedData['servicios'][i]['company_delivery'];
      companyModel.companyEntrega =
          decodedData['servicios'][i]['company_entrega'];
      companyModel.companyTarjeta =
          decodedData['servicios'][i]['company_tarjeta'];
      companyModel.companyVerified =
          decodedData['servicios'][i]['company_verified'];
      companyModel.companyRating =
          decodedData['servicios'][i]['company_rating'];
      companyModel.companyCreatedAt =
          decodedData['servicios'][i]['company_created_at'];
      companyModel.companyJoin = decodedData['servicios'][i]['company_join'];
      companyModel.companyStatus =
          decodedData['servicios'][i]['company_status'];
      companyModel.companyMt = decodedData['servicios'][i]['company_mt'];
      await companyDatabase.insertarCompany(companyModel);

      SubsidiaryServiceModel subsidiaryServiceModel = SubsidiaryServiceModel();
      subsidiaryServiceModel.idSubsidiaryservice =
          decodedData['servicios'][i]['id_subsidiaryservice'];
      subsidiaryServiceModel.idSubsidiary =
          decodedData['servicios'][i]['id_subsidiary'];
      subsidiaryServiceModel.idService =
          decodedData['servicios'][i]['id_service'];
      subsidiaryServiceModel.idItemsubcategory =
          decodedData['servicios'][i]['id_itemsubcategory'];
      subsidiaryServiceModel.subsidiaryServiceName =
          decodedData['servicios'][i]['subsidiary_service_name'];
      subsidiaryServiceModel.subsidiaryServiceDescription =
          decodedData['servicios'][i]['subsidiary_service_description'];
      subsidiaryServiceModel.subsidiaryServicePrice =
          decodedData['servicios'][i]['subsidiary_service_price'];
      subsidiaryServiceModel.subsidiaryServiceCurrency =
          decodedData['servicios'][i]['subsidiary_service_currency'];
      subsidiaryServiceModel.subsidiaryServiceImage =
          decodedData['servicios'][i]['subsidiary_service_image'];
      subsidiaryServiceModel.subsidiaryServiceRating =
          decodedData['servicios'][i]['subsidiary_service_rating'];
      subsidiaryServiceModel.subsidiaryServiceUpdated =
          decodedData['servicios'][i]['subsidiary_service_updated'];
      subsidiaryServiceModel.subsidiaryServiceStatus =
          decodedData['servicios'][i]['subsidiary_service_status'];
      await subisdiaryServiceDatabase
          .insertarSubsidiaryService(subsidiaryServiceModel);

      final subsidiaryDatabase = SubsidiaryDatabase();
      final listservices = await subsidiaryDatabase
          .obtenerSubsidiaryPorId(decodedData["servicios"][i]["id_subsidiary"]);

      if (listservices.length > 0) {
        //completo
        SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['servicios'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = decodedData['servicios'][i]['id_company'];
        subsidiaryModel.subsidiaryName =
            decodedData['servicios'][i]['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress =
            decodedData['servicios'][i]['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            decodedData['servicios'][i]['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            decodedData['servicios'][i]['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail =
            decodedData['servicios'][i]['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX =
            decodedData['servicios'][i]['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY =
            decodedData['servicios'][i]['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            decodedData['servicios'][i]['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            decodedData['servicios'][i]['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus =
            decodedData['servicios'][i]['subsidiary_status'];
        subsidiaryModel.subsidiaryFavourite =
            listservices[0].subsidiaryFavourite;

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
      } else {
        SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['servicios'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = decodedData['servicios'][i]['id_company'];
        subsidiaryModel.subsidiaryName =
            decodedData['servicios'][i]['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress =
            decodedData['servicios'][i]['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            decodedData['servicios'][i]['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            decodedData['servicios'][i]['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail =
            decodedData['servicios'][i]['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX =
            decodedData['servicios'][i]['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY =
            decodedData['servicios'][i]['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            decodedData['servicios'][i]['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            decodedData['servicios'][i]['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus =
            decodedData['servicios'][i]['subsidiary_status'];
        subsidiaryModel.subsidiaryFavourite = '0';

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
      }
    }

    return 0;
  }

  Future<int> listarServiciosPorIdItemSubcategoria(String id) async {
    final response = await http.post(
        "$apiBaseURL/api/Login/listar_servicios_por_id_itemsubcategoria",
        body: {'id_ciudad': '1', 'id_itemsubcategoria': '$id'});

    final decodedData = json.decode(response.body);

    for (int i = 0; i < decodedData["servicios"].length; i++) {
      //ingresamos service
      ServiciosModel servicemodel = ServiciosModel();
      servicemodel.idService = decodedData["servicios"][i]['id_service'];
      servicemodel.serviceName = decodedData["servicios"][i]['service_name'];
      servicemodel.serviceSynonyms =
          decodedData["servicios"][i]['service_synonyms'];

      await serviceDatabase.insertarService(servicemodel);

      //ingresamos subcategorias
      SubcategoryModel subcategoryModel = SubcategoryModel();
      final subcategoryDatabase = SubcategoryDatabase();

      subcategoryModel.idSubcategory =
          decodedData['servicios'][i]['id_subcategory'];
      subcategoryModel.subcategoryName =
          decodedData['servicios'][i]['subcategory_name'];
      subcategoryModel.idCategory = decodedData['servicios'][i]['id_category'];
      await subcategoryDatabase.insertarSubCategory(subcategoryModel);

      //ingresamos ItemSubCategorias
      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      final itemsubCategoryDatabase = ItemsubCategoryDatabase();
      itemSubCategoriaModel.idItemsubcategory =
          decodedData['servicios'][i]['id_itemsubcategory'];
      itemSubCategoriaModel.idSubcategory =
          decodedData['servicios'][i]['id_subcategory'];
      itemSubCategoriaModel.itemsubcategoryName =
          decodedData['servicios'][i]['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);

      //completo
      CompanyModel companyModel = CompanyModel();
      final companyDatabase = CompanyDatabase();
      companyModel.idCompany = decodedData['servicios'][i]['id_company'];
      companyModel.idUser = decodedData['servicios'][i]['id_user'];
      companyModel.idCity = decodedData['servicios'][i]['id_city'];
      companyModel.idCategory = decodedData['servicios'][i]['id_category'];
      companyModel.companyName = decodedData['servicios'][i]['company_name'];
      companyModel.companyRuc = decodedData['servicios'][i]['company_ruc'];
      companyModel.companyImage = decodedData['servicios'][i]['company_image'];
      companyModel.companyType = decodedData['servicios'][i]['company_type'];
      companyModel.companyShortcode =
          decodedData['servicios'][i]['company_shortcode'];
      companyModel.companyDelivery =
          decodedData['servicios'][i]['company_delivery'];
      companyModel.companyEntrega =
          decodedData['servicios'][i]['company_entrega'];
      companyModel.companyTarjeta =
          decodedData['servicios'][i]['company_tarjeta'];
      companyModel.companyVerified =
          decodedData['servicios'][i]['company_verified'];
      companyModel.companyRating =
          decodedData['servicios'][i]['company_rating'];
      companyModel.companyCreatedAt =
          decodedData['servicios'][i]['company_created_at'];
      companyModel.companyJoin = decodedData['servicios'][i]['company_join'];
      companyModel.companyStatus =
          decodedData['servicios'][i]['company_status'];
      companyModel.companyMt = decodedData['servicios'][i]['company_mt'];
      await companyDatabase.insertarCompany(companyModel);

      SubsidiaryServiceModel subsidiaryServiceModel = SubsidiaryServiceModel();
      subsidiaryServiceModel.idSubsidiaryservice =
          decodedData['servicios'][i]['id_subsidiaryservice'];
      subsidiaryServiceModel.idSubsidiary =
          decodedData['servicios'][i]['id_subsidiary'];
      subsidiaryServiceModel.idService =
          decodedData['servicios'][i]['id_service'];
      subsidiaryServiceModel.idItemsubcategory =
          decodedData['servicios'][i]['id_itemsubcategory'];
      subsidiaryServiceModel.subsidiaryServiceName =
          decodedData['servicios'][i]['subsidiary_service_name'];
      subsidiaryServiceModel.subsidiaryServiceDescription =
          decodedData['servicios'][i]['subsidiary_service_description'];
      subsidiaryServiceModel.subsidiaryServicePrice =
          decodedData['servicios'][i]['subsidiary_service_price'];
      subsidiaryServiceModel.subsidiaryServiceCurrency =
          decodedData['servicios'][i]['subsidiary_service_currency'];
      subsidiaryServiceModel.subsidiaryServiceImage =
          decodedData['servicios'][i]['subsidiary_service_image'];
      subsidiaryServiceModel.subsidiaryServiceRating =
          decodedData['servicios'][i]['subsidiary_service_rating'];
      subsidiaryServiceModel.subsidiaryServiceUpdated =
          decodedData['servicios'][i]['subsidiary_service_updated'];
      subsidiaryServiceModel.subsidiaryServiceStatus =
          decodedData['servicios'][i]['subsidiary_service_status'];
      await subisdiaryServiceDatabase
          .insertarSubsidiaryService(subsidiaryServiceModel);

      final subsidiaryDatabase = SubsidiaryDatabase();
      final listservices = await subsidiaryDatabase
          .obtenerSubsidiaryPorId(decodedData["servicios"][i]["id_subsidiary"]);

      if (listservices.length > 0) {
        //completo
        SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['servicios'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = decodedData['servicios'][i]['id_company'];
        subsidiaryModel.subsidiaryName =
            decodedData['servicios'][i]['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress =
            decodedData['servicios'][i]['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            decodedData['servicios'][i]['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            decodedData['servicios'][i]['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail =
            decodedData['servicios'][i]['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX =
            decodedData['servicios'][i]['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY =
            decodedData['servicios'][i]['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            decodedData['servicios'][i]['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            decodedData['servicios'][i]['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus =
            decodedData['servicios'][i]['subsidiary_status'];
        subsidiaryModel.subsidiaryFavourite =
            listservices[0].subsidiaryFavourite;

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
      } else {
        SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['servicios'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = decodedData['servicios'][i]['id_company'];
        subsidiaryModel.subsidiaryName =
            decodedData['servicios'][i]['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress =
            decodedData['servicios'][i]['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            decodedData['servicios'][i]['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            decodedData['servicios'][i]['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail =
            decodedData['servicios'][i]['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX =
            decodedData['servicios'][i]['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY =
            decodedData['servicios'][i]['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            decodedData['servicios'][i]['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            decodedData['servicios'][i]['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus =
            decodedData['servicios'][i]['subsidiary_status'];
        subsidiaryModel.subsidiaryFavourite = '0';

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
      }
    }
    return 0;
  }
}
