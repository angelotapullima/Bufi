import 'package:bufi/src/api/busqueda/busqueda_api.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaGeneralBloc {

  final busquedaApi = BusquedaApi();
  
  final busquedaGeneralController =
      BehaviorSubject<List<BusquedaGeneralModel>>();

  Stream<List<BusquedaGeneralModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;

  void dispose() {
    busquedaGeneralController?.close();
  }

  void obtenerResultadosBusquedaPorQuery(String query) async {
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
    busquedaGeneralController.sink
        .add(await busquedaApi.busquedaGeneral(query));
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
  }
}
