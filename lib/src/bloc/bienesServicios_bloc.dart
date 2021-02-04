
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
import 'package:rxdart/subjects.dart';

class BienesServiciosBloc {
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
  Stream<bool> get cargandoStream =>
      _cargandoController.stream;

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
    serviciosController.sink.add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());

    await categoriaApi.obtenerbsResumen();

    bienesController.sink.add(await productoDatabase.obtenerSubsidiaryGood());
    serviciosController.sink.add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
  }

  //Obtener los nombres de todos los bienes y servicios
  void obtenerBienesAll() async {
    bienesAllController.sink.add(await goodDatabase.obtenerGood());
    await goodApi.obtenerGoodAll();
    bienesAllController.sink.add(await goodDatabase.obtenerGood());
  }

  void obtenerServiciosAll() async {
    serviciosAllController.sink.add(await servicesDatabase.obtenerService());
    await serviciosApi.obtenerServicesAll();
    serviciosAllController.sink.add(await servicesDatabase.obtenerService());
  }

//Obtener todos los bienes y servicios por ciudad
  void obtenerBienesAllPorCiudad() async {
    bienesController.sink
        .add(await productoDatabase.obtenerSubsidiaryGood());
    await goodApi.listarBienesAllPorCiudad();
    bienesController.sink
        .add(await productoDatabase.obtenerSubsidiaryGood());
  }

  void obtenerServiciosAllPorCiudad() async {
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
    await serviciosApi.listarServiciosAllPorCiudad();
    serviciosController.sink
        .add(await subisdiaryServiceDatabase.obtenerSubsidiaryService());
  }
}
