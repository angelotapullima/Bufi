import 'package:bufi/src/api/publicidad_api.dart';
import 'package:bufi/src/database/publicidad_database.dart';
import 'package:bufi/src/models/publicidad_model.dart';
import 'package:rxdart/subjects.dart';

class PublicidadBloc {
  final publicidadDatabase = PublicidadDatabase();
  final publicidadApi = PublicidadApi();
  final _publicidadListController = BehaviorSubject<List<PublicidadModel>>();

  Stream<List<PublicidadModel>> get publicidadListStream =>
      _publicidadListController.stream;

  void dispose() {
    _publicidadListController?.close();
  }

  void obtenerPublicidadBloc() async {
    _publicidadListController.sink .add(await publicidadDatabase.obtenerPublicidad());
    await publicidadApi.obtenerPublicidad();
    _publicidadListController.sink .add(await publicidadDatabase.obtenerPublicidad());
  }
}
