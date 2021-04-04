import 'dart:convert';

import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/service_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriasApi {
  final categoryDatabase = CategoryDatabase();
  final subcategoryDatabase = SubcategoryDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final companyDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  final goodDatabase = GoodDatabase();
  final serviceDatabase = ServiceDatabase();

  Future<int> obtenerCategorias(BuildContext context) async {
    //List<CategoriaModel> categoriaList = [];
    try {
      var response =
          await http.post("$apiBaseURL/api/Inicio/listar_categorias", body: {});
      var res = jsonDecode(response.body);

      var cantidadTotal = res.length;

      final preferences = Preferences();

      for (var i = 0; i < res.length; i++) {
        var porcentaje = ((i + 1) * 100) / cantidadTotal;

        //print('porcentaje $porcentaje');

        if (preferences.cargaCategorias == null ||
            preferences.cargaCategorias == '0') {
          utils.porcentaje(context, porcentaje);
        }

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
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel,'Inicio/listar_categorias');
      }
      return 0;
      //return categoriaList;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
      //return categoriaList;
    }
  }

  //Servicio retorna el resumen(8 elementos)de bienes y servicios
  Future<int> obtenerbsResumen() async {
    try {
      var response = await http.post(
          "$apiBaseURL/api/Inicio/listar_bs_por_id_ciudad_resume",
          body: {'id_ciudad': '1'});

      final decodedData = json.decode(response.body);

      //recorremos el jsonArray 'Bienes'
      for (int i = 0; i < decodedData['bienes'].length; i++) {
        var bienesList = decodedData['bienes'][i];
        //primero ingresamos categoria

        var categoryList = await categoryDatabase
            .obtenerCategoriasporID(bienesList['id_category']);

        CategoriaModel categoriaModel = CategoriaModel();
        categoriaModel.idCategory = bienesList['id_category'];
        if (categoryList.length > 0) {
          categoriaModel.categoryName = categoryList[0].categoryName;
        } else {
          categoriaModel.categoryName = '';
        }

        await categoryDatabase.insertarCategory(categoriaModel);

        //ingresamos subcategorias
        SubcategoryModel subcategoryModel = SubcategoryModel();
        subcategoryModel.idSubcategory = bienesList['id_subcategory'];
        subcategoryModel.subcategoryName = bienesList['subcategory_name'];
        subcategoryModel.idCategory = bienesList['id_category'];
        await subcategoryDatabase.insertarSubCategory(subcategoryModel);

        //ingresamos ItemSubCategorias
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
        itemSubCategoriaModel.idItemsubcategory =
            bienesList['id_itemsubcategory'];
        itemSubCategoriaModel.idSubcategory = bienesList['id_subcategory'];
        itemSubCategoriaModel.itemsubcategoryName = bienesList['itemsubcategory_name'];
        itemSubCategoriaModel.itemsubcategoryImage = bienesList['itemsubcategory_img'];
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel,'Inicio/listar_bs_por_id_ciudad_resume');

        //completo
        CompanyModel companyModel = CompanyModel();
        companyModel.idCompany = bienesList['id_company'];
        companyModel.idUser = bienesList['id_user'];
        companyModel.idCity = bienesList['id_city'];
        companyModel.idCategory = bienesList['id_category'];
        companyModel.companyName = bienesList['company_name'];
        companyModel.companyRuc = bienesList['company_ruc'];
        companyModel.companyImage = bienesList['company_image'];
        companyModel.companyType = bienesList['company_type'];
        companyModel.companyShortcode = bienesList['company_shortcode'];
        companyModel.companyDelivery = bienesList['company_delivery'];
        companyModel.companyEntrega = bienesList['company_entrega'];
        companyModel.companyTarjeta = bienesList['company_tarjeta'];
        companyModel.companyVerified = bienesList['company_verified'];
        companyModel.companyRating = bienesList['company_rating'];
        companyModel.companyCreatedAt = bienesList['company_created_at'];
        companyModel.companyJoin = bienesList['company_join'];
        companyModel.companyStatus = bienesList['company_status'];
        companyModel.companyMt = bienesList['company_mt'];
        //companyModel.miNegocio= decodedData[]
        await companyDatabase.insertarCompany(companyModel);

        //completo
        final list = await subsidiaryDatabase
            .obtenerSubsidiaryPorId(bienesList["id_subsidiary"]);

        SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['bienes'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = bienesList['id_company'];
        subsidiaryModel.subsidiaryName = bienesList['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress = bienesList['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            bienesList['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            bienesList['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail = bienesList['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX = bienesList['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY = bienesList['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            bienesList['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            bienesList['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus = bienesList['subsidiary_status'];
        if (list.length > 0) {
          subsidiaryModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
        } else {
          subsidiaryModel.subsidiaryFavourite = "0";
        }

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

        ProductoModel subsidiaryGoodModel = ProductoModel();
        subsidiaryGoodModel.idProducto = bienesList['id_subsidiarygood'];
        subsidiaryGoodModel.idSubsidiary = bienesList['id_subsidiary'];
        subsidiaryGoodModel.idGood = bienesList['id_good'];
        subsidiaryGoodModel.idItemsubcategory =
            bienesList['id_itemsubcategory'];
        subsidiaryGoodModel.productoName = bienesList['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice = bienesList['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency =
            bienesList['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage = bienesList['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics =
            bienesList['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand = bienesList['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel = bienesList['subsidiary_good_model'];
        subsidiaryGoodModel.productoType = bienesList['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize = bienesList['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock = bienesList['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure =
            bienesList['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating =
            bienesList['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated =
            bienesList['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus =
            bienesList['subsidiary_good_status'];

        var productList =
            await productoDatabase.obtenerProductoPorIdSubsidiaryGood(
                bienesList['id_subsidiarygood']);

        if (productList.length > 0) {
          subsidiaryGoodModel.productoFavourite =
              productList[0].productoFavourite;
        } else {
          subsidiaryGoodModel.productoFavourite = '0';
        }
        await productoDatabase.insertarProducto(subsidiaryGoodModel);
      }

      for (int i = 0; i < decodedData['servicios'].length; i++) {
        //primero ingresamos categoria

        var categoryList = await categoryDatabase
            .obtenerCategoriasporID(decodedData['servicios'][i]['id_category']);

        CategoriaModel categoriaModel = CategoriaModel();
        categoriaModel.idCategory = decodedData['servicios'][i]['id_category'];
        if (categoryList.length > 0) {
          categoriaModel.categoryName = categoryList[0].categoryName;
        } else {
          categoriaModel.categoryName = '';
        }

        await categoryDatabase.insertarCategory(categoriaModel);

        //ingresamos subcategorias
        SubcategoryModel subcategoryModel = SubcategoryModel();
        subcategoryModel.idSubcategory =
            decodedData['servicios'][i]['id_subcategory'];
        subcategoryModel.subcategoryName =
            decodedData['servicios'][i]['subcategory_name'];
        subcategoryModel.idCategory =
            decodedData['servicios'][i]['id_category'];
        await subcategoryDatabase.insertarSubCategory(subcategoryModel);

        //ingresamos ItemSubCategorias
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
        itemSubCategoriaModel.idItemsubcategory =
            decodedData['servicios'][i]['id_itemsubcategory'];
        itemSubCategoriaModel.idSubcategory =
            decodedData['servicios'][i]['id_subcategory'];
        itemSubCategoriaModel.itemsubcategoryName = decodedData['servicios'][i]['itemsubcategory_name'];
        itemSubCategoriaModel.itemsubcategoryImage = decodedData['servicios'][i]['itemsubcategory_img'];
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel,'Inicio/listar_bs_por_id_ciudad_resume');

        //completo
        CompanyModel companyModel = CompanyModel();
        companyModel.idCompany = decodedData['servicios'][i]['id_company'];
        companyModel.idUser = decodedData['servicios'][i]['id_user'];
        companyModel.idCity = decodedData['servicios'][i]['id_city'];
        companyModel.idCategory = decodedData['servicios'][i]['id_category'];
        companyModel.companyName = decodedData['servicios'][i]['company_name'];
        companyModel.companyRuc = decodedData['servicios'][i]['company_ruc'];
        companyModel.companyImage =
            decodedData['servicios'][i]['company_image'];
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

        final listservices = await subsidiaryDatabase.obtenerSubsidiaryPorId(
            decodedData["servicios"][i]["id_subsidiary"]);

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

        if (listservices.length > 0) {
          //completo

          subsidiaryModel.subsidiaryFavourite =
              listservices[0].subsidiaryFavourite;
        } else {
          subsidiaryModel.subsidiaryFavourite = '0';
        }

        await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

        SubsidiaryServiceModel subsidiaryServiceModel =
            SubsidiaryServiceModel();
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
      }

      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> obtenerProySerPorIdItemsubcategory(String idItemsub) async {
    try {
      final listSubgood =
          await productoDatabase.obtenerProductoXIdItemSubcategoria(idItemsub);

      double mayorPro = 0; 
      double mayor2Pro = 0;
      double menorPro = 0;
      if (listSubgood.length > 0) {
        for (var i = 0; i < listSubgood.length; i++) {
          if (double.parse(listSubgood[i].idProducto) > mayorPro) {
            mayorPro = double.parse(listSubgood[i].idProducto);
            print('mayor $mayorPro');
          }
        }
      }
      mayor2Pro = mayorPro;

      if (listSubgood.length > 0) {
        for (var x = 0; x < listSubgood.length; x++) {
          if (double.parse(listSubgood[x].idProducto) < mayor2Pro) {
            menorPro = double.parse(listSubgood[x].idProducto);
            mayor2Pro = menorPro;
            print('menor $menorPro');
          } else {
            menorPro = mayor2Pro;
          }
        }
      }

      final listSubservice = await subisdiaryServiceDatabase
          .obtenerServicioXIdItemSubcategoria(idItemsub);
      double mayorSer = 0;
      double mayor2Ser = 0;
      double menorSer = 0;
      if (listSubservice.length > 0) {
        for (var i = 0; i < listSubservice.length; i++) {
          if (double.parse(listSubservice[i].idSubsidiaryservice) > mayorSer) {
            mayorSer = double.parse(listSubservice[i].idSubsidiaryservice);
            print('mayor $mayorSer');
          }
        }
      }
      mayor2Ser = mayorSer;

      if (listSubservice.length > 0) {
        for (var x = 0; x < listSubservice.length; x++) {
          if (double.parse(listSubservice[x].idSubsidiaryservice) < mayor2Ser) {
            menorSer = double.parse(listSubservice[x].idSubsidiaryservice);
            mayor2Ser = menorSer;
            print('menor $menorSer');
          } else {
            menorSer = mayor2Ser;
          }
        }
      }

      var response = await http
          .post("$apiBaseURL/api/Inicio/listar_bs_por_id_itemsubcat", body: {
        'id_ciudad': '1',
        'id_itemsubcategoria': idItemsub,
        'limite_sup_bienes': mayorPro.toString(),
        'limite_inf_bienes': menorPro.toString(),
        'limite_sup_servicios': mayorSer.toString(),
        'limite_inf_servicios': menorSer.toString()
      });
      var res = jsonDecode(response.body);

      var bienesList = res['productos'];

      if (bienesList.length > 0) {
        for (var i = 0; i < bienesList.length; i++) {
          CategoriaModel categ = CategoriaModel();
          categ.idCategory = bienesList[i]["id_category"];
          var categoryList = await categoryDatabase
              .obtenerCategoriasporID(bienesList[i]["id_category"]);
          if (categoryList.length > 0) {
            categ.categoryName = categoryList[0].categoryName;
          } else {
            categ.categoryName = '';
          }
          await categoryDatabase.insertarCategory(categ);

          SubcategoryModel subcategoryModel = SubcategoryModel();
          subcategoryModel.idCategory = bienesList[i]["id_category"];
          subcategoryModel.idSubcategory = bienesList[i]["id_subcategory"];
          subcategoryModel.subcategoryName = bienesList[i]["subcategory_name"];

          await subcategoryDatabase.insertarSubCategory(subcategoryModel);

          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idItemsubcategory =
              bienesList[i]['id_itemsubcategory'];
          itemSubCategoriaModel.idSubcategory = bienesList[i]['id_subcategory'];
          itemSubCategoriaModel.itemsubcategoryName = bienesList[i]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = bienesList[i]['itemsubcategory_img'];
          await itemsubCategoryDatabase
              .insertarItemSubCategoria(itemSubCategoriaModel,'Inicio/listar_bs_por_id_itemsubcat');

          BienesModel goodmodel = BienesModel();
          goodmodel.idGood = bienesList[i]['id_good'];
          goodmodel.goodName = bienesList[i]['good_name'];
          goodmodel.goodSynonyms = bienesList[i]['good_synonyms'];
          await goodDatabase.insertarGood(goodmodel);

          ProductoModel productoModel = ProductoModel();
          productoModel.idProducto = bienesList[i]['id_subsidiarygood'];
          productoModel.idSubsidiary = bienesList[i]['id_subsidiary'];
          productoModel.idGood = bienesList[i]['id_good'];
          productoModel.idItemsubcategory = bienesList[i]['id_itemsubcategory'];
          productoModel.productoName = bienesList[i]['subsidiary_good_name'];
          productoModel.productoPrice = bienesList[i]['subsidiary_good_price'];
          productoModel.productoCurrency =
              bienesList[i]['subsidiary_good_currency'];
          productoModel.productoImage = bienesList[i]['subsidiary_good_image'];
          productoModel.productoCharacteristics =
              bienesList[i]['subsidiary_good_characteristics'];
          productoModel.productoBrand = bienesList[i]['subsidiary_good_brand'];
          productoModel.productoModel = bienesList[i]['subsidiary_good_model'];
          productoModel.productoType = bienesList[i]['subsidiary_good_type'];
          productoModel.productoSize = bienesList[i]['subsidiary_good_size'];
          productoModel.productoStock = bienesList[i]['subsidiary_good_stock'];
          productoModel.productoMeasure =
              bienesList[i]['subsidiary_good_stock_measure'];
          productoModel.productoRating =
              bienesList[i]['subsidiary_good_rating'];
          productoModel.productoUpdated =
              bienesList[i]['subsidiary_good_updated'];
          productoModel.productoStatus =
              bienesList[i]['subsidiary_good_status'];

          var productList =
              await productoDatabase.obtenerProductoPorIdSubsidiaryGood(
                  bienesList[i]['id_subsidiarygood']);

          if (productList.length > 0) {
            productoModel.productoFavourite = productList[0].productoFavourite;
          } else {
            productoModel.productoFavourite = '0';
          }
          await productoDatabase.insertarProducto(productoModel);

          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = bienesList[i]['id_subsidiary'];
          subsidiaryModel.idCompany = bienesList[i]['id_company'];
          subsidiaryModel.subsidiaryName = bienesList[i]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress =
              bienesList[i]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone =
              bienesList[i]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 =
              bienesList[i]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail = bienesList[i]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX =
              bienesList[i]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY =
              bienesList[i]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours =
              bienesList[i]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal =
              bienesList[i]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus = bienesList[i]['subsidiary_status'];

          final list = await subsidiaryDatabase
              .obtenerSubsidiaryPorId(bienesList[i]["id_subsidiary"]);

          if (list.length > 0) {
            subsidiaryModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
            //Subsidiary
          } else {
            subsidiaryModel.subsidiaryFavourite = "0";
          }
          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          CompanyModel companyModel = CompanyModel();

          companyModel.idCompany = bienesList[i]['id_company'];
          companyModel.idUser = bienesList[i]['id_user'];
          companyModel.idCity = bienesList[i]['id_city'];
          companyModel.idCategory = bienesList[i]['id_category'];
          companyModel.companyName = bienesList[i]['company_name'];
          companyModel.companyRuc = bienesList[i]['company_ruc'];
          companyModel.companyImage = bienesList[i]['company_image'];
          companyModel.companyType = bienesList[i]['company_type'];
          companyModel.companyShortcode = bienesList[i]['company_shortcode'];
          companyModel.companyDelivery = bienesList[i]['company_delivery'];
          companyModel.companyEntrega = bienesList[i]['company_entrega'];
          companyModel.companyTarjeta = bienesList[i]['company_tarjeta'];
          companyModel.companyVerified = bienesList[i]['company_verified'];
          companyModel.companyRating = bienesList[i]['company_rating'];
          companyModel.companyCreatedAt = bienesList[i]['company_created_at'];
          companyModel.companyJoin = bienesList[i]['company_join'];
          companyModel.companyStatus = bienesList[i]['company_status'];
          companyModel.companyMt = bienesList[i]['company_mt'];

          await companyDatabase.insertarCompany(companyModel);
        }
      }

      var serviciosList = res['servicios'];

      if (serviciosList.length > 0) {
        for (var i = 0; i < serviciosList.length; i++) {
          CategoriaModel categ = CategoriaModel();
          categ.idCategory = serviciosList[i]["id_category"];
          var categoryList = await categoryDatabase
              .obtenerCategoriasporID(serviciosList[i]["id_category"]);
          if (categoryList.length > 0) {
            categ.categoryName = categoryList[0].categoryName;
          } else {
            categ.categoryName = '';
          }
          await categoryDatabase.insertarCategory(categ);

          SubcategoryModel subcategoryModel = SubcategoryModel();
          subcategoryModel.idCategory = serviciosList[i]["id_category"];
          subcategoryModel.idSubcategory = serviciosList[i]["id_subcategory"];
          subcategoryModel.subcategoryName =
              serviciosList[i]["subcategory_name"];

          await subcategoryDatabase.insertarSubCategory(subcategoryModel);

          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idItemsubcategory =
              serviciosList[i]['id_itemsubcategory'];
          itemSubCategoriaModel.idSubcategory =
              serviciosList[i]['id_subcategory'];
          itemSubCategoriaModel.itemsubcategoryName = serviciosList[i]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = serviciosList[i]['itemsubcategory_img'];
          await itemsubCategoryDatabase
              .insertarItemSubCategoria(itemSubCategoriaModel,'Inicio/listar_bs_por_id_itemsubcat');

          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = serviciosList[i]['id_subsidiary'];
          subsidiaryModel.idCompany = serviciosList[i]['id_company'];
          subsidiaryModel.subsidiaryName = serviciosList[i]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress =
              serviciosList[i]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone =
              serviciosList[i]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 =
              serviciosList[i]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail =
              serviciosList[i]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX =
              serviciosList[i]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY =
              serviciosList[i]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours =
              serviciosList[i]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal =
              serviciosList[i]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus =
              serviciosList[i]['subsidiary_status'];

          final list = await subsidiaryDatabase
              .obtenerSubsidiaryPorId(serviciosList[i]["id_subsidiary"]);

          if (list.length > 0) {
            subsidiaryModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
            //Subsidiary
          } else {
            subsidiaryModel.subsidiaryFavourite = "0";
          }
          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          ServiciosModel servicemodel = ServiciosModel();
          servicemodel.idService = serviciosList[i]['id_service'];
          servicemodel.serviceName = serviciosList[i]['service_name'];
          servicemodel.serviceSynonyms = serviciosList[i]['service_synonyms'];

          await serviceDatabase.insertarService(servicemodel);

          SubsidiaryServiceModel subsidiaryServiceModel =
              SubsidiaryServiceModel();

          subsidiaryServiceModel.idSubsidiaryservice =
              serviciosList[i]['id_subsidiaryservice'];
          subsidiaryServiceModel.idSubsidiary =
              serviciosList[i]['id_subsidiary'];
          subsidiaryServiceModel.idService = serviciosList[i]['id_service'];
          subsidiaryServiceModel.idItemsubcategory =
              serviciosList[i]['id_itemsubcategory'];
          subsidiaryServiceModel.subsidiaryServiceName =
              serviciosList[i]['subsidiary_service_name'];
          subsidiaryServiceModel.subsidiaryServiceDescription =
              serviciosList[i]['subsidiary_service_description'];
          subsidiaryServiceModel.subsidiaryServicePrice =
              serviciosList[i]['subsidiary_service_price'];
          subsidiaryServiceModel.subsidiaryServiceCurrency =
              serviciosList[i]['subsidiary_service_currency'];
          subsidiaryServiceModel.subsidiaryServiceImage =
              serviciosList[i]['subsidiary_service_image'];
          subsidiaryServiceModel.subsidiaryServiceRating =
              serviciosList[i]['subsidiary_service_rating'].toString();
          subsidiaryServiceModel.subsidiaryServiceUpdated =
              serviciosList[i]['subsidiary_service_updated'];
          subsidiaryServiceModel.subsidiaryServiceStatus =
              serviciosList[i]['subsidiary_service_status'];

          var servis = await subisdiaryServiceDatabase
              .obtenerServiciosPorIdSucursalService(
                  serviciosList[i]['id_subsidiaryservice']);

          if (servis.length > 0) {
            subsidiaryServiceModel.subsidiaryServiceFavourite =
                servis[0].subsidiaryServiceFavourite;
          } else {
            subsidiaryServiceModel.subsidiaryServiceFavourite = '0';
          }
          await subisdiaryServiceDatabase
              .insertarSubsidiaryService(subsidiaryServiceModel);

          CompanyModel companyModel = CompanyModel();

          companyModel.idCompany = serviciosList[i]['id_company'];
          companyModel.idUser = serviciosList[i]['id_user'];
          companyModel.idCity = serviciosList[i]['id_city'];
          companyModel.idCategory = serviciosList[i]['id_category'];
          companyModel.companyName = serviciosList[i]['company_name'];
          companyModel.companyRuc = serviciosList[i]['company_ruc'];
          companyModel.companyImage = serviciosList[i]['company_image'];
          companyModel.companyType = serviciosList[i]['company_type'];
          companyModel.companyShortcode = serviciosList[i]['company_shortcode'];
          companyModel.companyDelivery = serviciosList[i]['company_delivery'];
          companyModel.companyEntrega = serviciosList[i]['company_entrega'];
          companyModel.companyTarjeta = serviciosList[i]['company_tarjeta'];
          companyModel.companyVerified = serviciosList[i]['company_verified'];
          companyModel.companyRating = serviciosList[i]['company_rating'];
          companyModel.companyCreatedAt =
              serviciosList[i]['company_created_at'];
          companyModel.companyJoin = serviciosList[i]['company_join'];
          companyModel.companyStatus = serviciosList[i]['company_status'];
          companyModel.companyMt = serviciosList[i]['company_mt'];

          await companyDatabase.insertarCompany(companyModel);
        }
      }

      return 1;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
      //r

    }
  }
}
