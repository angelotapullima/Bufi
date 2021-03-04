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
}
