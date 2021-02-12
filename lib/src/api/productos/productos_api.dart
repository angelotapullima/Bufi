import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductosApi {
  final subsidiaryDatabase = SubsidiaryDatabase();
  final productoDatabase = ProductoDatabase();
  final goodDatabase = GoodDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final prefs = Preferences();

  Future<dynamic> listarProductosPorSucursal(String id) async {
    final response = await http
        .post('$apiBaseURL/api/Negocio/listar_productos_por_sucursal', body: {
      'id_sucursal': '$id',
    });

    final decodedData = json.decode(response.body);

    for (var i = 0; i < decodedData.length; i++) {
      //SubsidiaryGoodModel
      ProductoModel productoModel = ProductoModel();
      productoModel.idProducto = decodedData[i]["id_subsidiarygood"];
      productoModel.idSubsidiary = decodedData[i]["id_subsidiary"];
      productoModel.idGood = decodedData[i]["id_good"];
      productoModel.idItemsubcategory = decodedData[i]['id_itemsubcategory'];
      productoModel.productoName = decodedData[i]['subsidiary_good_name'];
      productoModel.productoPrice = decodedData[i]['subsidiary_good_price'];
      productoModel.productoCurrency =
          decodedData[i]['subsidiary_good_currency'];
      productoModel.productoImage = decodedData[i]['subsidiary_good_image'];
      productoModel.productoCharacteristics =
          decodedData[i]['subsidiary_good_characteristics'];
      productoModel.productoBrand = decodedData[i]['subsidiary_good_brand'];
      productoModel.productoModel = decodedData[i]['subsidiary_good_model'];
      productoModel.productoType = decodedData[i]['subsidiary_good_type'];
      productoModel.productoSize = decodedData[i]['subsidiary_good_size'];
      productoModel.productoStock = decodedData[i]['subsidiary_good_stock'];
      productoModel.productoMeasure =
          decodedData[i]['subsidiary_good_stock_measure'];
      productoModel.productoRating = decodedData[i]['subsidiary_good_rating'];
      productoModel.productoUpdated = decodedData[i]['subsidiary_good_updated'];
      productoModel.productoStatus = decodedData[i]['subsidiary_good_status'];

      var productList =
          await productoDatabase.obtenerProductoPorIdSubsidiaryGood(
              decodedData[i]['id_subsidiarygood']);

      if (productList.length > 0) {
        productoModel.productoFavourite = productList[0].productoFavourite;
      } else {
        productoModel.productoFavourite = '';
      }
      await productoDatabase.insertarProducto(productoModel);

      SubsidiaryModel submodel = SubsidiaryModel();
      submodel.idCompany = decodedData[i]["id_company"];
      submodel.idSubsidiary = decodedData[i]["id_subsidiary"];
      submodel.subsidiaryName = decodedData[i]['subsidiary_name'];
      submodel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
      submodel.subsidiaryCellphone = decodedData[i]['subsidiary_cellphone'];
      submodel.subsidiaryCellphone2 = decodedData[i]['subsidiary_cellphone_2'];
      submodel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
      submodel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
      submodel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
      submodel.subsidiaryOpeningHours =
          decodedData[i]['subsidiary_opening_hours'];
      submodel.subsidiaryPrincipal = decodedData[i]['subsidiary_principal'];
      submodel.subsidiaryStatus = decodedData[i]['subsidiary_status'];

      final list = await subsidiaryDatabase
          .obtenerSubsidiaryPorId(decodedData[i]["id_subsidiary"]);

      if (list.length > 0) {
        submodel.subsidiaryFavourite = list[0].subsidiaryFavourite;
        //Subsidiary
      } else {
        submodel.subsidiaryFavourite = "0";
      }

      await subsidiaryDatabase.insertarSubsidiary(submodel);

      //BienesModel
      BienesModel goodmodel = BienesModel();
      goodmodel.idGood = decodedData[i]['id_good'];
      goodmodel.goodName = decodedData[i]['good_name'];
      goodmodel.goodSynonyms = decodedData[i]['good_synonyms'];
      await goodDatabase.insertarGood(goodmodel);

      //ItemSubCategoriaModel
      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      itemSubCategoriaModel.idSubcategory = decodedData[i]['id_subcategory'];
      itemSubCategoriaModel.idItemsubcategory =
          decodedData[i]['itemsubcategory_name'];
      itemSubCategoriaModel.itemsubcategoryName =
          decodedData[i]['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);
    }

    return 0;
  }

  Future<dynamic> detailsProductoPorIdSubsidiaryGood(String id) async {
    try {
      final response = await http
          .post('$apiBaseURL/api/Negocio/listar_detalle_producto', body: {
        'id': '$id',
      });

      final decodedData = json.decode(response.body);
      print(decodedData);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<dynamic> deshabilitarSubsidiaryProducto(String id) async {
    try {
      final response = await http
          .post('$apiBaseURL/api/Negocio/deshabilitar_producto', body: {
        'id_subsidiarygood': '$id','app': 'true',
        'tn': prefs.token,
      });

      final decodedData = json.decode(response.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> guardarProducto(File _image, CompanyModel cmodel,
      BienesModel bienModel, ProductoModel producModel) async {
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Negocio/guardar_producto");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';
    request.fields["id_sucursal"] = producModel.idSubsidiary;
    request.fields["id_good"] = bienModel.idGood;
    request.fields["categoria"] = cmodel.idCategory;
    request.fields["nombre"] = producModel.productoName;
    request.fields["precio"] = producModel.productoPrice;
    request.fields["currency"] = producModel.productoCurrency;
    request.fields["measure"] = producModel.productoMeasure;
    request.fields["marca"] = producModel.productoBrand;
    request.fields["modelo"] = producModel.productoModel;
    request.fields["size"] = producModel.productoSize;
    request.fields["stock"] = producModel.productoStock;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('producto_img', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // print(value);

        final decodedData = json.decode(value);
        final int code = decodedData['result']['code'];

        if (decodedData['result']['code'] == 1) {
          print('amonos');
          return 1;
        } else if (code == 2) {
          return 2;
        } else {
          return code;
        }
      }
     
      );
      
    }
     
    ).catchError((e) {
      print(e);
    });
     return 1;
  }
}
