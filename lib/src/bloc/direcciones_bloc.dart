import 'package:bufi/src/database/direccion_database.dart';
import 'package:bufi/src/models/direccionModel.dart';
import 'package:rxdart/subjects.dart';

class DireccionesBloc {
  final direccionesDatabase = DireccionDatabase();

  final _direccionesController = BehaviorSubject<List<DireccionModel>>();

  Stream<List<DireccionModel>> get direccionesStream => _direccionesController.stream;

  void dispose() {
    _direccionesController?.close();
  }

  void obtenerDirecciones() async {
    _direccionesController.sink.add(await direccionesDatabase.obtenerDirecciones());
  }

void obtenerDireccionEstado1() async {
    _direccionesController.sink.add(await agregarDireccion());
  }
  void deleteDireccion() async {
    _direccionesController.sink.add(await eliminarDireccion());
  }
  
  Future<List<DireccionModel>> agregarDireccion() async { 
  
  final listDireccionModel = List<DireccionModel>();
  
  final listDirecciones = await direccionesDatabase.obtenerdireccionEstado1();

  for (var i = 0; i < listDirecciones.length; i++) {
    DireccionModel direccionModel = DireccionModel();

    direccionModel.address = listDirecciones[i].address;
    direccionModel.referencia = listDirecciones[i].referencia;
    direccionModel.distrito = listDirecciones[i].distrito;
    direccionModel.estado = listDirecciones[i].estado;

    listDireccionModel.add(direccionModel);
  }
  return listDireccionModel;
}
  Future<List<DireccionModel>> eliminarDireccion() async { 
  
  final listDireccionModel = List<DireccionModel>();
  
  final listDirecciones = await direccionesDatabase.obtenerDireccionEstado0();

  for (var i = 0; i < listDirecciones.length; i++) {
    DireccionModel direccionModel = DireccionModel();

    direccionModel.address = listDirecciones[i].address;
    direccionModel.referencia = listDirecciones[i].referencia;
    direccionModel.distrito = listDirecciones[i].distrito;
    direccionModel.estado = listDirecciones[i].estado;

    listDireccionModel.add(direccionModel);
  }
  return listDireccionModel;
}

}
