import 'dart:convert';

import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class GoodApi {
  //final goodModel= BienesModel();
  final goodDatabase = GoodDatabase();
        final subcategoryDatabase = SubcategoryDatabase();
  final productoDatabase = ProductoDatabase();
      final subsidiaryDatabase = SubsidiaryDatabase();
      final companyDatabase = CompanyDatabase();
        final itemsubCategoryDatabase = ItemsubCategoryDatabase();

  //Retorna el nombre del bien
  Future<dynamic> obtenerGoodAll() async {
    try {
      var response = await http.post("$apiBaseURL/api/Negocio/listar_all_good");

      List decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        //final listGood = await goodDatabase.obtenerGood();

        BienesModel goodmodel = BienesModel();

        goodmodel.idGood = decodedData[i]['id_good'];
        goodmodel.goodName = decodedData[i]['good_name'];
        goodmodel.goodSynonyms = decodedData[i]['good_synonyms'];

        await goodDatabase.insertarGood(goodmodel);
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  //Lista de todos los bienes en la pagina Principal
  Future<int> listarBienesAllPorCiudad() async {
    final response = await http.post(
        "$apiBaseURL/api/Login/listar_bienes_por_id_ciudad",
        body: {'id_ciudad': '1'});

    final decodedData = json.decode(response.body);

    
    for (int i = 0; i < decodedData["bienes"].length; i++) {
      //-----ingresamos Good
      BienesModel goodmodel = BienesModel();
      goodmodel.idGood = decodedData[i]['id_good'];
      goodmodel.goodName = decodedData[i]['good_name'];
      goodmodel.goodSynonyms = decodedData[i]['good_synonyms'];
      await goodDatabase.insertarGood(goodmodel);



      var productosListModel = decodedData['bienes'][i];



      //-----ingresamos subcategorias
      SubcategoryModel subcategoryModel = SubcategoryModel();
      final subcategoryDatabase = SubcategoryDatabase();
      subcategoryModel.idSubcategory =productosListModel['id_subcategory'];
      subcategoryModel.subcategoryName =productosListModel['subcategory_name'];
      subcategoryModel.idCategory = productosListModel['id_category'];
      await subcategoryDatabase.insertarSubCategory(subcategoryModel);

      //----ingresamos ItemSubCategorias:
      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      final itemsubCategoryDatabase = ItemsubCategoryDatabase();

      itemSubCategoriaModel.idItemsubcategory =productosListModel['id_itemsubcategory'];
      itemSubCategoriaModel.idSubcategory =productosListModel['id_subcategory'];
      itemSubCategoriaModel.itemsubcategoryName =productosListModel['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);

      //----ingresamos Company:
      CompanyModel companyModel = CompanyModel();

      companyModel.idCompany = productosListModel['id_company'];
      companyModel.idUser = productosListModel['id_user'];
      companyModel.idCity =productosListModel['id_city'];
      companyModel.idCategory = productosListModel['id_category'];
      companyModel.companyName = productosListModel['company_name'];
      companyModel.companyRuc = productosListModel['company_ruc'];
      companyModel.companyImage = productosListModel['company_image'];
      companyModel.companyType = productosListModel['company_type'];
      companyModel.companyShortcode =productosListModel['company_shortcode'];
      companyModel.companyDelivery =productosListModel['company_delivery'];
      companyModel.companyEntrega = productosListModel['company_entrega'];
      companyModel.companyTarjeta = productosListModel['company_tarjeta'];
      companyModel.companyVerified =productosListModel['company_verified'];
      companyModel.companyRating = productosListModel['company_rating'];
      companyModel.companyCreatedAt =productosListModel['company_created_at'];
      companyModel.companyJoin = productosListModel['company_join'];
      companyModel.companyStatus = productosListModel['company_status'];
      companyModel.companyMt =productosListModel['company_mt'];
      //companyModel.miNegocio= decodedData[]
      await companyDatabase.insertarCompany(companyModel);

      //----ingresamos SubsidiaryGood:
      ProductoModel productoModel = ProductoModel();
      productoModel.idProducto =
          productosListModel['id_subsidiarygood'];
      productoModel.idSubsidiary =productosListModel['id_subsidiary'];
      productoModel.idGood = productosListModel['id_good'];
      productoModel.idItemsubcategory = productosListModel['id_itemsubcategory'];
      productoModel.productoName =  productosListModel['subsidiary_good_name'];
      productoModel.productoPrice =  productosListModel['subsidiary_good_price'];
      productoModel.productoCurrency =  productosListModel['subsidiary_good_currency'];
      productoModel.productoImage = productosListModel['subsidiary_good_image'];
      productoModel.productoCharacteristics = productosListModel['subsidiary_good_characteristics'];
      productoModel.productoBrand =  productosListModel['subsidiary_good_brand'];
      productoModel.productoModel = productosListModel['subsidiary_good_model'];
      productoModel.productoType =  productosListModel['subsidiary_good_type'];
      productoModel.productoSize =  productosListModel['subsidiary_good_size'];
      productoModel.productoStock =  productosListModel['subsidiary_good_stock'];
      productoModel.productoMeasure =  productosListModel['subsidiary_good_stock_measure'];
      productoModel.productoRating =   productosListModel['subsidiary_good_rating'];
      productoModel.productoUpdated =     productosListModel['subsidiary_good_updated'];
      productoModel.productoStatus = productosListModel['subsidiary_good_status'];

       var productList =  await productoDatabase.obtenerProductoPorIdSubsidiaryGood(productosListModel['id_subsidiarygood']);

          if(productList.length>0){
            productoModel.productoFavourite =productList[0].productoFavourite;
          }else{
            productoModel.productoStatus = '';
          }
      await productoDatabase.insertarSubsidiaryGood(productoModel);

      

      //Cuando el servicio no entrega los datos completos:
      final list = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["bienes"][i]["id_subsidiary"]);

           SubsidiaryModel subsidiaryModel = SubsidiaryModel();
        subsidiaryModel.idSubsidiary =
            decodedData['bienes'][i]['id_subsidiary'];
        subsidiaryModel.idCompany = decodedData['bienes'][i]['id_company'];
        subsidiaryModel.subsidiaryName =
            decodedData['bienes'][i]['subsidiary_name'];
        subsidiaryModel.subsidiaryAddress =
            decodedData['bienes'][i]['subsidiary_address'];
        subsidiaryModel.subsidiaryCellphone =
            decodedData['bienes'][i]['subsidiary_cellphone'];
        subsidiaryModel.subsidiaryCellphone2 =
            decodedData['bienes'][i]['subsidiary_cellphone_2'];
        subsidiaryModel.subsidiaryEmail =
            decodedData['bienes'][i]['subsidiary_email'];
        subsidiaryModel.subsidiaryCoordX =
            decodedData['bienes'][i]['subsidiary_coord_x'];
        subsidiaryModel.subsidiaryCoordY =
            decodedData['bienes'][i]['subsidiary_coord_y'];
        subsidiaryModel.subsidiaryOpeningHours =
            decodedData['bienes'][i]['subsidiary_opening_hours'];
        subsidiaryModel.subsidiaryPrincipal =
            decodedData['bienes'][i]['subsidiary_principal'];
        subsidiaryModel.subsidiaryStatus =
            decodedData['bienes'][i]['subsidiary_status'];
          
       
      if (list.length > 0) {
        subsidiaryModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
        //Subsidiary
      } else {
        subsidiaryModel.subsidiaryFavourite = "0";
      }
       await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
    }
    return 0;
  }

  Future<dynamic> obtenerBienesPorIdItemsubcategoria(String id) async {
    try {
      var response = await http.post("$apiBaseURL/api/Login/listar_bienes_por_id_itemsubcategoria",
          body: {'id_ciudad': '1','id_itemsubcategoria':'$id'});

      final decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData["bienes"].length; i++) {

        var listBienes = decodedData["bienes"][i];
        BienesModel goodmodel = BienesModel();

        goodmodel.idGood = listBienes['id_good'];
        goodmodel.goodName = listBienes['good_name'];
        goodmodel.goodSynonyms = listBienes['good_synonyms'];

        await goodDatabase.insertarGood(goodmodel);

        //-----ingresamos subcategorias
        SubcategoryModel subcategoryModel = SubcategoryModel();
        subcategoryModel.idSubcategory =listBienes['id_subcategory'];
        subcategoryModel.subcategoryName =listBienes['subcategory_name'];
        subcategoryModel.idCategory = listBienes['id_category'];
        await subcategoryDatabase.insertarSubCategory(subcategoryModel);

        //----ingresamos ItemSubCategorias:
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();

        itemSubCategoriaModel.idItemsubcategory =listBienes['id_itemsubcategory'];
        itemSubCategoriaModel.idSubcategory =listBienes['id_subcategory'];
        itemSubCategoriaModel.itemsubcategoryName =listBienes['itemsubcategory_name'];
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel);

        //----ingresamos Company:
        CompanyModel companyModel = CompanyModel();

        companyModel.idCompany = listBienes['id_company'];
        companyModel.idUser = listBienes['id_user'];
        companyModel.idCity = listBienes['id_city'];
        companyModel.idCategory = listBienes['id_category'];
        companyModel.companyName = listBienes['company_name'];
        companyModel.companyRuc = listBienes['company_ruc'];
        companyModel.companyImage = listBienes['company_image'];
        companyModel.companyType = listBienes['company_type'];
        companyModel.companyShortcode =listBienes['company_shortcode'];
        companyModel.companyDelivery =listBienes['company_delivery'];
        companyModel.companyEntrega = listBienes['company_entrega'];
        companyModel.companyTarjeta =listBienes['company_tarjeta'];
        companyModel.companyVerified = listBienes['company_verified'];
        companyModel.companyRating = listBienes['company_rating'];
        companyModel.companyCreatedAt =listBienes['company_created_at'];
        companyModel.companyJoin = listBienes['company_join'];
        companyModel.companyStatus = listBienes['company_status'];
        companyModel.companyMt = listBienes['company_mt'];
        //companyModel.miNegocio= decodedData[]
        await companyDatabase.insertarCompany(companyModel);

        //----ingresamos SubsidiaryGood:
        ProductoModel subsidiaryGoodModel = ProductoModel();

        subsidiaryGoodModel.idProducto =listBienes['id_subsidiarygood'];
        subsidiaryGoodModel.idSubsidiary =listBienes['id_subsidiary'];
        subsidiaryGoodModel.idGood = listBienes['id_good'];
        subsidiaryGoodModel.idItemsubcategory =listBienes['id_itemsubcategory'];
        subsidiaryGoodModel.productoName =listBienes['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice =listBienes['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency =listBienes['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage =listBienes['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics =listBienes['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand =listBienes['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel =listBienes['subsidiary_good_model'];
        subsidiaryGoodModel.productoType =listBienes['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize =listBienes['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock =listBienes['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure =listBienes['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating =listBienes['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated =listBienes['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus =listBienes['subsidiary_good_status'];
        await productoDatabase
            .insertarSubsidiaryGood(subsidiaryGoodModel);

        //Subsidiary:
        SubsidiaryModel subsidiaryModel = SubsidiaryModel();

        //Cuando el servicio no entrega los datos completos:
        final list = await subsidiaryDatabase
            .obtenerSubsidiaryPorId(listBienes["id_subsidiary"]);
        if (list.length > 0) {
          subsidiaryModel.idSubsidiary =
              listBienes['id_subsidiary'];
          subsidiaryModel.idCompany = listBienes['id_company'];
          subsidiaryModel.subsidiaryName =listBienes['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress =listBienes['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone =listBienes['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 =listBienes['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail =listBienes['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX =listBienes['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY =listBienes['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours =listBienes['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal =listBienes['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus =listBienes['subsidiary_status'];
          //Favorito no existe en el servicio
          subsidiaryModel.subsidiaryFavourite = list[0].subsidiaryFavourite;

          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
        }
        return 0;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }



  
}

