import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/service_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';

class BienesServiciosBloc {
  final logger = Logger();
  final categoriaApi = CategoriasApi();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  //Bienes
  final goodApi = GoodApi();
  final goodDatabase = GoodDatabase();

  //Servicios
  final serviciosApi = ServiceApi();
  final servicesDatabase = ServiceDatabase();

  final _cargandoController = BehaviorSubject<bool>();

  //----------------RESUMEN BIENES Y SERVICIOS ----------------------

  final bienesController = BehaviorSubject<List<ProductoModel>>();

  final serviciosController = BehaviorSubject<List<SubsidiaryServiceModel>>();

  Stream<List<ProductoModel>> get bienesStream => bienesController.stream;
  Stream<List<SubsidiaryServiceModel>> get serviciosStream =>
      serviciosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

//----------------TODOS LOS BIENES Y SERVICIOS----------------------

  final bienesAllController = BehaviorSubject<List<BienesModel>>();
  final serviciosAllController = BehaviorSubject<List<ServiciosModel>>();

  Stream<List<BienesModel>> get bienesAllStream => bienesAllController.stream;
  Stream<List<ServiciosModel>> get serviciosAllStream =>
      serviciosAllController.stream;

  dispose() {
    bienesController?.close();
    serviciosController?.close();
    bienesAllController?.close();
    serviciosAllController?.close();
    _cargandoController?.close();
  }

  //Obtener los 8 primeros bienes y servicios
  void obtenerBienesServiciosResumen() async {
    bienesController.sink.add(await productoDatabase.obtenerSubsidiaryGood());
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());

    await categoriaApi.obtenerbsResumen();

    bienesController.sink.add(await productoDatabase.obtenerSubsidiaryGood());
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
  }

  /* //Obtener los nombres de todos los bienes y servicios
  void obtenerBienesAll2() async {
    bienesAllController.sink.add(await goodDatabase.obtenerGood());
    await goodApi.obtenerGoodAll();
    bienesAllController.sink.add(await goodDatabase.obtenerGood());
  } */

  void obtenerServiciosAll() async {
    serviciosAllController.sink.add(await servicesDatabase.obtenerService());
    await serviciosApi.obtenerServicesAll();
    serviciosAllController.sink.add(await servicesDatabase.obtenerService());
  }

//Obtener todos los bienes y servicios por ciudad
  void obtenerBienesAllPorCiudad() async {
    bienesController.sink.add(await productoDatabase.obtenerSubsidiaryGood());
    await goodApi.listarBienesAllPorCiudad();
    bienesController.sink.add(await productoDatabase.obtenerSubsidiaryGood());
  }

  void obtenerServiciosAllPorCiudad() async {
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
    await serviciosApi.listarServiciosAllPorCiudad();
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
  }

  void obtenerBienesAllPorCiudadFiltrado(
      List<String> tallas, List<String> modelos, List<String> marcas) async {
    final listFinal = List<ProductoModel>();
    final listIdSinRepetir = List<String>();
    String consultaTallas = '';
    String consultaMarcas = '';
    String consultaModelos = '';
    listFinal.clear();
    listIdSinRepetir.clear();

    if (marcas.length > 0) {
      for (var x = 0; x < marcas.length; x++) {
        if (x == 0) {
          consultaMarcas += "'${marcas[x]}' ";
        } else {
          consultaMarcas += "or producto_brand = '${marcas[x]}' ";
        }
      }
      String sqlMarcas =
          'SELECT * FROM Producto where  producto_brand = $consultaMarcas';

      final productitosMarcas = await productoDatabase.sqlConsulta(sqlMarcas);

      for (var i = 0; i < productitosMarcas.length; i++) {
        listIdSinRepetir.add(productitosMarcas[i].idProducto);
      }
    }

    if (tallas.length > 0) {
      for (var i = 0; i < tallas.length; i++) {
        if (i == tallas.length - 1) {
          consultaTallas += "'${tallas[i]}' ";
        } else {
          consultaTallas += "or producto_size = ${tallas[i]} ";
        }
      }

      String sqlTallas =
          'SELECT * FROM Producto where producto_size  = $consultaTallas ';

      final productitosTallas = await productoDatabase.sqlConsulta(sqlTallas);

      for (var i = 0; i < productitosTallas.length; i++) {
        listIdSinRepetir.add(productitosTallas[i].idProducto);
      }
    }

    if (modelos.length > 0) {
      for (var y = 0; y < modelos.length; y++) {
        if (y == modelos.length - 1) {
          consultaModelos += "'${modelos[y]}' ";
        } else {
          consultaModelos += "or producto_model = '${modelos[y]}' ";
        }
      }




      String sqlModelos =
          'SELECT * FROM Producto where producto_model = $consultaModelos ';

      final productitosModelo = await productoDatabase.sqlConsulta(sqlModelos);

      for (var i = 0; i < productitosModelo.length; i++) {
        listIdSinRepetir.add(productitosModelo[i].idProducto);
      }
    }

   
   

    final listGeneral = listIdSinRepetir.toSet().toList();

    for (var i = 0; i < listGeneral.length; i++) {
      final producto = await productoDatabase
          .obtenerProductoPorIdSubsidiaryGood(listGeneral[i]);

      ProductoModel productoModel = ProductoModel();
      productoModel.idProducto = producto[0].idProducto;
      productoModel.idSubsidiary = producto[0].idSubsidiary;
      productoModel.idGood = producto[0].idGood;
      productoModel.idItemsubcategory = producto[0].idItemsubcategory;
      productoModel.productoName = producto[0].productoName;
      productoModel.productoPrice = producto[0].productoPrice;
      productoModel.productoCurrency = producto[0].productoCurrency;
      productoModel.productoImage = producto[0].productoImage;
      productoModel.productoCharacteristics =
          producto[0].productoCharacteristics;
      productoModel.productoBrand = producto[0].productoBrand;
      productoModel.productoModel = producto[0].productoModel;
      productoModel.productoType = producto[0].productoType;
      productoModel.productoSize = producto[0].productoSize;
      productoModel.productoStock = producto[0].productoStock;
      productoModel.productoMeasure = producto[0].productoMeasure;
      productoModel.productoRating = producto[0].productoRating;
      productoModel.productoUpdated = producto[0].productoUpdated;
      productoModel.productoStatus = producto[0].productoStatus;
      productoModel.productoFavourite = producto[0].productoFavourite;

      listFinal.add(productoModel);
    }

    bienesController.sink.add(listFinal);
  }
}
