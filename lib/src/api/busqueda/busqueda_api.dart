import 'dart:convert';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/service_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/busquedaModel.dart';
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
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BusquedaApi {
  final prefs = Preferences();
  final productoDatabase = ProductoDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  final serviceDatabase = ServiceDatabase();
  final companyDb = CompanyDatabase();
  final goodDb = GoodDatabase();
  final categoryDatabase = CategoryDatabase();
  final subcategoryDatabase = SubcategoryDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();

  Future<List<BusquedaGeneralModel>> busquedaGeneral(String query) async {
    final List<BusquedaGeneralModel> listBusquedaGeneral = [];
    final List<ProductoModel> listaDeProductos = [];
    final List<SubsidiaryServiceModel> listaDeServicios = [];
    final List<CompanyModel> listaDeNegocios = [];
    final List<SubsidiaryModel> listaDeSucursales = [];
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });

      var decodedData = json.decode(res.body);
      //print(decodedData);
      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            if (context == "good") {
              if (tipoBusqueda == "exactly") {
                for (var i = 0; i < decodedData["result"].length; i++) {
                  //Producto
                  ProductoModel productoModel = ProductoModel();
                  productoModel.idProducto = decodedData["result"][i]['id_subsidiarygood'];
                  productoModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
                  productoModel.idGood = decodedData["result"][i]['id_good'];
                  productoModel.idItemsubcategory = decodedData["result"][i]['id_itemsubcategory'];
                  productoModel.productoName = decodedData["result"][i]['subsidiary_good_name'];
                  productoModel.productoPrice = decodedData["result"][i]['subsidiary_good_price'];
                  productoModel.productoCurrency = decodedData["result"][i]['subsidiary_good_currency'];
                  productoModel.productoImage = decodedData["result"][i]['subsidiary_good_image'];
                  productoModel.productoCharacteristics = decodedData["result"][i]['subsidiary_good_characteristics'];
                  productoModel.productoBrand = decodedData["result"][i]['subsidiary_good_brand'];
                  productoModel.productoModel = decodedData["result"][i]['subsidiary_good_model'];
                  productoModel.productoType = decodedData["result"][i]['subsidiary_good_type'];
                  productoModel.productoSize = decodedData["result"][i]['subsidiary_good_size'];
                  productoModel.productoStock = decodedData["result"][i]['subsidiary_good_stock'];
                  productoModel.productoStockStatus = decodedData["result"][i]['subsidiary_good_stock_status'];
                  productoModel.productoMeasure = decodedData["result"][i]['subsidiary_good_stock_measure'];
                  productoModel.productoRating = decodedData["result"][i]['subsidiary_good_rating'];
                  productoModel.productoUpdated = decodedData["result"][i]['subsidiary_good_updated'];
                  productoModel.productoStatus = decodedData["result"][i]['subsidiary_good_status'];

                  var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][i]['id_subsidiarygood']);

                  if (productList.length > 0) {
                    productoModel.productoFavourite = productList[0].productoFavourite;
                  } else {
                    productoModel.productoFavourite = '0';
                  }

                  //listProducto.add(productoModel);
                  //insertar a la tabla Producto
                  await productoDatabase.insertarProducto(productoModel);

                  listaDeProductos.add(productoModel);

                  //BienesModel
                  BienesModel goodmodel = BienesModel();
                  goodmodel.idGood = decodedData["result"][i]['id_good'];
                  goodmodel.goodName = decodedData["result"][i]['good_name'];
                  goodmodel.goodSynonyms = decodedData["result"][i]['good_synonyms'];

                  //listbienes.add(goodmodel);
                  await goodDb.insertarGood(goodmodel);

                  //Subsidiary
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][i]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][i]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][i]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][i]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][i]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][i]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][i]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][i]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][i]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][i]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][i]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][i]['subsidiary_img'];

                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][i]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  //insertar a la tabla sucursal
                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);
                  listaDeSucursales.add(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][i]['id_company'];
                  companyModel.idUser = decodedData["result"][i]['id_user'];
                  companyModel.idCity = decodedData["result"][i]['id_city'];
                  companyModel.idCategory = decodedData["result"][i]['id_category'];
                  companyModel.companyName = decodedData["result"][i]['company_name'];
                  companyModel.companyRuc = decodedData["result"][i]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][i]['company_image'];
                  companyModel.companyType = decodedData["result"][i]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][i]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][i]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][i]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][i]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][i]['company_verified'];
                  companyModel.companyRating = decodedData["result"][i]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][i]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][i]['company_join'];
                  companyModel.companyStatus = decodedData["result"][i]['company_status'];
                  companyModel.companyMt = decodedData["result"][i]['company_mt'];
                  companyModel.idCountry = decodedData["result"][i]['id_country'];
                  companyModel.cityName = decodedData["result"][i]['city_name'];
                  companyModel.distancia = decodedData["result"][i]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  listaDeNegocios.add(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][i]["id_category"];
                  categ.categoryName = decodedData["result"][i]["category_name"];
                  categ.categoryEstado = decodedData["result"][i]["category_estado"];
                  categ.categoryImage = decodedData["result"][i]["category_img"];

                  // listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][i]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][i]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][i]["subcategory_name"];

                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel, 'Negocio/buscar_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][i]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][i]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][i]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][i]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                }

                // busqGeneralModel.listBienes = listbienes;
                // busqGeneralModel.listProducto = listProducto;
                // busqGeneralModel.listSucursal = listSucursal;
                // busqGeneralModel.listCompany = listCompany;
                // busqGeneralModel.listCategory = listCategory;
                // busqGeneralModel.listSubcategory = listSubCategory;
                // busqGeneralModel.listItemSubCateg = listItemSub;
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  if (decodedData["result"][h].length > 0) {
                    for (var i = 0; i < decodedData["result"][h].length; i++) {
                      //Producto
                      ProductoModel productoModel = ProductoModel();
                      productoModel.idProducto = decodedData["result"][h][i]['id_subsidiarygood'];
                      productoModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                      productoModel.idGood = decodedData["result"][h][i]['id_good'];
                      productoModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                      productoModel.productoName = decodedData["result"][h][i]['subsidiary_good_name'];
                      productoModel.productoPrice = decodedData["result"][h][i]['subsidiary_good_price'];
                      productoModel.productoCurrency = decodedData["result"][h][i]['subsidiary_good_currency'];
                      productoModel.productoImage = decodedData["result"][h][i]['subsidiary_good_image'];
                      productoModel.productoCharacteristics = decodedData["result"][h][i]['subsidiary_good_characteristics'];
                      productoModel.productoBrand = decodedData["result"][h][i]['subsidiary_good_brand'];
                      productoModel.productoModel = decodedData["result"][h][i]['subsidiary_good_model'];
                      productoModel.productoType = decodedData["result"][h][i]['subsidiary_good_type'];
                      productoModel.productoSize = decodedData["result"][h][i]['subsidiary_good_size'];
                      productoModel.productoStock = decodedData["result"][h][i]['subsidiary_good_stock'];
                      productoModel.productoStockStatus = decodedData["result"][h][i]['subsidiary_good_stock_status'];
                      productoModel.productoMeasure = decodedData["result"][h][i]['subsidiary_good_stock_measure'];
                      productoModel.productoRating = decodedData["result"][h][i]['subsidiary_good_rating'];
                      productoModel.productoUpdated = decodedData["result"][h][i]['subsidiary_good_updated'];
                      productoModel.productoStatus = decodedData["result"][h][i]['subsidiary_good_status'];

                      var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][h][i]['id_subsidiarygood']);

                      if (productList.length > 0) {
                        productoModel.productoFavourite = productList[0].productoFavourite;
                      } else {
                        productoModel.productoFavourite = '';
                      }
                      //insertar a la tabla Producto
                      await productoDatabase.insertarProducto(productoModel);

                      listaDeProductos.add(productoModel);

                      //BienesModel
                      BienesModel goodmodel = BienesModel();
                      goodmodel.idGood = decodedData["result"][h][i]['id_good'];
                      goodmodel.goodName = decodedData["result"][h][i]['good_name'];
                      goodmodel.goodSynonyms = decodedData["result"][h][i]['good_synonyms'];

                      await goodDb.insertarGood(goodmodel);

                      //Subsidiary
                      SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                      subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                      subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                      subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                      subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                      subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                      subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                      subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                      subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                      subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                      subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                      subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                      subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                      subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                      final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                      if (listSubsidiaryDb.length > 0) {
                        subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                      } else {
                        subsidiaryModel.subsidiaryFavourite = '0';
                      }

                      //insertar a la tabla sucursal
                      await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                      listaDeSucursales.add(subsidiaryModel);

                      CompanyModel companyModel = CompanyModel();
                      companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                      companyModel.idUser = decodedData["result"][h][i]['id_user'];
                      companyModel.idCity = decodedData["result"][h][i]['id_city'];
                      companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                      companyModel.companyName = decodedData["result"][h][i]['company_name'];
                      companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                      companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                      companyModel.companyType = decodedData["result"][h][i]['company_type'];
                      companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                      companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                      companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                      companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                      companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                      companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                      companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                      companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                      companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                      companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                      companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                      companyModel.cityName = decodedData["result"][h][i]['city_name'];
                      companyModel.distancia = decodedData["result"][h][i]['distancia'];

                      //insertar a la tabla de Company
                      await companyDb.insertarCompany(companyModel);

                      listaDeNegocios.add(companyModel);
                      //Categoria
                      CategoriaModel categ = CategoriaModel();
                      categ.idCategory = decodedData["result"][h][i]["id_category"];
                      categ.categoryName = decodedData["result"][h][i]["category_name"];
                      categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                      categ.categoryImage = decodedData["result"][h][i]["category_img"];

                      //listCategory.add(categ);
                      await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                      //Subcategoria
                      final subCategoriaModel = SubcategoryModel();
                      subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                      subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                      // subCategoriaModel.subcategoryName =decodedData["result"][h][i].subcategoryName;
                      //listSubCategory.add(subCategoriaModel);
                      await subcategoryDatabase.insertarSubCategory(subCategoriaModel, '/Negocio/buscar_ws');

                      //ItemSubCategoriaModel
                      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                      itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                      itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                      itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][h][i]['itemsubcategory_name'];
                      itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                      //listItemSub.add(itemSubCategoriaModel);
                      await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                    }
                  } else {
                    print("La lista está vacía");
                  }
                }

                // busqGeneralModel.listBienes = listbienes;
                // busqGeneralModel.listProducto = listProducto;
                // busqGeneralModel.listSucursal = listSucursal;
                // busqGeneralModel.listCompany = listCompany;
                // busqGeneralModel.listCategory = listCategory;
                // busqGeneralModel.listSubcategory = listSubCategory;
                // busqGeneralModel.listItemSubCateg = listItemSub;
              }
            }
            //listBusquedaGeneral.add(busqGeneralModel);
            //------------Contexto: Servicio------------------------
            if (context == "service") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  final subsidiaryServiceModel = SubsidiaryServiceModel();
                  subsidiaryServiceModel.idSubsidiaryservice = decodedData["result"][j]['id_subsidiaryservice'];
                  subsidiaryServiceModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryServiceModel.idService = decodedData["result"][j]['id_service'];
                  subsidiaryServiceModel.idItemsubcategory = decodedData["result"][j]['id_itemsubcategory'];
                  subsidiaryServiceModel.subsidiaryServiceName = decodedData["result"][j]['subsidiary_service_name'];
                  subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["result"][j]['subsidiary_service_description'];
                  subsidiaryServiceModel.subsidiaryServicePrice = decodedData["result"][j]['subsidiary_service_price'];
                  subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["result"][j]['subsidiary_service_currency'];
                  subsidiaryServiceModel.subsidiaryServiceImage = decodedData["result"][j]['subsidiary_service_image'];
                  subsidiaryServiceModel.subsidiaryServiceRating = decodedData["result"][j]['subsidiary_service_rating'];
                  subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["result"][j]['subsidiary_service_updated'];
                  subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["result"][j]['subsidiary_service_status'];

                  ///listSubServicio.add(subsidiaryServiceModel);
                  final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["result"][j]['id_subsidiaryservice']);

                  if (list.length > 0) {
                    subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
                    //Subsidiary
                  } else {
                    subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
                  }
                  await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

                  listaDeServicios.add(subsidiaryServiceModel);

                  //Service
                  final servicemodel = ServiciosModel();
                  servicemodel.idService = decodedData["result"][j]['id_service'];
                  servicemodel.serviceName = decodedData["result"][j]['service_name'];
                  servicemodel.serviceSynonyms = decodedData["result"][j]['service_synonyms'];
                  //listService.add(servicemodel);
                  await serviceDatabase.insertarService(servicemodel);

                  //Sucursal
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  listaDeSucursales.add(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  listaDeNegocios.add(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  //listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][j]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][j]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][j]['subcategory_name'];
                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel, '/Negocio/buscar_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][j]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][j]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    final subsidiaryServiceModel = SubsidiaryServiceModel();
                    subsidiaryServiceModel.idSubsidiaryservice = decodedData["result"][h][i]['id_subsidiaryservice'];
                    subsidiaryServiceModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryServiceModel.idService = decodedData["result"][h][i]['id_service'];
                    subsidiaryServiceModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                    subsidiaryServiceModel.subsidiaryServiceName = decodedData["result"][h][i]['subsidiary_service_name'];
                    subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["result"][h][i]['subsidiary_service_description'];
                    subsidiaryServiceModel.subsidiaryServicePrice = decodedData["result"][h][i]['subsidiary_service_price'];
                    subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["result"][h][i]['subsidiary_service_currency'];
                    subsidiaryServiceModel.subsidiaryServiceImage = decodedData["result"][h][i]['subsidiary_service_image'];
                    subsidiaryServiceModel.subsidiaryServiceRating = decodedData["result"][h][i]['subsidiary_service_rating'];
                    subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["result"][h][i]['subsidiary_service_updated'];
                    subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["result"][h][i]['subsidiary_service_status'];
                    // listSubServicio.add(subsidiaryServiceModel);
                    final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["result"][h][i]['id_subsidiaryservice']);

                    if (list.length > 0) {
                      subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
                      //Subsidiary
                    } else {
                      subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
                    }
                    await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

                    listaDeServicios.add(subsidiaryServiceModel);

                    //Service
                    final servicemodel = ServiciosModel();
                    servicemodel.idService = decodedData["result"][h][i]['id_service'];
                    servicemodel.serviceName = decodedData["result"][h][i]['service_name'];
                    servicemodel.serviceSynonyms = decodedData["result"][h][i]['service_synonyms'];
                    //listService.add(servicemodel);
                    await serviceDatabase.insertarService(servicemodel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    listaDeSucursales.add(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    listaDeNegocios.add(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    //listCategory.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                    //Subcategoria
                    final subCategoriaModel = SubcategoryModel();
                    subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                    subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                    subCategoriaModel.subcategoryName = decodedData["result"][h][i]['subcategory_name'];
                    //listSubCategory.add(subCategoriaModel);
                    await subcategoryDatabase.insertarSubCategory(subCategoriaModel, '/Negocio/buscar_ws');

                    //ItemSubCategoriaModel
                    ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                    itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                    itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                    //listItemSub.add(itemSubCategoriaModel);
                    await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                  }
                }
              }
            }

            if (context == "company") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  //Sucursal
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  listaDeSucursales.add(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  await companyDb.insertarCompany(companyModel);

                  listaDeNegocios.add(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();

                    //final companySucursalModel = CompanySubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    //listSucursal.add(subsidiaryModel);
                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    listaDeSucursales.add(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    // listCompanySucursal.add(companySucursalModel);

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    listaDeNegocios.add(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');
                  }
                }
              }
            }

            if (context == "category") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();

                    //final companySucursalModel = CompanySubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    //listSucursal.add(subsidiaryModel);
                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);
                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_image"];

                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');
                  }
                }
              }
            }

            if (context == "itemsubcategory") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  //Producto
                  ProductoModel productoModel = ProductoModel();
                  productoModel.idProducto = decodedData["result"][j]['id_subsidiarygood'];
                  productoModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  productoModel.idGood = decodedData["result"][j]['id_good'];
                  productoModel.idItemsubcategory = decodedData["result"][j]['id_itemsubcategory'];
                  productoModel.productoName = decodedData["result"][j]['subsidiary_good_name'];
                  productoModel.productoPrice = decodedData["result"][j]['subsidiary_good_price'];
                  productoModel.productoCurrency = decodedData["result"][j]['subsidiary_good_currency'];
                  productoModel.productoImage = decodedData["result"][j]['subsidiary_good_image'];
                  productoModel.productoCharacteristics = decodedData["result"][j]['subsidiary_good_characteristics'];
                  productoModel.productoBrand = decodedData["result"][j]['subsidiary_good_brand'];
                  productoModel.productoModel = decodedData["result"][j]['subsidiary_good_model'];
                  productoModel.productoType = decodedData["result"][j]['subsidiary_good_type'];
                  productoModel.productoSize = decodedData["result"][j]['subsidiary_good_size'];
                  productoModel.productoStock = decodedData["result"][j]['subsidiary_good_stock'];
                  productoModel.productoStockStatus = decodedData["result"][j]['subsidiary_good_stock_status'];
                  productoModel.productoMeasure = decodedData["result"][j]['subsidiary_good_stock_measure'];
                  productoModel.productoRating = decodedData["result"][j]['subsidiary_good_rating'];
                  productoModel.productoUpdated = decodedData["result"][j]['subsidiary_good_updated'];
                  productoModel.productoStatus = decodedData["result"][j]['subsidiary_good_status'];

                  var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][j]['id_subsidiarygood']);

                  if (productList.length > 0) {
                    productoModel.productoFavourite = productList[0].productoFavourite;
                  } else {
                    productoModel.productoFavourite = '0';
                  }
                  //insertar a la tabla Producto
                  await productoDatabase.insertarProducto(productoModel);

                  //BienesModel
                  BienesModel goodmodel = BienesModel();
                  goodmodel.idGood = decodedData["result"][j]['id_good'];
                  goodmodel.goodName = decodedData["result"][j]['good_name'];
                  goodmodel.goodSynonyms = decodedData["result"][j]['good_synonyms'];

                  await goodDb.insertarGood(goodmodel);

                  //Subsidiary
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];

                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  //listSucursal.add(subsidiaryModel);
                  //insertar a la tabla sucursal
                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  //listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][j]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][j]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][j]['subcategory_name'];
                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel, '/Negocio/buscar_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][j]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][j]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Producto
                    ProductoModel productoModel = ProductoModel();
                    productoModel.idProducto = decodedData["result"][h][i]['id_subsidiarygood'];
                    productoModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    productoModel.idGood = decodedData["result"][h][i]['id_good'];
                    productoModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                    productoModel.productoName = decodedData["result"][h][i]['subsidiary_good_name'];
                    productoModel.productoPrice = decodedData["result"][h][i]['subsidiary_good_price'];
                    productoModel.productoCurrency = decodedData["result"][h][i]['subsidiary_good_currency'];
                    productoModel.productoImage = decodedData["result"][h][i]['subsidiary_good_image'];
                    productoModel.productoCharacteristics = decodedData["result"][h][i]['subsidiary_good_characteristics'];
                    productoModel.productoBrand = decodedData["result"][h][i]['subsidiary_good_brand'];
                    productoModel.productoModel = decodedData["result"][h][i]['subsidiary_good_model'];
                    productoModel.productoType = decodedData["result"][h][i]['subsidiary_good_type'];
                    productoModel.productoSize = decodedData["result"][h][i]['subsidiary_good_size'];
                    productoModel.productoStock = decodedData["result"][h][i]['subsidiary_good_stock'];
                    productoModel.productoStockStatus = decodedData["result"][h][i]['subsidiary_good_stock_status'];
                    productoModel.productoMeasure = decodedData["result"][h][i]['subsidiary_good_stock_measure'];
                    productoModel.productoRating = decodedData["result"][h][i]['subsidiary_good_rating'];
                    productoModel.productoUpdated = decodedData["result"][h][i]['subsidiary_good_updated'];
                    productoModel.productoStatus = decodedData["result"][h][i]['subsidiary_good_status'];

                    var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][h][i]['id_subsidiarygood']);

                    if (productList.length > 0) {
                      productoModel.productoFavourite = productList[0].productoFavourite;
                    } else {
                      productoModel.productoFavourite = '0';
                    }
                    //insertar a la tabla Producto
                    await productoDatabase.insertarProducto(productoModel);

                    //BienesModel
                    BienesModel goodmodel = BienesModel();
                    goodmodel.idGood = decodedData["result"][h][i]['id_good'];
                    goodmodel.goodName = decodedData["result"][h][i]['good_name'];
                    goodmodel.goodSynonyms = decodedData["result"][h][i]['good_synonyms'];

                    await goodDb.insertarGood(goodmodel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    //listCategory.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_ws');

                    //Subcategoria
                    final subCategoriaModel = SubcategoryModel();
                    subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                    subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                    subCategoriaModel.subcategoryName = decodedData["result"][h][i]['subcategory_name'];
                    //listSubCategory.add(subCategoriaModel);
                    await subcategoryDatabase.insertarSubCategory(subCategoriaModel, '/Negocio/buscar_ws');

                    //ItemSubCategoriaModel
                    ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                    itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                    itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                    //listItemSub.add(itemSubCategoriaModel);
                    await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_ws');
                  }
                }
              }
            }
          } else {
            print("No contamos con este producto o servicio por ahora");
          }
        } else {
          print("No hay nadaaa");
        }
      } else {
        print("Ingrese al menos un caracter");
      }

      print(decodedData["total_results"]);
      //print(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return [];
    }

    /*  for (var i = 0; i < listaDeProductos.length; i++) {

      listaDeProductos.reduce((value, element) => null)
      
    } */

    final listAlgo = await filtrarListaNegocios(listaDeNegocios);

    BusquedaGeneralModel busquedaGeneralModel = BusquedaGeneralModel();

    busquedaGeneralModel.listProducto = listaDeProductos.toSet().toList();
    busquedaGeneralModel.listServicios = listaDeServicios;
    busquedaGeneralModel.listSucursal = listaDeSucursales.toSet().toList();
    busquedaGeneralModel.listCompany = listAlgo;

    listBusquedaGeneral.add(busquedaGeneralModel);

    return listBusquedaGeneral;
  }

  //---------------------Producto-------------------------------
  Future<List<ProductoModel>> busquedaProducto(BuildContext context, String query) async {
//Bloc que instancia al tab de la busqueda para hacer el cambio de pestaña
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
    // selectorTabBusqueda.changePage(0);

    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_productos_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });

      final List<ProductoModel> listaDeProductos = [];
      final decodedData = json.decode(res.body);
      //Para mostrar el tab de servicios automaticamente
      //selectorTabBusqueda.changePage(0);

      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            // BusquedaProductoModel busqProductoModel = BusquedaProductoModel();

            // final listProducto = List<ProductoModel>();
            // final listbienes = List<BienesModel>();
            // final listSucursal = List<SubsidiaryModel>();
            // final listCompany = List<CompanyModel>();
            // final listCategory = List<CategoriaModel>();
            // final listSubCategory = List<SubcategoryModel>();
            // final listItemSub = List<ItemSubCategoriaModel>();

            if (context == "good") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  //Producto
                  ProductoModel productoModel = ProductoModel();
                  productoModel.idProducto = decodedData["result"][j]['id_subsidiarygood'];
                  productoModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  productoModel.idGood = decodedData["result"][j]['id_good'];
                  productoModel.idItemsubcategory = decodedData["result"][j]['id_itemsubcategory'];
                  productoModel.productoName = decodedData["result"][j]['subsidiary_good_name'];
                  productoModel.productoPrice = decodedData["result"][j]['subsidiary_good_price'];
                  productoModel.productoCurrency = decodedData["result"][j]['subsidiary_good_currency'];
                  productoModel.productoImage = decodedData["result"][j]['subsidiary_good_image'];
                  productoModel.productoCharacteristics = decodedData["result"][j]['subsidiary_good_characteristics'];
                  productoModel.productoBrand = decodedData["result"][j]['subsidiary_good_brand'];
                  productoModel.productoModel = decodedData["result"][j]['subsidiary_good_model'];
                  productoModel.productoType = decodedData["result"][j]['subsidiary_good_type'];
                  productoModel.productoSize = decodedData["result"][j]['subsidiary_good_size'];
                  productoModel.productoStock = decodedData["result"][j]['subsidiary_good_stock'];
                  productoModel.productoStockStatus = decodedData["result"][j]['subsidiary_good_stock_status'];
                  productoModel.productoMeasure = decodedData["result"][j]['subsidiary_good_stock_measure'];
                  productoModel.productoRating = decodedData["result"][j]['subsidiary_good_rating'];
                  productoModel.productoUpdated = decodedData["result"][j]['subsidiary_good_updated'];
                  productoModel.productoStatus = decodedData["result"][j]['subsidiary_good_status'];

                  //listaDeProductos.add(productoModel);

                  var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][j]['id_subsidiarygood']);

                  if (productList.length > 0) {
                    productoModel.productoFavourite = productList[0].productoFavourite;
                  } else {
                    productoModel.productoFavourite = '0';
                  }

                  listaDeProductos.add(productoModel);
                  //insertar a la tabla Producto
                  await productoDatabase.insertarProducto(productoModel);

                  //BienesModel
                  BienesModel goodmodel = BienesModel();
                  goodmodel.idGood = decodedData["result"][j]['id_good'];
                  goodmodel.goodName = decodedData["result"][j]['good_name'];
                  goodmodel.goodSynonyms = decodedData["result"][j]['good_synonyms'];

                  await goodDb.insertarGood(goodmodel);

                  //Subsidiary
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];

                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  //listSucursal.add(subsidiaryModel);
                  //insertar a la tabla sucursal
                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  //listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_productos_ws');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][j]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][j]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][j]["subcategory_name"];
                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel, 'Negocio/buscar_productos_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][j]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][j]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_productos_ws');
                }

                // busqProductoModel.listBienes = listbienes;
                // busqProductoModel.listProducto = listProducto;
                // busqProductoModel.listSucursal = listSucursal;
                // busqProductoModel.listCompany = listCompany;
                // busqProductoModel.listCategory = listCategory;
                // busqProductoModel.listSubcategory = listSubCategory;
                // busqProductoModel.listItemSubCateg = listItemSub;

                // ingresa al Tab de productos cuando existe al menos un resultado
                if (listaDeProductos.length > 0) {
                  selectorTabBusqueda.changePage(0);
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Producto
                    ProductoModel productoModel = ProductoModel();
                    productoModel.idProducto = decodedData["result"][h][i]['id_subsidiarygood'];
                    productoModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    productoModel.idGood = decodedData["result"][h][i]['id_good'];
                    productoModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                    productoModel.productoName = decodedData["result"][h][i]['subsidiary_good_name'];
                    productoModel.productoPrice = decodedData["result"][h][i]['subsidiary_good_price'];
                    productoModel.productoCurrency = decodedData["result"][h][i]['subsidiary_good_currency'];
                    productoModel.productoImage = decodedData["result"][h][i]['subsidiary_good_image'];
                    productoModel.productoCharacteristics = decodedData["result"][h][i]['subsidiary_good_characteristics'];
                    productoModel.productoBrand = decodedData["result"][h][i]['subsidiary_good_brand'];
                    productoModel.productoModel = decodedData["result"][h][i]['subsidiary_good_model'];
                    productoModel.productoType = decodedData["result"][h][i]['subsidiary_good_type'];
                    productoModel.productoSize = decodedData["result"][h][i]['subsidiary_good_size'];
                    productoModel.productoStock = decodedData["result"][h][i]['subsidiary_good_stock'];
                    productoModel.productoStockStatus = decodedData["result"][h][i]['subsidiary_good_stock_status'];
                    productoModel.productoMeasure = decodedData["result"][h][i]['subsidiary_good_stock_measure'];
                    productoModel.productoRating = decodedData["result"][h][i]['subsidiary_good_rating'];
                    productoModel.productoUpdated = decodedData["result"][h][i]['subsidiary_good_updated'];
                    productoModel.productoStatus = decodedData["result"][h][i]['subsidiary_good_status'];

                    //listaDeProductos.add(productoModel);

                    var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][h][i]['id_subsidiarygood']);

                    if (productList.length > 0) {
                      productoModel.productoFavourite = productList[0].productoFavourite;
                    } else {
                      productoModel.productoFavourite = '0';
                    }

                    listaDeProductos.add(productoModel);
                    //insertar a la tabla Producto
                    await productoDatabase.insertarProducto(productoModel);

                    //BienesModel
                    BienesModel goodmodel = BienesModel();
                    goodmodel.idGood = decodedData["result"][h][i]['id_good'];
                    goodmodel.goodName = decodedData["result"][h][i]['good_name'];
                    goodmodel.goodSynonyms = decodedData["result"][h][i]['good_synonyms'];

                    await goodDb.insertarGood(goodmodel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    //listCategory.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_productos_ws');

                    //Subcategoria
                    final subCategoriaModel = SubcategoryModel();
                    subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                    subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                    subCategoriaModel.subcategoryName = decodedData["result"][h][i]["subcategory_name"];
                    //listSubCategory.add(subCategoriaModel);
                    await subcategoryDatabase.insertarSubCategory(subCategoriaModel, 'Negocio/buscar_productos_ws');

                    //ItemSubCategoriaModel
                    ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                    itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                    itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                    //listItemSub.add(itemSubCategoriaModel);
                    await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_productos_ws');

                    // ingresa al Tab de productos cuando existe al menos un resultado
                    if (listaDeProductos.length > 0) {
                      selectorTabBusqueda.changePage(0);
                    }
                  }
                  //   busqProductoModel.listBienes = listbienes;
                  //   busqProductoModel.listProducto = listProducto;
                  //   busqProductoModel.listSucursal = listSucursal;
                  //   busqProductoModel.listCompany = listCompany;
                  //   busqProductoModel.listCategory = listCategory;
                  //   busqProductoModel.listSubcategory = listSubCategory;
                  //   busqProductoModel.listItemSubCateg = listItemSub;
                  //

                }
              }
              //listGeneral.add(busqProductoModel);
            }
          }
        } else {
          print("No haaaay productoooo");
        }
      }

      return listaDeProductos;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return [];
    }
    //return listGeneral;
    //return listaDeProductos;
  }

  //---------------------Servicio-------------------------------
  Future<List<SubsidiaryServiceModel>> busquedaServicio(BuildContext context, String query) async {
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
    // //Para mostrar el tab de servicios automaticamente
    // selectorTabBusqueda.changePage(1);
    final List<SubsidiaryServiceModel> listGeneral = [];
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_servicios_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });
      final decodedData = json.decode(res.body);

      //contexto de la busqueda, ejm: good, service, company...
      final contexto = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            //final busqServicioModel = BusquedaServicioModel();

            // final listService = List<ServiciosModel>();
            // final listSubServicio = List<SubsidiaryServiceModel>();
            // final listSucursal = List<SubsidiaryModel>();
            // final listCompany = List<CompanyModel>();
            // final listCategory = List<CategoriaModel>();
            // final listSubCategory = List<SubcategoryModel>();
            // final listItemSub = List<ItemSubCategoriaModel>();

            if (contexto == "service") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  final subsidiaryServiceModel = SubsidiaryServiceModel();
                  subsidiaryServiceModel.idSubsidiaryservice = decodedData["result"][j]['id_subsidiaryservice'];
                  subsidiaryServiceModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryServiceModel.idService = decodedData["result"][j]['id_service'];
                  subsidiaryServiceModel.idItemsubcategory = decodedData["result"][j]['id_itemsubcategory'];
                  subsidiaryServiceModel.subsidiaryServiceName = decodedData["result"][j]['subsidiary_service_name'];
                  subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["result"][j]['subsidiary_service_description'];
                  subsidiaryServiceModel.subsidiaryServicePrice = decodedData["result"][j]['subsidiary_service_price'];
                  subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["result"][j]['subsidiary_service_currency'];
                  subsidiaryServiceModel.subsidiaryServiceImage = decodedData["result"][j]['subsidiary_service_image'];
                  subsidiaryServiceModel.subsidiaryServiceRating = decodedData["result"][j]['subsidiary_service_rating'];
                  subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["result"][j]['subsidiary_service_updated'];
                  subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["result"][j]['subsidiary_service_status'];

                  ///listSubServicio.add(subsidiaryServiceModel);
                  final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["result"][j]['id_subsidiaryservice']);

                  if (list.length > 0) {
                    subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
                    //Subsidiary
                  } else {
                    subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
                  }
                  await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

                  listGeneral.add(subsidiaryServiceModel);

                  //Service
                  final servicemodel = ServiciosModel();
                  servicemodel.idService = decodedData["result"][j]['id_service'];
                  servicemodel.serviceName = decodedData["result"][j]['service_name'];
                  servicemodel.serviceSynonyms = decodedData["result"][j]['service_synonyms'];
                  //listService.add(servicemodel);
                  await serviceDatabase.insertarService(servicemodel);

                  //Sucursal
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  //listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_servicios_ws');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][j]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][j]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][j]["subcategory_name"];
                  // subCategoriaModel.subcategoryName =decodedData["result"][j].subcategoryName;
                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_servicios_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][j]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][j]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_servicios_ws');

                  // ingresa al Tab de Servicios cuando existe al menos un resultado de la busqueda
                  if (listGeneral.length > 0) {
                    //Para mostrar el tab de servicios automaticamente
                    selectorTabBusqueda.changePage(1);
                  }
                }
                // busqServicioModel.listService = listService;
                // busqServicioModel.listServicios = listSubServicio;
                // busqServicioModel.listSucursal = listSucursal;
                // busqServicioModel.listCompany = listCompany;
                // busqServicioModel.listCategory = listCategory;
                // busqServicioModel.listSubcategory = listSubCategory;
                // busqServicioModel.listItemSubCateg = listItemSub;

              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    final subsidiaryServiceModel = SubsidiaryServiceModel();
                    subsidiaryServiceModel.idSubsidiaryservice = decodedData["result"][h][i]['id_subsidiaryservice'];
                    subsidiaryServiceModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryServiceModel.idService = decodedData["result"][h][i]['id_service'];
                    subsidiaryServiceModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                    subsidiaryServiceModel.subsidiaryServiceName = decodedData["result"][h][i]['subsidiary_service_name'];
                    subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["result"][h][i]['subsidiary_service_description'];
                    subsidiaryServiceModel.subsidiaryServicePrice = decodedData["result"][h][i]['subsidiary_service_price'];
                    subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["result"][h][i]['subsidiary_service_currency'];
                    subsidiaryServiceModel.subsidiaryServiceImage = decodedData["result"][h][i]['subsidiary_service_image'];
                    subsidiaryServiceModel.subsidiaryServiceRating = decodedData["result"][h][i]['subsidiary_service_rating'];
                    subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["result"][h][i]['subsidiary_service_updated'];
                    subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["result"][h][i]['subsidiary_service_status'];
                    // listSubServicio.add(subsidiaryServiceModel);

                    final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["result"][h][i]['id_subsidiaryservice']);

                    if (list.length > 0) {
                      subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
                      //Subsidiary
                    } else {
                      subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
                    }

                    await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

                    listGeneral.add(subsidiaryServiceModel);

                    //Service
                    final servicemodel = ServiciosModel();
                    servicemodel.idService = decodedData["result"][h][i]['id_service'];
                    servicemodel.serviceName = decodedData["result"][h][i]['service_name'];
                    servicemodel.serviceSynonyms = decodedData["result"][h][i]['service_synonyms'];
                    //listService.add(servicemodel);
                    await serviceDatabase.insertarService(servicemodel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    //listCategory.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_servicios_ws');

                    //Subcategoria
                    final subCategoriaModel = SubcategoryModel();
                    subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                    subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                    subCategoriaModel.subcategoryName = decodedData["result"][h][i]["subcategory_name"];
                    // subCategoriaModel.subcategoryName =decodedData["result"][h][i].subcategoryName;
                    //listSubCategory.add(subCategoriaModel);
                    await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_servicios_ws');

                    //ItemSubCategoriaModel
                    ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                    itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                    itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                    //listItemSub.add(itemSubCategoriaModel);
                    await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_servicios_ws');

                    // ingresa al Tab de Servicios cuando existe al menos un resultado de la busqueda
                    if (listGeneral.length > 0) {
                      //Para mostrar el tab de servicios automaticamente
                      selectorTabBusqueda.changePage(1);
                    }
                  }

                  //   busqServicioModel.listService = listService;
                  //   busqServicioModel.listServicios = listSubServicio;
                  //   busqServicioModel.listSucursal = listSucursal;
                  //   busqServicioModel.listCompany = listCompany;
                  //   busqServicioModel.listCategory = listCategory;
                  //   busqServicioModel.listSubcategory = listSubCategory;
                  //   busqServicioModel.listItemSubCateg = listItemSub;

                }
              }
              //listGeneral.add(busqServicioModel);
            }
          }
        } else {
          print("No haaaay serviciooo");
        }
      }
      return listGeneral;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return listGeneral;
  }

  //---------------------Negocio-------------------------------
  Future<List<CompanySubsidiaryModel>> busquedaNegocio(BuildContext context, String query) async {
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);

    final List<CompanySubsidiaryModel> listGeneral = [];
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_empresas_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });
      final decodedData = json.decode(res.body);
      //Para mostrar el tab de servicios automaticamente
      //selectorTabBusqueda.changePage(2);

      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            //final busqCompanyModel = BusquedaNegocioModel();

            // final listSucursal = List<SubsidiaryModel>();
            // final listCompany = List<CompanyModel>();
            // final listCompanySucursal = List<CompanySubsidiaryModel>();
            // final listCategory = List<CategoriaModel>();

            if (context == "company") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  //CompanySucursal
                  //final companySucursalModel = CompanySubsidiaryModel();

                  CompanySubsidiaryModel companySubsidiaryModel = CompanySubsidiaryModel();

                  companySubsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  companySubsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  companySubsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  companySubsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  companySubsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  companySubsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  companySubsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  companySubsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  companySubsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  companySubsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  companySubsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  companySubsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  companySubsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  companySubsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  companySubsidiaryModel.idUser = decodedData["result"][j]['id_user'];
                  companySubsidiaryModel.idCity = decodedData["result"][j]['id_city'];
                  companySubsidiaryModel.idCategory = decodedData["result"][j]['id_category'];
                  companySubsidiaryModel.companyName = decodedData["result"][j]['company_name'];
                  companySubsidiaryModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companySubsidiaryModel.companyImage = decodedData["result"][j]['company_image'];
                  companySubsidiaryModel.companyType = decodedData["result"][j]['company_type'];
                  companySubsidiaryModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companySubsidiaryModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companySubsidiaryModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companySubsidiaryModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companySubsidiaryModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companySubsidiaryModel.companyRating = decodedData["result"][j]['company_rating'];
                  companySubsidiaryModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companySubsidiaryModel.companyJoin = decodedData["result"][j]['company_join'];
                  companySubsidiaryModel.companyStatus = decodedData["result"][j]['company_status'];
                  companySubsidiaryModel.companyMt = decodedData["result"][j]['company_mt'];
                  companySubsidiaryModel.idCountry = decodedData["result"][j]['id_country'];
                  companySubsidiaryModel.cityName = decodedData["result"][j]['city_name'];
                  companySubsidiaryModel.distancia = decodedData["result"][j]['distancia'];

                  listGeneral.add(companySubsidiaryModel);

                  //Sucursal
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_empresas_ws');

                  // ingresa al Tab de Negocios cuando existe al menos un resultado de la busqueda
                  if (listGeneral.length > 0) {
                    //Para mostrar el tab de negocios automaticamente
                    selectorTabBusqueda.changePage(2);
                  }
                }

                // busqCompanyModel.listCompany = listCompany;
                // busqCompanyModel.listSucursal = listSucursal;
                // busqCompanyModel.listCompanySubsidiary = listCompanySucursal;
                // busqCompanyModel.listCategory = listCategory;

              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    CompanySubsidiaryModel companySubsidiaryModel = CompanySubsidiaryModel();

                    companySubsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    companySubsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    companySubsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companySubsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    companySubsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    companySubsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    companySubsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    companySubsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    companySubsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    companySubsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    companySubsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    companySubsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    companySubsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    companySubsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companySubsidiaryModel.idUser = decodedData["result"][h][i]['id_user'];
                    companySubsidiaryModel.idCity = decodedData["result"][h][i]['id_city'];
                    companySubsidiaryModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companySubsidiaryModel.companyName = decodedData["result"][h][i]['company_name'];
                    companySubsidiaryModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companySubsidiaryModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companySubsidiaryModel.companyType = decodedData["result"][h][i]['company_type'];
                    companySubsidiaryModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companySubsidiaryModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companySubsidiaryModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companySubsidiaryModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companySubsidiaryModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companySubsidiaryModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companySubsidiaryModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companySubsidiaryModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companySubsidiaryModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companySubsidiaryModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companySubsidiaryModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companySubsidiaryModel.cityName = decodedData["result"][h][i]['city_name'];
                    companySubsidiaryModel.distancia = decodedData["result"][h][i]['distancia'];

                    listGeneral.add(companySubsidiaryModel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();

                    //final companySucursalModel = CompanySubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    //listSucursal.add(subsidiaryModel);
                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    // listCompanySucursal.add(companySucursalModel);

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_empresas_ws');

                    if (listGeneral.length > 0) {
                      //Para mostrar el tab de negocios automaticamente
                      selectorTabBusqueda.changePage(2);
                    }
                  }
                }
                // busqCompanyModel.listSucursal = listSucursal;
                // busqCompanyModel.listCompany = listCompany;
                // busqCompanyModel.listCompanySubsidiary = listCompanySucursal;
                // busqCompanyModel.listCategory = listCategory;
                //
                // ingresa al Tab de Negocios cuando existe al menos un resultado de la busqueda

              }
            }
            //listGeneral.add(busqCompanyModel);
          }
        } else {
          print("No haaaay negocio");
        }
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return listGeneral;
  }

  //---------------------Categoria-------------------------------
  Future<List<CategoriaModel>> busquedaCategorias(BuildContext context, String query) async {
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
    //Para mostrar el tab de servicios automaticamente
    //selectorTabBusqueda.changePage(4);
    final List<CategoriaModel> listGeneral = [];
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_categorias_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });
      final decodedData = json.decode(res.body);

      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            if (context == "category") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];
                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];
                  categ.categoryEstado = decodedData["result"][j]["category_estado"];
                  categ.categoryImage = decodedData["result"][j]["category_img"];

                  listGeneral.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_categorias_ws');

                  // ingresa al Tab de categoria ycuando existe al menos un resultado de la busqueda
                  if (listGeneral.length > 0) {
                    //Para mostrar el tab de servicios automaticamente
                    selectorTabBusqueda.changePage(4);
                  }
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();

                    //final companySucursalModel = CompanySubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    //listSucursal.add(subsidiaryModel);
                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);
                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];
                    categ.categoryEstado = decodedData["result"][h][i]["category_estado"];
                    categ.categoryImage = decodedData["result"][h][i]["category_img"];

                    listGeneral.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'Negocio/buscar_categorias_ws');

                    // ingresa al Tab de categoria ycuando existe al menos un resultado de la busqueda
                    if (listGeneral.length > 0) {
                      //Para mostrar el tab de categoria automaticamente
                      selectorTabBusqueda.changePage(4);
                    }
                  }
                }
              }
            }
          }
        } else {
          print("No haaaay categoria");
        }
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return listGeneral;
  }

  Future<dynamic> busquedaItemsubcategorias(String query) async {
    //final listGeneral = List<BusquedaProductoModel>();
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_itemsubcategory_ws"), body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });
      final decodedData = json.decode(res.body);

      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];
      //cantidad de resultados
      final int totalResult = decodedData["total_results"];
      //tipo de búsqueda: exacta, similar o match
      final tipoBusqueda = decodedData["find"];

      //codigo de respuesta del servicio:1,2,6...
      final int code = decodedData["code"];

      if (code == 1) {
        if (tipoBusqueda != null) {
          if (totalResult > 0) {
            if (context == "itemsubcategory") {
              if (tipoBusqueda == "exactly") {
                for (var j = 0; j < decodedData["result"].length; j++) {
                  //Producto
                  ProductoModel productoModel = ProductoModel();
                  productoModel.idProducto = decodedData["result"][j]['id_subsidiarygood'];
                  productoModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  productoModel.idGood = decodedData["result"][j]['id_good'];
                  productoModel.idItemsubcategory = decodedData["result"][j]['id_itemsubcategory'];
                  productoModel.productoName = decodedData["result"][j]['subsidiary_good_name'];
                  productoModel.productoPrice = decodedData["result"][j]['subsidiary_good_price'];
                  productoModel.productoCurrency = decodedData["result"][j]['subsidiary_good_currency'];
                  productoModel.productoImage = decodedData["result"][j]['subsidiary_good_image'];
                  productoModel.productoCharacteristics = decodedData["result"][j]['subsidiary_good_characteristics'];
                  productoModel.productoBrand = decodedData["result"][j]['subsidiary_good_brand'];
                  productoModel.productoModel = decodedData["result"][j]['subsidiary_good_model'];
                  productoModel.productoType = decodedData["result"][j]['subsidiary_good_type'];
                  productoModel.productoSize = decodedData["result"][j]['subsidiary_good_size'];
                  productoModel.productoStock = decodedData["result"][j]['subsidiary_good_stock'];
                  productoModel.productoStockStatus = decodedData["result"][j]['subsidiary_good_stock_status'];
                  productoModel.productoMeasure = decodedData["result"][j]['subsidiary_good_stock_measure'];
                  productoModel.productoRating = decodedData["result"][j]['subsidiary_good_rating'];
                  productoModel.productoUpdated = decodedData["result"][j]['subsidiary_good_updated'];
                  productoModel.productoStatus = decodedData["result"][j]['subsidiary_good_status'];

                  var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][j]['id_subsidiarygood']);

                  if (productList.length > 0) {
                    productoModel.productoFavourite = productList[0].productoFavourite;
                  } else {
                    productoModel.productoFavourite = '0';
                  }
                  //insertar a la tabla Producto
                  await productoDatabase.insertarProducto(productoModel);

                  //BienesModel
                  BienesModel goodmodel = BienesModel();
                  goodmodel.idGood = decodedData["result"][j]['id_good'];
                  goodmodel.goodName = decodedData["result"][j]['good_name'];
                  goodmodel.goodSynonyms = decodedData["result"][j]['good_synonyms'];

                  await goodDb.insertarGood(goodmodel);

                  //Subsidiary
                  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                  subsidiaryModel.idSubsidiary = decodedData["result"][j]['id_subsidiary'];
                  subsidiaryModel.idCompany = decodedData["result"][j]['id_company'];
                  subsidiaryModel.subsidiaryName = decodedData["result"][j]['subsidiary_name'];
                  subsidiaryModel.subsidiaryAddress = decodedData["result"][j]['subsidiary_address'];
                  subsidiaryModel.subsidiaryCellphone = decodedData["result"][j]['subsidiary_cellphone'];
                  subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][j]['subsidiary_cellphone_2'];
                  subsidiaryModel.subsidiaryEmail = decodedData["result"][j]['subsidiary_email'];
                  subsidiaryModel.subsidiaryCoordX = decodedData["result"][j]['subsidiary_coord_x'];
                  subsidiaryModel.subsidiaryCoordY = decodedData["result"][j]['subsidiary_coord_y'];
                  subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][j]['subsidiary_opening_hours'];
                  subsidiaryModel.subsidiaryPrincipal = decodedData["result"][j]['subsidiary_principal'];
                  subsidiaryModel.subsidiaryStatus = decodedData["result"][j]['subsidiary_status'];
                  subsidiaryModel.subsidiaryImg = decodedData["result"][j]['subsidiary_img'];

                  final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][j]['id_subsidiary']);

                  if (listSubsidiaryDb.length > 0) {
                    subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                  } else {
                    subsidiaryModel.subsidiaryFavourite = '0';
                  }

                  //listSucursal.add(subsidiaryModel);
                  //insertar a la tabla sucursal
                  await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                  CompanyModel companyModel = CompanyModel();
                  companyModel.idCompany = decodedData["result"][j]['id_company'];
                  companyModel.idUser = decodedData["result"][j]['id_user'];
                  companyModel.idCity = decodedData["result"][j]['id_city'];
                  companyModel.idCategory = decodedData["result"][j]['id_category'];
                  companyModel.companyName = decodedData["result"][j]['company_name'];
                  companyModel.companyRuc = decodedData["result"][j]['company_ruc'];
                  companyModel.companyImage = decodedData["result"][j]['company_image'];
                  companyModel.companyType = decodedData["result"][j]['company_type'];
                  companyModel.companyShortcode = decodedData["result"][j]['company_shortcode'];
                  companyModel.companyDelivery = decodedData["result"][j]['company_delivery'];
                  companyModel.companyEntrega = decodedData["result"][j]['company_entrega'];
                  companyModel.companyTarjeta = decodedData["result"][j]['company_tarjeta'];
                  companyModel.companyVerified = decodedData["result"][j]['company_verified'];
                  companyModel.companyRating = decodedData["result"][j]['company_rating'];
                  companyModel.companyCreatedAt = decodedData["result"][j]['company_created_at'];
                  companyModel.companyJoin = decodedData["result"][j]['company_join'];
                  companyModel.companyStatus = decodedData["result"][j]['company_status'];
                  companyModel.companyMt = decodedData["result"][j]['company_mt'];
                  companyModel.idCountry = decodedData["result"][j]['id_country'];
                  companyModel.cityName = decodedData["result"][j]['city_name'];
                  companyModel.distancia = decodedData["result"][j]['distancia'];

                  //insertar a la tabla de Company
                  await companyDb.insertarCompany(companyModel);

                  //Categoria
                  CategoriaModel categ = CategoriaModel();
                  categ.idCategory = decodedData["result"][j]["id_category"];
                  categ.categoryName = decodedData["result"][j]["category_name"];

                  //listCategory.add(categ);
                  await categoryDatabase.insertarCategory(categ, 'busquedaItemsubcategorias');

                  //Subcategoria
                  final subCategoriaModel = SubcategoryModel();
                  subCategoriaModel.idSubcategory = decodedData["result"][j]["id_subcategory"];
                  subCategoriaModel.idCategory = decodedData["result"][j]["id_category"];
                  subCategoriaModel.subcategoryName = decodedData["result"][j]["subcategory_name"];
                  // subCategoriaModel.subcategoryName =decodedData["result"][j].subcategoryName;
                  //listSubCategory.add(subCategoriaModel);
                  await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_itemsubcategory_ws');

                  //ItemSubCategoriaModel
                  ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                  itemSubCategoriaModel.idSubcategory = decodedData["result"][j]['id_subcategory'];
                  itemSubCategoriaModel.idItemsubcategory = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][j]['itemsubcategory_name'];
                  itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][j]['itemsubcategory_img'];

                  //listItemSub.add(itemSubCategoriaModel);
                  await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_itemsubcategory_ws');
                }
              } else {
                //Cuando el tipo de búsqueda es "similar" o "match_against"
                for (var h = 0; h < decodedData["result"].length; h++) {
                  for (var i = 0; i < decodedData["result"][h].length; i++) {
                    //Producto
                    ProductoModel productoModel = ProductoModel();
                    productoModel.idProducto = decodedData["result"][h][i]['id_subsidiarygood'];
                    productoModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    productoModel.idGood = decodedData["result"][h][i]['id_good'];
                    productoModel.idItemsubcategory = decodedData["result"][h][i]['id_itemsubcategory'];
                    productoModel.productoName = decodedData["result"][h][i]['subsidiary_good_name'];
                    productoModel.productoPrice = decodedData["result"][h][i]['subsidiary_good_price'];
                    productoModel.productoCurrency = decodedData["result"][h][i]['subsidiary_good_currency'];
                    productoModel.productoImage = decodedData["result"][h][i]['subsidiary_good_image'];
                    productoModel.productoCharacteristics = decodedData["result"][h][i]['subsidiary_good_characteristics'];
                    productoModel.productoBrand = decodedData["result"][h][i]['subsidiary_good_brand'];
                    productoModel.productoModel = decodedData["result"][h][i]['subsidiary_good_model'];
                    productoModel.productoType = decodedData["result"][h][i]['subsidiary_good_type'];
                    productoModel.productoSize = decodedData["result"][h][i]['subsidiary_good_size'];
                    productoModel.productoStock = decodedData["result"][h][i]['subsidiary_good_stock'];
                    productoModel.productoStockStatus = decodedData["result"][h][i]['subsidiary_good_stock_status'];
                    productoModel.productoMeasure = decodedData["result"][h][i]['subsidiary_good_stock_measure'];
                    productoModel.productoRating = decodedData["result"][h][i]['subsidiary_good_rating'];
                    productoModel.productoUpdated = decodedData["result"][h][i]['subsidiary_good_updated'];
                    productoModel.productoStatus = decodedData["result"][h][i]['subsidiary_good_status'];

                    var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["result"][h][i]['id_subsidiarygood']);

                    if (productList.length > 0) {
                      productoModel.productoFavourite = productList[0].productoFavourite;
                    } else {
                      productoModel.productoFavourite = '0';
                    }
                    //insertar a la tabla Producto
                    await productoDatabase.insertarProducto(productoModel);

                    //BienesModel
                    BienesModel goodmodel = BienesModel();
                    goodmodel.idGood = decodedData["result"][h][i]['id_good'];
                    goodmodel.goodName = decodedData["result"][h][i]['good_name'];
                    goodmodel.goodSynonyms = decodedData["result"][h][i]['good_synonyms'];

                    await goodDb.insertarGood(goodmodel);

                    //Subsidiary
                    SubsidiaryModel subsidiaryModel = SubsidiaryModel();
                    subsidiaryModel.idSubsidiary = decodedData["result"][h][i]['id_subsidiary'];
                    subsidiaryModel.idCompany = decodedData["result"][h][i]['id_company'];
                    subsidiaryModel.subsidiaryName = decodedData["result"][h][i]['subsidiary_name'];
                    subsidiaryModel.subsidiaryAddress = decodedData["result"][h][i]['subsidiary_address'];
                    subsidiaryModel.subsidiaryCellphone = decodedData["result"][h][i]['subsidiary_cellphone'];
                    subsidiaryModel.subsidiaryCellphone2 = decodedData["result"][h][i]['subsidiary_cellphone_2'];
                    subsidiaryModel.subsidiaryEmail = decodedData["result"][h][i]['subsidiary_email'];
                    subsidiaryModel.subsidiaryCoordX = decodedData["result"][h][i]['subsidiary_coord_x'];
                    subsidiaryModel.subsidiaryCoordY = decodedData["result"][h][i]['subsidiary_coord_y'];
                    subsidiaryModel.subsidiaryOpeningHours = decodedData["result"][h][i]['subsidiary_opening_hours'];
                    subsidiaryModel.subsidiaryPrincipal = decodedData["result"][h][i]['subsidiary_principal'];
                    subsidiaryModel.subsidiaryStatus = decodedData["result"][h][i]['subsidiary_status'];
                    subsidiaryModel.subsidiaryImg = decodedData["result"][h][i]['subsidiary_img'];

                    final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["result"][h][i]['id_subsidiary']);

                    if (listSubsidiaryDb.length > 0) {
                      subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
                    } else {
                      subsidiaryModel.subsidiaryFavourite = '0';
                    }

                    await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

                    CompanyModel companyModel = CompanyModel();
                    companyModel.idCompany = decodedData["result"][h][i]['id_company'];
                    companyModel.idUser = decodedData["result"][h][i]['id_user'];
                    companyModel.idCity = decodedData["result"][h][i]['id_city'];
                    companyModel.idCategory = decodedData["result"][h][i]['id_category'];
                    companyModel.companyName = decodedData["result"][h][i]['company_name'];
                    companyModel.companyRuc = decodedData["result"][h][i]['company_ruc'];
                    companyModel.companyImage = decodedData["result"][h][i]['company_image'];
                    companyModel.companyType = decodedData["result"][h][i]['company_type'];
                    companyModel.companyShortcode = decodedData["result"][h][i]['company_shortcode'];
                    companyModel.companyDelivery = decodedData["result"][h][i]['company_delivery'];
                    companyModel.companyEntrega = decodedData["result"][h][i]['company_entrega'];
                    companyModel.companyTarjeta = decodedData["result"][h][i]['company_tarjeta'];
                    companyModel.companyVerified = decodedData["result"][h][i]['company_verified'];
                    companyModel.companyRating = decodedData["result"][h][i]['company_rating'];
                    companyModel.companyCreatedAt = decodedData["result"][h][i]['company_created_at'];
                    companyModel.companyJoin = decodedData["result"][h][i]['company_join'];
                    companyModel.companyStatus = decodedData["result"][h][i]['company_status'];
                    companyModel.companyMt = decodedData["result"][h][i]['company_mt'];
                    companyModel.idCountry = decodedData["result"][h][i]['id_country'];
                    companyModel.cityName = decodedData["result"][h][i]['city_name'];
                    companyModel.distancia = decodedData["result"][h][i]['distancia'];

                    //insertar a la tabla de Company
                    await companyDb.insertarCompany(companyModel);

                    //Categoria
                    CategoriaModel categ = CategoriaModel();
                    categ.idCategory = decodedData["result"][h][i]["id_category"];
                    categ.categoryName = decodedData["result"][h][i]["category_name"];

                    //listCategory.add(categ);
                    await categoryDatabase.insertarCategory(categ, 'busquedaItemsubcategorias');

                    //Subcategoria
                    final subCategoriaModel = SubcategoryModel();
                    subCategoriaModel.idSubcategory = decodedData["result"][h][i]["id_subcategory"];
                    subCategoriaModel.idCategory = decodedData["result"][h][i]["id_category"];
                    subCategoriaModel.subcategoryName = decodedData["result"][h][i]["subcategory_name"];
                    // subCategoriaModel.subcategoryName =decodedData["result"][h][i].subcategoryName;
                    // listSubCategory.add(subCategoriaModel);
                    await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_itemsubcategory_ws');

                    //ItemSubCategoriaModel
                    ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
                    itemSubCategoriaModel.idSubcategory = decodedData["result"][h][i]['id_subcategory'];
                    itemSubCategoriaModel.idItemsubcategory = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryName = decodedData["result"][h][i]['itemsubcategory_name'];
                    itemSubCategoriaModel.itemsubcategoryImage = decodedData["result"][h][i]['itemsubcategory_img'];

                    //listItemSub.add(itemSubCategoriaModel);
                    await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_itemsubcategory_ws');
                  }
                }
              }
            }
            return 0;
          }
        } else {
          print("No haaaay productoooo");
        }
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    //return listGeneral;
    return 0;
  }

//-------------------Por Sucursal-------------------------------------
  Future<List<ProductoModel>> busquedaXSucursal(String idSucursal, String query) async {
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_bs_por_sucursal"), body: {
        'id': '$idSucursal',
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });

      final List<ProductoModel> listGeneral = [];
      final decodedData = json.decode(res.body);

      if (decodedData["productos"].length > 0) {
        for (var j = 0; j < decodedData["productos"].length; j++) {
          //Producto
          ProductoModel productoModel = ProductoModel();
          productoModel.idProducto = decodedData["productos"][j]['id_subsidiarygood'];
          productoModel.idSubsidiary = decodedData["productos"][j]['id_subsidiary'];
          productoModel.idGood = decodedData["productos"][j]['id_good'];
          productoModel.idItemsubcategory = decodedData["productos"][j]['id_itemsubcategory'];
          productoModel.productoName = decodedData["productos"][j]['subsidiary_good_name'];
          productoModel.productoPrice = decodedData["productos"][j]['subsidiary_good_price'];
          productoModel.productoCurrency = decodedData["productos"][j]['subsidiary_good_currency'];
          productoModel.productoImage = decodedData["productos"][j]['subsidiary_good_image'];
          productoModel.productoCharacteristics = decodedData["productos"][j]['subsidiary_good_characteristics'];
          productoModel.productoBrand = decodedData["productos"][j]['subsidiary_good_brand'];
          productoModel.productoModel = decodedData["productos"][j]['subsidiary_good_model'];
          productoModel.productoType = decodedData["productos"][j]['subsidiary_good_type'];
          productoModel.productoSize = decodedData["productos"][j]['subsidiary_good_size'];
          productoModel.productoStock = decodedData["productos"][j]['subsidiary_good_stock'];
          productoModel.productoStockStatus = decodedData["productos"][j]['subsidiary_good_stock_status'];
          productoModel.productoMeasure = decodedData["productos"][j]['subsidiary_good_stock_measure'];
          productoModel.productoRating = decodedData["productos"][j]['subsidiary_good_rating'];
          productoModel.productoUpdated = decodedData["productos"][j]['subsidiary_good_updated'];
          productoModel.productoStatus = decodedData["productos"][j]['subsidiary_good_status'];

          var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["productos"][j]['id_subsidiarygood']);

          if (productList.length > 0) {
            productoModel.productoFavourite = productList[0].productoFavourite;
          } else {
            productoModel.productoFavourite = '0';
          }
          //insertar a la tabla Producto
          await productoDatabase.insertarProducto(productoModel);

          listGeneral.add(productoModel);

          //BienesModel
          BienesModel goodmodel = BienesModel();
          goodmodel.idGood = decodedData["productos"][j]['id_good'];
          goodmodel.goodName = decodedData["productos"][j]['good_name'];
          goodmodel.goodSynonyms = decodedData["productos"][j]['good_synonyms'];

          await goodDb.insertarGood(goodmodel);

          //Subsidiary
          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = decodedData["productos"][j]['id_subsidiary'];
          subsidiaryModel.idCompany = decodedData["productos"][j]['id_company'];
          subsidiaryModel.subsidiaryName = decodedData["productos"][j]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress = decodedData["productos"][j]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone = decodedData["productos"][j]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 = decodedData["productos"][j]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail = decodedData["productos"][j]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX = decodedData["productos"][j]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY = decodedData["productos"][j]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours = decodedData["productos"][j]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal = decodedData["productos"][j]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus = decodedData["productos"][j]['subsidiary_status'];
          subsidiaryModel.subsidiaryImg = decodedData["productos"][j]['subsidiary_img'];

          final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["productos"][j]['id_subsidiary']);

          if (listSubsidiaryDb.length > 0) {
            subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
          } else {
            subsidiaryModel.subsidiaryFavourite = '0';
          }

          //listSucursal.add(subsidiaryModel);
          //insertar a la tabla sucursal
          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = decodedData["productos"][j]['id_company'];
          companyModel.idUser = decodedData["productos"][j]['id_user'];
          companyModel.idCity = decodedData["productos"][j]['id_city'];
          companyModel.idCategory = decodedData["productos"][j]['id_category'];
          companyModel.companyName = decodedData["productos"][j]['company_name'];
          companyModel.companyRuc = decodedData["productos"][j]['company_ruc'];
          companyModel.companyImage = decodedData["productos"][j]['company_image'];
          companyModel.companyType = decodedData["productos"][j]['company_type'];
          companyModel.companyShortcode = decodedData["productos"][j]['company_shortcode'];
          companyModel.companyDelivery = decodedData["productos"][j]['company_delivery'];
          companyModel.companyEntrega = decodedData["productos"][j]['company_entrega'];
          companyModel.companyTarjeta = decodedData["productos"][j]['company_tarjeta'];
          companyModel.companyVerified = decodedData["productos"][j]['company_verified'];
          companyModel.companyRating = decodedData["productos"][j]['company_rating'];
          companyModel.companyCreatedAt = decodedData["productos"][j]['company_created_at'];
          companyModel.companyJoin = decodedData["productos"][j]['company_join'];
          companyModel.companyStatus = decodedData["productos"][j]['company_status'];
          companyModel.companyMt = decodedData["productos"][j]['company_mt'];
          companyModel.idCountry = decodedData["productos"][j]['id_country'];
          companyModel.cityName = decodedData["productos"][j]['city_name'];
          companyModel.distancia = decodedData["productos"][j]['distancia'];

          //insertar a la tabla de Company
          await companyDb.insertarCompany(companyModel);

          //Subcategoria
          final subCategoriaModel = SubcategoryModel();
          subCategoriaModel.idSubcategory = decodedData["productos"][j]["id_subcategory"];
          subCategoriaModel.idCategory = decodedData["productos"][j]["id_category"];
          subCategoriaModel.subcategoryName = decodedData["productos"][j]["subcategory_name"];
          // subCategoriaModel.subcategoryName =decodedData["productos"][j].subcategoryName;
          //listSubCategory.add(subCategoriaModel);
          await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_bs_por_sucursal');

          //ItemSubCategoriaModel
          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idSubcategory = decodedData["productos"][j]['id_subcategory'];
          itemSubCategoriaModel.idItemsubcategory = decodedData["productos"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryName = decodedData["productos"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = decodedData["productos"][j]['itemsubcategory_img'];

          //listItemSub.add(itemSubCategoriaModel);
          await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_bs_por_sucursal');
        }
      } else if (decodedData["servicios"].length > 0) {
        for (var j = 0; j < decodedData["servicios"].length; j++) {
          final subsidiaryServiceModel = SubsidiaryServiceModel();
          subsidiaryServiceModel.idSubsidiaryservice = decodedData["servicios"][j]['id_subsidiaryservice'];
          subsidiaryServiceModel.idSubsidiary = decodedData["servicios"][j]['id_subsidiary'];
          subsidiaryServiceModel.idService = decodedData["servicios"][j]['id_service'];
          subsidiaryServiceModel.idItemsubcategory = decodedData["servicios"][j]['id_itemsubcategory'];
          subsidiaryServiceModel.subsidiaryServiceName = decodedData["servicios"][j]['subsidiary_service_name'];
          subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["servicios"][j]['subsidiary_service_description'];
          subsidiaryServiceModel.subsidiaryServicePrice = decodedData["servicios"][j]['subsidiary_service_price'];
          subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["servicios"][j]['subsidiary_service_currency'];
          subsidiaryServiceModel.subsidiaryServiceImage = decodedData["servicios"][j]['subsidiary_service_image'];
          subsidiaryServiceModel.subsidiaryServiceRating = decodedData["servicios"][j]['subsidiary_service_rating'];
          subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["servicios"][j]['subsidiary_service_updated'];
          subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["servicios"][j]['subsidiary_service_status'];

          ///listSubServicio.add(subsidiaryServiceModel);
          final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["servicios"][j]['id_subsidiaryservice']);

          if (list.length > 0) {
            subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
            //Subsidiary
          } else {
            subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
          }
          await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

          //Service
          final servicemodel = ServiciosModel();
          servicemodel.idService = decodedData["servicios"][j]['id_service'];
          servicemodel.serviceName = decodedData["servicios"][j]['service_name'];
          servicemodel.serviceSynonyms = decodedData["servicios"][j]['service_synonyms'];
          //listService.add(servicemodel);
          await serviceDatabase.insertarService(servicemodel);

          //Sucursal
          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = decodedData["servicios"][j]['id_subsidiary'];
          subsidiaryModel.idCompany = decodedData["servicios"][j]['id_company'];
          subsidiaryModel.subsidiaryName = decodedData["servicios"][j]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress = decodedData["servicios"][j]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone = decodedData["servicios"][j]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 = decodedData["servicios"][j]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail = decodedData["servicios"][j]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX = decodedData["servicios"][j]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY = decodedData["servicios"][j]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours = decodedData["servicios"][j]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal = decodedData["servicios"][j]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus = decodedData["servicios"][j]['subsidiary_status'];
          subsidiaryModel.subsidiaryImg = decodedData["servicios"][j]['subsidiary_img'];
          final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["servicios"][j]['id_subsidiary']);

          if (listSubsidiaryDb.length > 0) {
            subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
          } else {
            subsidiaryModel.subsidiaryFavourite = '0';
          }

          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = decodedData["servicios"][j]['id_company'];
          companyModel.idUser = decodedData["servicios"][j]['id_user'];
          companyModel.idCity = decodedData["servicios"][j]['id_city'];
          companyModel.idCategory = decodedData["servicios"][j]['id_category'];
          companyModel.companyName = decodedData["servicios"][j]['company_name'];
          companyModel.companyRuc = decodedData["servicios"][j]['company_ruc'];
          companyModel.companyImage = decodedData["servicios"][j]['company_image'];
          companyModel.companyType = decodedData["servicios"][j]['company_type'];
          companyModel.companyShortcode = decodedData["servicios"][j]['company_shortcode'];
          companyModel.companyDelivery = decodedData["servicios"][j]['company_delivery'];
          companyModel.companyEntrega = decodedData["servicios"][j]['company_entrega'];
          companyModel.companyTarjeta = decodedData["servicios"][j]['company_tarjeta'];
          companyModel.companyVerified = decodedData["servicios"][j]['company_verified'];
          companyModel.companyRating = decodedData["servicios"][j]['company_rating'];
          companyModel.companyCreatedAt = decodedData["servicios"][j]['company_created_at'];
          companyModel.companyJoin = decodedData["servicios"][j]['company_join'];
          companyModel.companyStatus = decodedData["servicios"][j]['company_status'];
          companyModel.companyMt = decodedData["servicios"][j]['company_mt'];
          companyModel.idCountry = decodedData["servicios"][j]['id_country'];
          companyModel.cityName = decodedData["servicios"][j]['city_name'];
          companyModel.distancia = decodedData["servicios"][j]['distancia'];

          //insertar a la tabla de Company
          await companyDb.insertarCompany(companyModel);

          //Subcategoria
          final subCategoriaModel = SubcategoryModel();
          subCategoriaModel.idSubcategory = decodedData["servicios"][j]["id_subcategory"];
          subCategoriaModel.idCategory = decodedData["servicios"][j]["id_category"];
          subCategoriaModel.subcategoryName = decodedData["servicios"][j]["subcategory_name"];
          // subCategoriaModel.subcategoryName =decodedData["servicios"][j].subcategoryName;
          //listSubCategory.add(subCategoriaModel);
          await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_bs_por_sucursal');

          //ItemSubCategoriaModel
          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idSubcategory = decodedData["servicios"][j]['id_subcategory'];
          itemSubCategoriaModel.idItemsubcategory = decodedData["servicios"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryName = decodedData["servicios"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = decodedData["servicios"][j]['itemsubcategory_img'];

          //listItemSub.add(itemSubCategoriaModel);
          await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_bs_por_sucursal');
        }
      }

      return listGeneral;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return [];
    }
    //return
  }

  Future<List<BienesServiciosModel>> busquedaDeProductosYServiciosPorIdItemsubcat(String idItemsubcategory, String query) async {
    try {
      final res = await http.post(Uri.parse("$apiBaseURL/api/Negocio/buscar_bs_por_itemsubcategory"), body: {
        'id': '$idItemsubcategory',
        'buscar': '$query',
        'id_ciudad': '1',
        'limite_sup_bienes': '0',
        'limite_inf_bienes': '0',
        'limite_sup_servicios': '0',
        'limite_inf_servicios': '0',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });
      final decodedData = json.decode(res.body);

      final List<BienesServiciosModel> listGeneral = [];

      if (decodedData["productos"].length > 0) {
        for (var j = 0; j < decodedData["productos"].length; j++) {
          //Producto
          ProductoModel productoModel = ProductoModel();
          productoModel.idProducto = decodedData["productos"][j]['id_subsidiarygood'];
          productoModel.idSubsidiary = decodedData["productos"][j]['id_subsidiary'];
          productoModel.idGood = decodedData["productos"][j]['id_good'];
          productoModel.idItemsubcategory = decodedData["productos"][j]['id_itemsubcategory'];
          productoModel.productoName = decodedData["productos"][j]['subsidiary_good_name'];
          productoModel.productoPrice = decodedData["productos"][j]['subsidiary_good_price'];
          productoModel.productoCurrency = decodedData["productos"][j]['subsidiary_good_currency'];
          productoModel.productoImage = decodedData["productos"][j]['subsidiary_good_image'];
          productoModel.productoCharacteristics = decodedData["productos"][j]['subsidiary_good_characteristics'];
          productoModel.productoBrand = decodedData["productos"][j]['subsidiary_good_brand'];
          productoModel.productoModel = decodedData["productos"][j]['subsidiary_good_model'];
          productoModel.productoType = decodedData["productos"][j]['subsidiary_good_type'];
          productoModel.productoSize = decodedData["productos"][j]['subsidiary_good_size'];
          productoModel.productoStock = decodedData["productos"][j]['subsidiary_good_stock'];
          productoModel.productoStockStatus = decodedData["productos"][j]['subsidiary_good_stock_status'];
          productoModel.productoMeasure = decodedData["productos"][j]['subsidiary_good_stock_measure'];
          productoModel.productoRating = decodedData["productos"][j]['subsidiary_good_rating'];
          productoModel.productoUpdated = decodedData["productos"][j]['subsidiary_good_updated'];
          productoModel.productoStatus = decodedData["productos"][j]['subsidiary_good_status'];

          var productList = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(decodedData["productos"][j]['id_subsidiarygood']);

          if (productList.length > 0) {
            productoModel.productoFavourite = productList[0].productoFavourite;
          } else {
            productoModel.productoFavourite = '0';
          }
          //insertar a la tabla Producto
          await productoDatabase.insertarProducto(productoModel);

          BienesServiciosModel bienesServiciosModel = BienesServiciosModel();
          bienesServiciosModel.idSubsidiarygood = productoModel.idProducto;
          bienesServiciosModel.idGood = productoModel.idGood;
          bienesServiciosModel.idItemsubcategory = productoModel.idItemsubcategory;
          bienesServiciosModel.subsidiaryGoodName = productoModel.productoName;
          bienesServiciosModel.idSubsidiary = productoModel.idSubsidiary;
          bienesServiciosModel.subsidiaryGoodPrice = productoModel.productoPrice;
          bienesServiciosModel.subsidiaryGoodCurrency = productoModel.productoCurrency;
          bienesServiciosModel.subsidiaryGoodImage = productoModel.productoImage;
          bienesServiciosModel.subsidiaryGoodCharacteristics = productoModel.productoCharacteristics;
          bienesServiciosModel.subsidiaryGoodCurrency = productoModel.productoCurrency;
          bienesServiciosModel.subsidiaryGoodBrand = productoModel.productoBrand;
          bienesServiciosModel.subsidiaryGoodModel = productoModel.productoModel;
          bienesServiciosModel.subsidiaryGoodType = productoModel.productoType;
          bienesServiciosModel.subsidiaryGoodSize = productoModel.productoSize;
          bienesServiciosModel.subsidiaryGoodStock = productoModel.productoStock;
          bienesServiciosModel.subsidiaryGoodMeasure = productoModel.productoMeasure;
          bienesServiciosModel.subsidiaryGoodRating = productoModel.productoRating;
          bienesServiciosModel.subsidiaryServiceUpdated = productoModel.productoUpdated;
          bienesServiciosModel.subsidiaryGoodStatus = productoModel.productoStatus;
          bienesServiciosModel.subsidiaryGoodFavourite = productoModel.productoFavourite;
          bienesServiciosModel.tipo = 'producto';

          listGeneral.add(bienesServiciosModel);

          //BienesModel
          BienesModel goodmodel = BienesModel();
          goodmodel.idGood = decodedData["productos"][j]['id_good'];
          goodmodel.goodName = decodedData["productos"][j]['good_name'];
          goodmodel.goodSynonyms = decodedData["productos"][j]['good_synonyms'];

          await goodDb.insertarGood(goodmodel);

          //Subsidiary
          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = decodedData["productos"][j]['id_subsidiary'];
          subsidiaryModel.idCompany = decodedData["productos"][j]['id_company'];
          subsidiaryModel.subsidiaryName = decodedData["productos"][j]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress = decodedData["productos"][j]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone = decodedData["productos"][j]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 = decodedData["productos"][j]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail = decodedData["productos"][j]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX = decodedData["productos"][j]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY = decodedData["productos"][j]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours = decodedData["productos"][j]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal = decodedData["productos"][j]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus = decodedData["productos"][j]['subsidiary_status'];
          subsidiaryModel.subsidiaryImg = decodedData["productos"][j]['subsidiary_img'];

          final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["productos"][j]['id_subsidiary']);

          if (listSubsidiaryDb.length > 0) {
            subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
          } else {
            subsidiaryModel.subsidiaryFavourite = '0';
          }

          //listSucursal.add(subsidiaryModel);
          //insertar a la tabla sucursal
          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = decodedData["productos"][j]['id_company'];
          companyModel.idUser = decodedData["productos"][j]['id_user'];
          companyModel.idCity = decodedData["productos"][j]['id_city'];
          companyModel.idCategory = decodedData["productos"][j]['id_category'];
          companyModel.companyName = decodedData["productos"][j]['company_name'];
          companyModel.companyRuc = decodedData["productos"][j]['company_ruc'];
          companyModel.companyImage = decodedData["productos"][j]['company_image'];
          companyModel.companyType = decodedData["productos"][j]['company_type'];
          companyModel.companyShortcode = decodedData["productos"][j]['company_shortcode'];
          companyModel.companyDelivery = decodedData["productos"][j]['company_delivery'];
          companyModel.companyEntrega = decodedData["productos"][j]['company_entrega'];
          companyModel.companyTarjeta = decodedData["productos"][j]['company_tarjeta'];
          companyModel.companyVerified = decodedData["productos"][j]['company_verified'];
          companyModel.companyRating = decodedData["productos"][j]['company_rating'];
          companyModel.companyCreatedAt = decodedData["productos"][j]['company_created_at'];
          companyModel.companyJoin = decodedData["productos"][j]['company_join'];
          companyModel.companyStatus = decodedData["productos"][j]['company_status'];
          companyModel.companyMt = decodedData["productos"][j]['company_mt'];
          companyModel.idCountry = decodedData["productos"][j]['id_country'];
          companyModel.cityName = decodedData["productos"][j]['city_name'];
          companyModel.distancia = decodedData["productos"][j]['distancia'];

          //insertar a la tabla de Company
          await companyDb.insertarCompany(companyModel);

          //Subcategoria
          final subCategoriaModel = SubcategoryModel();
          subCategoriaModel.idSubcategory = decodedData["productos"][j]["id_subcategory"];
          subCategoriaModel.idCategory = decodedData["productos"][j]["id_category"];
          subCategoriaModel.subcategoryName = decodedData["productos"][j]["subcategory_name"];
          // subCategoriaModel.subcategoryName =decodedData["productos"][j].subcategoryName;
          //listSubCategory.add(subCategoriaModel);
          await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_bs_por_sucursal');

          //ItemSubCategoriaModel
          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idSubcategory = decodedData["productos"][j]['id_subcategory'];
          itemSubCategoriaModel.idItemsubcategory = decodedData["productos"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryName = decodedData["productos"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = decodedData["productos"][j]['itemsubcategory_img'];

          //listItemSub.add(itemSubCategoriaModel);
          await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_bs_por_sucursal');
        }
      } else if (decodedData["servicios"].length > 0) {
        for (var j = 0; j < decodedData["servicios"].length; j++) {
          final subsidiaryServiceModel = SubsidiaryServiceModel();
          subsidiaryServiceModel.idSubsidiaryservice = decodedData["servicios"][j]['id_subsidiaryservice'];
          subsidiaryServiceModel.idSubsidiary = decodedData["servicios"][j]['id_subsidiary'];
          subsidiaryServiceModel.idService = decodedData["servicios"][j]['id_service'];
          subsidiaryServiceModel.idItemsubcategory = decodedData["servicios"][j]['id_itemsubcategory'];
          subsidiaryServiceModel.subsidiaryServiceName = decodedData["servicios"][j]['subsidiary_service_name'];
          subsidiaryServiceModel.subsidiaryServiceDescription = decodedData["servicios"][j]['subsidiary_service_description'];
          subsidiaryServiceModel.subsidiaryServicePrice = decodedData["servicios"][j]['subsidiary_service_price'];
          subsidiaryServiceModel.subsidiaryServiceCurrency = decodedData["servicios"][j]['subsidiary_service_currency'];
          subsidiaryServiceModel.subsidiaryServiceImage = decodedData["servicios"][j]['subsidiary_service_image'];
          subsidiaryServiceModel.subsidiaryServiceRating = decodedData["servicios"][j]['subsidiary_service_rating'];
          subsidiaryServiceModel.subsidiaryServiceUpdated = decodedData["servicios"][j]['subsidiary_service_updated'];
          subsidiaryServiceModel.subsidiaryServiceStatus = decodedData["servicios"][j]['subsidiary_service_status'];

          ///listSubServicio.add(subsidiaryServiceModel);
          final list = await subisdiaryServiceDatabase.obtenerServiciosPorIdSucursalService(decodedData["servicios"][j]['id_subsidiaryservice']);

          if (list.length > 0) {
            subsidiaryServiceModel.subsidiaryServiceFavourite = list[0].subsidiaryServiceFavourite;
            //Subsidiary
          } else {
            subsidiaryServiceModel.subsidiaryServiceFavourite = "0";
          }
          await subisdiaryServiceDatabase.insertarSubsidiaryService(subsidiaryServiceModel);

          BienesServiciosModel bienesServiciosModel = BienesServiciosModel();
          bienesServiciosModel.idSubsidiaryservice = subsidiaryServiceModel.idSubsidiaryservice;
          bienesServiciosModel.idService = subsidiaryServiceModel.idService;
          bienesServiciosModel.subsidiaryServiceName = subsidiaryServiceModel.subsidiaryServiceName;
          bienesServiciosModel.subsidiaryServiceDescription = subsidiaryServiceModel.subsidiaryServiceDescription;
          bienesServiciosModel.subsidiaryServicePrice = subsidiaryServiceModel.subsidiaryServicePrice;
          bienesServiciosModel.subsidiaryServiceCurrency = subsidiaryServiceModel.subsidiaryServiceCurrency;
          bienesServiciosModel.subsidiaryServiceImage = subsidiaryServiceModel.subsidiaryServiceImage;
          bienesServiciosModel.subsidiaryServiceRating = subsidiaryServiceModel.subsidiaryServiceRating;
          bienesServiciosModel.subsidiaryServiceUpdated = subsidiaryServiceModel.subsidiaryServiceUpdated;
          bienesServiciosModel.subsidiaryServiceStatus = subsidiaryServiceModel.subsidiaryServiceStatus;
          bienesServiciosModel.subsidiaryServiceFavourite = subsidiaryServiceModel.subsidiaryServiceFavourite;
          bienesServiciosModel.tipo = 'services';

          listGeneral.add(bienesServiciosModel);

          //Service
          final servicemodel = ServiciosModel();
          servicemodel.idService = decodedData["servicios"][j]['id_service'];
          servicemodel.serviceName = decodedData["servicios"][j]['service_name'];
          servicemodel.serviceSynonyms = decodedData["servicios"][j]['service_synonyms'];
          //listService.add(servicemodel);
          await serviceDatabase.insertarService(servicemodel);

          //Sucursal
          SubsidiaryModel subsidiaryModel = SubsidiaryModel();
          subsidiaryModel.idSubsidiary = decodedData["servicios"][j]['id_subsidiary'];
          subsidiaryModel.idCompany = decodedData["servicios"][j]['id_company'];
          subsidiaryModel.subsidiaryName = decodedData["servicios"][j]['subsidiary_name'];
          subsidiaryModel.subsidiaryAddress = decodedData["servicios"][j]['subsidiary_address'];
          subsidiaryModel.subsidiaryCellphone = decodedData["servicios"][j]['subsidiary_cellphone'];
          subsidiaryModel.subsidiaryCellphone2 = decodedData["servicios"][j]['subsidiary_cellphone_2'];
          subsidiaryModel.subsidiaryEmail = decodedData["servicios"][j]['subsidiary_email'];
          subsidiaryModel.subsidiaryCoordX = decodedData["servicios"][j]['subsidiary_coord_x'];
          subsidiaryModel.subsidiaryCoordY = decodedData["servicios"][j]['subsidiary_coord_y'];
          subsidiaryModel.subsidiaryOpeningHours = decodedData["servicios"][j]['subsidiary_opening_hours'];
          subsidiaryModel.subsidiaryPrincipal = decodedData["servicios"][j]['subsidiary_principal'];
          subsidiaryModel.subsidiaryStatus = decodedData["servicios"][j]['subsidiary_status'];
          subsidiaryModel.subsidiaryImg = decodedData["servicios"][j]['subsidiary_img'];
          final listSubsidiaryDb = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData["servicios"][j]['id_subsidiary']);

          if (listSubsidiaryDb.length > 0) {
            subsidiaryModel.subsidiaryFavourite = listSubsidiaryDb[0].subsidiaryFavourite;
          } else {
            subsidiaryModel.subsidiaryFavourite = '0';
          }

          await subsidiaryDatabase.insertarSubsidiary(subsidiaryModel);

          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = decodedData["servicios"][j]['id_company'];
          companyModel.idUser = decodedData["servicios"][j]['id_user'];
          companyModel.idCity = decodedData["servicios"][j]['id_city'];
          companyModel.idCategory = decodedData["servicios"][j]['id_category'];
          companyModel.companyName = decodedData["servicios"][j]['company_name'];
          companyModel.companyRuc = decodedData["servicios"][j]['company_ruc'];
          companyModel.companyImage = decodedData["servicios"][j]['company_image'];
          companyModel.companyType = decodedData["servicios"][j]['company_type'];
          companyModel.companyShortcode = decodedData["servicios"][j]['company_shortcode'];
          companyModel.companyDelivery = decodedData["servicios"][j]['company_delivery'];
          companyModel.companyEntrega = decodedData["servicios"][j]['company_entrega'];
          companyModel.companyTarjeta = decodedData["servicios"][j]['company_tarjeta'];
          companyModel.companyVerified = decodedData["servicios"][j]['company_verified'];
          companyModel.companyRating = decodedData["servicios"][j]['company_rating'];
          companyModel.companyCreatedAt = decodedData["servicios"][j]['company_created_at'];
          companyModel.companyJoin = decodedData["servicios"][j]['company_join'];
          companyModel.companyStatus = decodedData["servicios"][j]['company_status'];
          companyModel.companyMt = decodedData["servicios"][j]['company_mt'];
          companyModel.idCountry = decodedData["servicios"][j]['id_country'];
          companyModel.cityName = decodedData["servicios"][j]['city_name'];
          companyModel.distancia = decodedData["servicios"][j]['distancia'];

          //insertar a la tabla de Company
          await companyDb.insertarCompany(companyModel);

          //Subcategoria
          final subCategoriaModel = SubcategoryModel();
          subCategoriaModel.idSubcategory = decodedData["servicios"][j]["id_subcategory"];
          subCategoriaModel.idCategory = decodedData["servicios"][j]["id_category"];
          subCategoriaModel.subcategoryName = decodedData["servicios"][j]["subcategory_name"];
          // subCategoriaModel.subcategoryName =decodedData["servicios"][j].subcategoryName;
          //listSubCategory.add(subCategoriaModel);
          await subcategoryDatabase.insertarSubCategory(subCategoriaModel,'Negocio/buscar_bs_por_sucursal');

          //ItemSubCategoriaModel
          ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
          itemSubCategoriaModel.idSubcategory = decodedData["servicios"][j]['id_subcategory'];
          itemSubCategoriaModel.idItemsubcategory = decodedData["servicios"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryName = decodedData["servicios"][j]['itemsubcategory_name'];
          itemSubCategoriaModel.itemsubcategoryImage = decodedData["servicios"][j]['itemsubcategory_img'];

          //listItemSub.add(itemSubCategoriaModel);
          await itemsubCategoryDatabase.insertarItemSubCategoria(itemSubCategoriaModel, 'Negocio/buscar_bs_por_sucursal');
        }
      }

      return listGeneral;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return [];
    }
    //return listGeneral;
  }
}
