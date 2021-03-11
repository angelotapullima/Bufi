import 'dart:convert';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
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
import 'package:http/http.dart' as http;

class BusquedaApi {
  final prefs = Preferences();
  final productoDatabase = ProductoDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future<List<BusquedaGeneralModel>> busquedaGeneral(String query) async {
    final listBusquedaGeneralGood = List<BusquedaGeneralModel>();
    try {
      final res = await http.post("$apiBaseURL/api/Negocio/buscar_ws", body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });

      var decodedData = json.decode(res.body);
      print(decodedData);
      //contexto de la busqueda, ejm: good, service, company...
      final context = decodedData["context"];

      //codigo de respuesta del servicio
      final int code = decodedData["code"];

      if (code == 1) {
        if (context != null) {
          //final listBusquedaGeneralGood = List<BusquedaGeneralModel>();
          BusquedaGeneralModel busqGeneralModel = BusquedaGeneralModel();

          final listProducto = List<ProductoModel>();
          final listbienes = List<BienesModel>();
          final listSucursal = List<SubsidiaryModel>();
          final listCompany = List<CompanyModel>();
          final listCategory = List<CategoriaModel>();
          final listSubCategory = List<SubcategoryModel>();
          final listItemSub = List<ItemSubCategoriaModel>();

          final listService = List<ServiciosModel>();
          final listSubService = List<SubsidiaryServiceModel>();

          if (context == "good") {
            for (var i = 0; i < decodedData["result"][0].length; i++) {
              //Producto
              ProductoModel productoModel = ProductoModel();
              productoModel.idProducto =
                  decodedData["result"][0][i]['id_subsidiarygood'];
              productoModel.idSubsidiary =
                  decodedData["result"][0][i]['id_subsidiary'];
              productoModel.idGood = decodedData["result"][0][i]['id_good'];
              productoModel.idItemsubcategory =
                  decodedData["result"][0][i]['id_itemsubcategory'];
              productoModel.productoName =
                  decodedData["result"][0][i]['subsidiary_good_name'];
              productoModel.productoPrice =
                  decodedData["result"][0][i]['subsidiary_good_price'];
              productoModel.productoCurrency =
                  decodedData["result"][0][i]['subsidiary_good_currency'];
              productoModel.productoImage =
                  decodedData["result"][0][i]['subsidiary_good_image'];
              productoModel.productoCharacteristics =
                  decodedData["result"][0][i]['subsidiary_good_characteristics'];
              productoModel.productoBrand =
                  decodedData["result"][0][i]['subsidiary_good_brand'];
              productoModel.productoModel =
                  decodedData["result"][0][i]['subsidiary_good_model'];
              productoModel.productoType =
                  decodedData["result"][0][i]['subsidiary_good_type'];
              productoModel.productoSize =
                  decodedData["result"][0][i]['subsidiary_good_size'];
              productoModel.productoStock =
                  decodedData['subsidiary_good_stock'];
              productoModel.productoStockStatus =
                  decodedData['subsidiary_good_stock_status'];
              productoModel.productoMeasure =
                  decodedData["result"][0][i]['subsidiary_good_stock_measure'];
              productoModel.productoRating =
                  decodedData["result"][0][i]['subsidiary_good_rating'];
              productoModel.productoUpdated =
                  decodedData["result"][0][i]['subsidiary_good_updated'];
              productoModel.productoStatus =
                  decodedData["result"][0][i]['subsidiary_good_status'];

              var productList =
                  await productoDatabase.obtenerProductoPorIdSubsidiaryGood(
                      decodedData["result"][0][i]['id_subsidiarygood']);

              if (productList.length > 0) {
                productoModel.productoFavourite =
                    productList[0].productoFavourite;
              } else {
                productoModel.productoFavourite = '';
              }
              //Añadir a la lista de productos
              listProducto.add(productoModel);

              //BienesModel
              BienesModel goodmodel = BienesModel();
              goodmodel.idGood = decodedData["result"][0][i]['id_good'];
              goodmodel.goodName = decodedData["result"][0][i]['good_name'];
              goodmodel.goodSynonyms =
                  decodedData["result"][0][i]['good_synonyms'];

              listbienes.add(goodmodel);

              //Subsidiary
              SubsidiaryModel subsidiaryModel = SubsidiaryModel();
              subsidiaryModel.idSubsidiary =
                  decodedData["result"][0][i]['id_subsidiary'];
              subsidiaryModel.idCompany =
                  decodedData["result"][0][i]['id_company'];
              subsidiaryModel.subsidiaryName =
                  decodedData["result"][0][i]['subsidiary_name'];
              subsidiaryModel.subsidiaryAddress =
                  decodedData["result"][0][i]['subsidiary_address'];
              subsidiaryModel.subsidiaryCellphone =
                  decodedData["result"][0][i]['subsidiary_cellphone'];
              subsidiaryModel.subsidiaryCellphone2 =
                  decodedData["result"][0][i]['subsidiary_cellphone_2'];
              subsidiaryModel.subsidiaryEmail =
                  decodedData["result"][0][i]['subsidiary_email'];
              subsidiaryModel.subsidiaryCoordX =
                  decodedData["result"][0][i]['subsidiary_coord_x'];
              subsidiaryModel.subsidiaryCoordY =
                  decodedData["result"][0][i]['subsidiary_coord_y'];
              subsidiaryModel.subsidiaryOpeningHours =
                  decodedData["result"][0][i]['subsidiary_opening_hours'];
              subsidiaryModel.subsidiaryPrincipal =
                  decodedData["result"][0][i]['subsidiary_principal'];
              subsidiaryModel.subsidiaryStatus =
                  decodedData["result"][0][i]['subsidiary_status'];

              final listSubsidiaryDb =
                  await subsidiaryDatabase.obtenerSubsidiaryPorId(
                      decodedData["result"][0][i]['id_subsidiary']);

              if (listSubsidiaryDb.length > 0) {
                subsidiaryModel.subsidiaryFavourite =
                    listSubsidiaryDb[0].subsidiaryFavourite;
              } else {
                subsidiaryModel.subsidiaryFavourite = '0';
              }

              listSucursal.add(subsidiaryModel);

              CompanyModel companyModel = CompanyModel();
              companyModel.idCompany = decodedData["result"][0][i]['id_company'];
              companyModel.idUser = decodedData["result"][0][i]['id_user'];
              companyModel.idCity = decodedData["result"][0][i]['id_city'];
              companyModel.idCategory = decodedData["result"][0][i]['id_category'];
              companyModel.companyName =
                  decodedData["result"][0][i]['company_name'];
              companyModel.companyRuc = decodedData["result"][0][i]['company_ruc'];
              companyModel.companyImage =
                  decodedData["result"][0][i]['company_image'];
              companyModel.companyType =
                  decodedData["result"][0][i]['company_type'];
              companyModel.companyShortcode =
                  decodedData["result"][0][i]['company_shortcode'];
              companyModel.companyDelivery =
                  decodedData["result"][0][i]['company_delivery'];
              companyModel.companyEntrega =
                  decodedData["result"][0][i]['company_entrega'];
              companyModel.companyTarjeta =
                  decodedData["result"][0][i]['company_tarjeta'];
              companyModel.companyVerified =
                  decodedData["result"][0][i]['company_verified'];
              companyModel.companyRating =
                  decodedData["result"][0][i]['company_rating'];
              companyModel.companyCreatedAt =
                  decodedData["result"][0][i]['company_created_at'];
              companyModel.companyJoin =
                  decodedData["result"][0][i]['company_join'];
              companyModel.companyStatus =
                  decodedData["result"][0][i]['company_status'];
              companyModel.companyMt = decodedData["result"][0][i]['company_mt'];
              companyModel.idCity = decodedData["result"][0][i]['id_country'];
              companyModel.cityName = decodedData["result"][0][i]['city_name'];
              companyModel.distancia = decodedData["result"][0][i]['distancia'];

              listCompany.add(companyModel);

              //Categoria
              CategoriaModel categ = CategoriaModel();
              categ.idCategory = decodedData["result"][0][i]["id_category"];
              categ.categoryName = decodedData["result"][0][i]["category_name"];

              listCategory.add(categ);

              //Subcategoria
              final subCategoriaModel = SubcategoryModel();
              subCategoriaModel.idSubcategory =
                  decodedData["result"][0][i]["id_subcategory"];
              subCategoriaModel.idCategory =
                  decodedData["result"][0][i]["id_category"];
              // subCategoriaModel.subcategoryName =decodedData["result"][0][i].subcategoryName;
              listSubCategory.add(subCategoriaModel);

              //ItemSubCategoriaModel
              ItemSubCategoriaModel itemSubCategoriaModel =
                  ItemSubCategoriaModel();
              itemSubCategoriaModel.idSubcategory =
                  decodedData["result"][0][i]['id_subcategory'];
              itemSubCategoriaModel.idItemsubcategory =
                  decodedData["result"][0][i]['itemsubcategory_name'];
              itemSubCategoriaModel.itemsubcategoryName =
                  decodedData["result"][0][i]['itemsubcategory_name'];

              listItemSub.add(itemSubCategoriaModel);
            }

            busqGeneralModel.listBienes = listbienes;
            busqGeneralModel.listProducto = listProducto;
            busqGeneralModel.listSucursal = listSucursal;
            busqGeneralModel.listCompany = listCompany;
            busqGeneralModel.listCategory = listCategory;
            busqGeneralModel.listSubcategory = listSubCategory;
            busqGeneralModel.listItemSubCateg = listItemSub;
          }
          listBusquedaGeneralGood.add(busqGeneralModel);
          //------------Contexto: Servicio------------------------
          if (context == "service") {
            for (var j = 0; j < decodedData["result"].length; j++) {
              final subsidiaryServiceModel = SubsidiaryServiceModel();
              subsidiaryServiceModel.idSubsidiaryservice =
                  decodedData["result"][j]['id_subsidiaryservice'];
              subsidiaryServiceModel.idSubsidiary =
                  decodedData["result"][j]['id_subsidiary'];
              subsidiaryServiceModel.idService =
                  decodedData["result"][j]['id_service'];
              subsidiaryServiceModel.idItemsubcategory =
                  decodedData["result"][j]['id_itemsubcategory'];
              subsidiaryServiceModel.subsidiaryServiceName =
                  decodedData["result"][j]['subsidiary_service_name'];
              subsidiaryServiceModel.subsidiaryServiceDescription =
                  decodedData["result"][j]['subsidiary_service_description'];
              subsidiaryServiceModel.subsidiaryServicePrice =
                  decodedData["result"][j]['subsidiary_service_price'];
              subsidiaryServiceModel.subsidiaryServiceCurrency =
                  decodedData["result"][j]['subsidiary_service_currency'];
              subsidiaryServiceModel.subsidiaryServiceImage =
                  decodedData["result"][j]['subsidiary_service_image'];
              subsidiaryServiceModel.subsidiaryServiceRating =
                  decodedData["result"][j]['subsidiary_service_rating'];
              subsidiaryServiceModel.subsidiaryServiceUpdated =
                  decodedData["result"][j]['subsidiary_service_updated'];
              subsidiaryServiceModel.subsidiaryServiceStatus =
                  decodedData["result"][j]['subsidiary_service_status'];
              listSubService.add(subsidiaryServiceModel);

              //Service
              final servicemodel = ServiciosModel();
              servicemodel.idService = decodedData["result"][j]['id_service'];
              servicemodel.serviceName =
                  decodedData["result"][j]['service_name'];
              servicemodel.serviceSynonyms =
                  decodedData["result"][j]['service_synonyms'];
              listService.add(servicemodel);

              //Sucursal
              SubsidiaryModel subsidiaryModel = SubsidiaryModel();
              subsidiaryModel.idSubsidiary =
                  decodedData["result"][j]['id_subsidiary'];
              subsidiaryModel.idCompany =
                  decodedData["result"][j]['id_company'];
              subsidiaryModel.subsidiaryName =
                  decodedData["result"][j]['subsidiary_name'];
              subsidiaryModel.subsidiaryAddress =
                  decodedData["result"][j]['subsidiary_address'];
              subsidiaryModel.subsidiaryCellphone =
                  decodedData["result"][j]['subsidiary_cellphone'];
              subsidiaryModel.subsidiaryCellphone2 =
                  decodedData["result"][j]['subsidiary_cellphone_2'];
              subsidiaryModel.subsidiaryEmail =
                  decodedData["result"][j]['subsidiary_email'];
              subsidiaryModel.subsidiaryCoordX =
                  decodedData["result"][j]['subsidiary_coord_x'];
              subsidiaryModel.subsidiaryCoordY =
                  decodedData["result"][j]['subsidiary_coord_y'];
              subsidiaryModel.subsidiaryOpeningHours =
                  decodedData["result"][j]['subsidiary_opening_hours'];
              subsidiaryModel.subsidiaryPrincipal =
                  decodedData["result"][j]['subsidiary_principal'];
              subsidiaryModel.subsidiaryStatus =
                  decodedData["result"][j]['subsidiary_status'];
            }
          }

          if (context == "company") {
            //company, sucursal, categoria
            print("Estoy trabajando en eso");
          }

          if (context == "category") {
            //company, sucursal, categoria
            print("Estoy trabajando en eso");
          }
        } else {
          print("No se encontró ningún resultado para esta búsqueda");
        }
      }
      print(decodedData["total_results"]);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    
    return listBusquedaGeneralGood;
  }
}
