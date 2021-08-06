import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';

import 'package:rxdart/subjects.dart';

//bloc para llamar a los bienes y Servicios por id_itemsubcteg
class ItemCategoriaBloc {
  final bienApi = GoodApi();
  final servicioApi = ServiceApi();
  final categoriaApi = CategoriasApi();
  final productoDatabase = ProductoDatabase();
  final subServiceDb = SubsidiaryServiceDatabase();

  final _itemcontroller = BehaviorSubject<List<BienesServiciosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();

  Stream<List<BienesServiciosModel>> get itemSubStream => _itemcontroller.stream;
  Stream<bool> get cargandoItemsStream => _cargandoItems.stream;

  void dispose() {
    _itemcontroller?.close();
    _cargandoItems?.close();
  }

  void listarBienesServiciosXIdItemSubcategoria(String id) async {
    _itemcontroller.sink.add(await bienesServiciosPorIdItemSubcategoria(id));
    _cargandoItems.sink.add(true);
    await categoriaApi.obtenerProySerPorIdItemsubcategory(id);
    _cargandoItems.sink.add(false);
    _itemcontroller.sink.add(await bienesServiciosPorIdItemSubcategoria(id));
  }

  Future<List<BienesServiciosModel>> bienesServiciosPorIdItemSubcategoria(String id) async {
    final List<BienesServiciosModel> listGeneral = [];
    final listSubservice = await subServiceDb.obtenerServicioXIdItemSubcategoria(id);
    final listSubgood = await productoDatabase.obtenerProductoXIdItemSubcategoria(id);

    for (var i = 0; i < listSubgood.length; i++) {
      final bienesServiciosModel = BienesServiciosModel();

      //Para Bienes
      bienesServiciosModel.idSubsidiarygood = listSubgood[i].idProducto;
      bienesServiciosModel.idSubsidiary = listSubgood[i].idSubsidiary;
      bienesServiciosModel.idGood = listSubgood[i].idGood;
      bienesServiciosModel.idItemsubcategory = listSubgood[i].idItemsubcategory;
      bienesServiciosModel.subsidiaryGoodName = listSubgood[i].productoName;
      bienesServiciosModel.subsidiaryGoodPrice = listSubgood[i].productoPrice;
      bienesServiciosModel.subsidiaryGoodCurrency = listSubgood[i].productoCurrency;
      bienesServiciosModel.subsidiaryGoodImage = listSubgood[i].productoImage;
      bienesServiciosModel.subsidiaryGoodCharacteristics = listSubgood[i].productoCharacteristics;
      bienesServiciosModel.subsidiaryGoodBrand = listSubgood[i].productoBrand;
      bienesServiciosModel.subsidiaryGoodModel = listSubgood[i].productoModel;
      bienesServiciosModel.subsidiaryGoodType = listSubgood[i].productoType;
      bienesServiciosModel.subsidiaryGoodSize = listSubgood[i].productoSize;
      bienesServiciosModel.subsidiaryGoodStock = listSubgood[i].productoStock;
      bienesServiciosModel.subsidiaryGoodMeasure = listSubgood[i].productoMeasure;
      bienesServiciosModel.subsidiaryGoodRating = listSubgood[i].productoRating;
      bienesServiciosModel.subsidiaryGoodUpdated = listSubgood[i].productoUpdated;
      bienesServiciosModel.subsidiaryGoodStatus = listSubgood[i].productoStatus;
      bienesServiciosModel.tipo = 'bienes';

      listGeneral.add(bienesServiciosModel);
    }
    //Servicios
    for (var j = 0; j < listSubservice.length; j++) {
      final bienesServiciosModel = BienesServiciosModel();

      bienesServiciosModel.idSubsidiaryservice = listSubservice[j].idSubsidiaryservice;
      bienesServiciosModel.idSubsidiary = listSubservice[j].idSubsidiary;
      bienesServiciosModel.idService = listSubservice[j].idService;
      bienesServiciosModel.subsidiaryServiceName = listSubservice[j].subsidiaryServiceName;
      bienesServiciosModel.subsidiaryServiceDescription = listSubservice[j].subsidiaryServiceDescription;
      bienesServiciosModel.subsidiaryServicePrice = listSubservice[j].subsidiaryServicePrice;
      bienesServiciosModel.subsidiaryServiceCurrency = listSubservice[j].subsidiaryServiceCurrency;
      bienesServiciosModel.subsidiaryServiceImage = listSubservice[j].subsidiaryServiceImage;
      bienesServiciosModel.subsidiaryServiceRating = listSubservice[j].subsidiaryServiceRating;
      bienesServiciosModel.subsidiaryServiceUpdated = listSubservice[j].subsidiaryServiceUpdated;
      bienesServiciosModel.subsidiaryServiceStatus = listSubservice[j].subsidiaryServiceStatus;
      bienesServiciosModel.tipo = 'servicios';

      listGeneral.add(bienesServiciosModel);
    }

    return listGeneral;
  }

  void listarBienesServiciosXIdItemSubcategoriaFiltrado(
      String idItemsubcategory, bool productos, bool services, List<String> tallas, List<String> modelos, List<String> marcas) async {
    bool pasoProdcutos = false;
    final List<BienesServiciosModel> listFinal = [];
    final List<String> listIdSinRepetir = [];
    String consultaTallas = '';
    String consultaMarcas = '';
    String consultaModelos = '';
    listFinal.clear();
    listIdSinRepetir.clear();

    if (productos) {
      if (marcas.length > 0) {
        pasoProdcutos = true;

        for (var x = 0; x < marcas.length; x++) {
          if (x == 0) {
            consultaMarcas += "'${marcas[x]}' ";
          } else {
            consultaMarcas += "or producto_brand = '${marcas[x]}' ";
          }
        }
        String sqlMarcas = 'SELECT * FROM Producto where  producto_brand = $consultaMarcas and id_itemsubcategory="$idItemsubcategory"';

        final productitosMarcas = await productoDatabase.sqlConsulta(sqlMarcas);

        for (var i = 0; i < productitosMarcas.length; i++) {
          listIdSinRepetir.add(productitosMarcas[i].idProducto);
        }
      }

      if (tallas.length > 0) {
        pasoProdcutos = true;
        for (var i = 0; i < tallas.length; i++) {
          if (i == tallas.length - 1) {
            consultaTallas += "'${tallas[i]}' ";
          } else {
            consultaTallas += "or producto_size = ${tallas[i]} ";
          }
        }

        String sqlTallas = 'SELECT * FROM Producto where producto_size  = $consultaTallas and id_itemsubcategory="$idItemsubcategory"';

        final productitosTallas = await productoDatabase.sqlConsulta(sqlTallas);

        for (var i = 0; i < productitosTallas.length; i++) {
          listIdSinRepetir.add(productitosTallas[i].idProducto);
        }
      }

      if (modelos.length > 0) {
        pasoProdcutos = true;
        for (var y = 0; y < modelos.length; y++) {
          if (y == modelos.length - 1) {
            consultaModelos += "'${modelos[y]}' ";
          } else {
            consultaModelos += "or producto_model = '${modelos[y]}' ";
          }
        }

        String sqlModelos = 'SELECT * FROM Producto where producto_model = $consultaModelos and id_itemsubcategory="$idItemsubcategory"';

        final productitosModelo = await productoDatabase.sqlConsulta(sqlModelos);

        for (var i = 0; i < productitosModelo.length; i++) {
          listIdSinRepetir.add(productitosModelo[i].idProducto);
        }
      }

      if (pasoProdcutos) {
        final listGeneral = listIdSinRepetir.toSet().toList();

        for (var i = 0; i < listGeneral.length; i++) {
          final producto = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(listGeneral[i]);

          BienesServiciosModel bienesServiciosModel = BienesServiciosModel();
          bienesServiciosModel.idSubsidiarygood = producto[0].idProducto;
          bienesServiciosModel.idGood = producto[0].idGood;
          bienesServiciosModel.idItemsubcategory = producto[0].idItemsubcategory;
          bienesServiciosModel.subsidiaryGoodName = producto[0].productoName;
          bienesServiciosModel.idSubsidiary = producto[0].idSubsidiary;
          bienesServiciosModel.subsidiaryGoodPrice = producto[0].productoPrice;
          bienesServiciosModel.subsidiaryGoodCurrency = producto[0].productoCurrency;
          bienesServiciosModel.subsidiaryGoodImage = producto[0].productoImage;
          bienesServiciosModel.subsidiaryGoodCharacteristics = producto[0].productoCharacteristics;
          bienesServiciosModel.subsidiaryGoodBrand = producto[0].productoBrand;
          bienesServiciosModel.subsidiaryGoodModel = producto[0].productoModel;
          bienesServiciosModel.subsidiaryGoodType = producto[0].productoType;
          bienesServiciosModel.subsidiaryGoodSize = producto[0].productoSize;
          bienesServiciosModel.subsidiaryGoodStock = producto[0].productoStock;
          bienesServiciosModel.subsidiaryGoodStock = producto[0].productoStock;
          bienesServiciosModel.subsidiaryGoodMeasure = producto[0].productoMeasure;
          bienesServiciosModel.subsidiaryGoodRating = producto[0].productoRating;
          bienesServiciosModel.subsidiaryGoodUpdated = producto[0].productoUpdated;
          bienesServiciosModel.subsidiaryGoodStatus = producto[0].productoStatus;
          bienesServiciosModel.subsidiaryGoodFavourite = producto[0].productoFavourite;
          bienesServiciosModel.tipo = 'bienes';

          listFinal.add(bienesServiciosModel);
        }
      } else {
        final listSubgood = await productoDatabase.obtenerProductoXIdItemSubcategoria(idItemsubcategory);

        for (var i = 0; i < listSubgood.length; i++) {
          final bienesServiciosModel = BienesServiciosModel();

          //Para Bienes
          bienesServiciosModel.idSubsidiarygood = listSubgood[i].idProducto;
          bienesServiciosModel.idSubsidiary = listSubgood[i].idSubsidiary;
          bienesServiciosModel.idGood = listSubgood[i].idGood;
          bienesServiciosModel.idItemsubcategory = listSubgood[i].idItemsubcategory;
          bienesServiciosModel.subsidiaryGoodName = listSubgood[i].productoName;
          bienesServiciosModel.subsidiaryGoodPrice = listSubgood[i].productoPrice;
          bienesServiciosModel.subsidiaryGoodCurrency = listSubgood[i].productoCurrency;
          bienesServiciosModel.subsidiaryGoodImage = listSubgood[i].productoImage;
          bienesServiciosModel.subsidiaryGoodCharacteristics = listSubgood[i].productoCharacteristics;
          bienesServiciosModel.subsidiaryGoodBrand = listSubgood[i].productoBrand;
          bienesServiciosModel.subsidiaryGoodModel = listSubgood[i].productoModel;
          bienesServiciosModel.subsidiaryGoodType = listSubgood[i].productoType;
          bienesServiciosModel.subsidiaryGoodSize = listSubgood[i].productoSize;
          bienesServiciosModel.subsidiaryGoodStock = listSubgood[i].productoStock;
          bienesServiciosModel.subsidiaryGoodMeasure = listSubgood[i].productoMeasure;
          bienesServiciosModel.subsidiaryGoodRating = listSubgood[i].productoRating;
          bienesServiciosModel.subsidiaryGoodUpdated = listSubgood[i].productoUpdated;
          bienesServiciosModel.subsidiaryGoodStatus = listSubgood[i].productoStatus;
          bienesServiciosModel.tipo = 'bienes';

          listFinal.add(bienesServiciosModel);
        }
      }
    }

    if (services) {
      final listSubservice = await subServiceDb.obtenerServicioXIdItemSubcategoria(idItemsubcategory);

      for (var j = 0; j < listSubservice.length; j++) {
        final bienesServiciosModel = BienesServiciosModel();

        bienesServiciosModel.idSubsidiaryservice = listSubservice[j].idSubsidiaryservice;
        bienesServiciosModel.idSubsidiary = listSubservice[j].idSubsidiary;
        bienesServiciosModel.idService = listSubservice[j].idService;
        bienesServiciosModel.subsidiaryServiceName = listSubservice[j].subsidiaryServiceName;
        bienesServiciosModel.subsidiaryServiceDescription = listSubservice[j].subsidiaryServiceDescription;
        bienesServiciosModel.subsidiaryServicePrice = listSubservice[j].subsidiaryServicePrice;
        bienesServiciosModel.subsidiaryServiceCurrency = listSubservice[j].subsidiaryServiceCurrency;
        bienesServiciosModel.subsidiaryServiceImage = listSubservice[j].subsidiaryServiceImage;
        bienesServiciosModel.subsidiaryServiceRating = listSubservice[j].subsidiaryServiceRating;
        bienesServiciosModel.subsidiaryServiceUpdated = listSubservice[j].subsidiaryServiceUpdated;
        bienesServiciosModel.subsidiaryServiceStatus = listSubservice[j].subsidiaryServiceStatus;
        bienesServiciosModel.tipo = 'servicios';

        listFinal.add(bienesServiciosModel);
      }
    }

    _itemcontroller.sink.add(listFinal);
  }
}
