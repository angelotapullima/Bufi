import 'package:bufi/src/database/historial_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/searchHistory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/historialModel.dart';
import 'package:bufi/src/models/searchHistoryModel.dart';
import 'package:rxdart/rxdart.dart';

class SearchHistoryBloc {
  final searchBusquedaDB = SearchHistoryDb();
  final productoDatabase = ProductoDatabase();
  final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();
  final historyDB = HistorialDb();

  //Crear el controller del tipo SearchHistoryModel
  final _searchHistoryController = BehaviorSubject<List<SearchHistoryModel>>();

  //Controller para el tipo HistoryModel
  final _historyController = BehaviorSubject<List<HistorialModel>>();

  //Crear el Stream controller SearhHistory
  Stream<List<SearchHistoryModel>> get searchHistoryStream => _searchHistoryController.stream;

  //Stream controller History
  Stream<List<HistorialModel>> get historyStream => _historyController.stream;

  void dispose() {
    _searchHistoryController?.close();
    _historyController?.close();
  }

  //Obtener las úlltimas 10 busquedas realizadas
  void listarSearchHistory() async {
    _searchHistoryController.sink.add(await obtenerHistorial());
  }

  void obtenerAllHistorial(String page) async {
    _historyController.sink.add(await historyDB.obtenerBusqueda(page));
  }

  Future<List<SearchHistoryModel>> obtenerHistorial() async {
    final List<SearchHistoryModel> listReturn = [];
    final listHistory = await searchBusquedaDB.obtenerBusqueda();
    if (listHistory.length > 0) {
      for (var i = 0; i < listHistory.length; i++) {
        SearchHistoryModel searchHistoryModel = SearchHistoryModel();
        if (listHistory[i].tipoBusqueda == 'Producto') {
          final listBien = await productoDatabase.obtenerProductoPorIdSubsidiaryGood(listHistory[i].idBusqueda);
          searchHistoryModel.idBusqueda = listBien[0].idProducto;
          searchHistoryModel.nombreBusqueda = listBien[0].productoName;
          searchHistoryModel.img = listBien[0].productoImage;
          searchHistoryModel.tipoBusqueda = listHistory[i].tipoBusqueda;
        } else {
          final listService = await subsidiaryServiceDatabase.obtenerServiciosPorIdSucursalService(listHistory[i].idBusqueda);
          searchHistoryModel.idBusqueda = listService[0].idSubsidiaryservice;
          searchHistoryModel.nombreBusqueda = listService[0].subsidiaryServiceName;
          searchHistoryModel.img = listService[0].subsidiaryServiceImage;
          searchHistoryModel.tipoBusqueda = listHistory[i].tipoBusqueda;
        }
        listReturn.add(searchHistoryModel);
      }
    }

    return listReturn;
  }
}
