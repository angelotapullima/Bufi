import 'package:bufi/src/api/notificaciones_api.dart';
import 'package:bufi/src/database/notificaciones_database.dart';
import 'package:bufi/src/models/notificacionModel.dart';
import 'package:rxdart/rxdart.dart';

class NotificacionesBloc {
  final notificacionApi = NotificacionesApi();
  final notificacionDb = NotificacionesDataBase();

  final listarNotificacionesController =
      BehaviorSubject<List<NotificacionesModel>>();
  final notificacionesPendientesController =
      BehaviorSubject<List<NotificacionesModel>>();

  Stream<List<NotificacionesModel>> get listarnotificacionesStream =>
      listarNotificacionesController.stream;

  Stream<List<NotificacionesModel>> get notificacionesPendientesStream =>
      notificacionesPendientesController.stream;

  dispose() {
    listarNotificacionesController?.close();
    notificacionesPendientesController?.close();
  }

// notificaciones: 0:No leídas, 1:leídas
  void listarNotificaciones() async {
    listarNotificacionesController.sink
        .add(await notificacionDb.obtenerNotificaciones());
     await notificacionApi.listarNotificaciones();
    listarNotificacionesController.sink
       .add(await notificacionDb.obtenerNotificaciones()); 
  }

// notificaciones pendientes
  void listarNotificacionesPendientes() async {
    notificacionesPendientesController.sink
        .add(await notificacionesPendientes());
 
  }
  

  //funcion que obtiene la lista de notificaciones pendientes
  Future<List<NotificacionesModel>> notificacionesPendientes() async {
  final notiDb = NotificacionesDataBase();
  final List<NotificacionesModel> listNotificacionModel = [];
  final listpendientes = await notiDb.obtenerNotificacionesPendientes();

  for (var i = 0; i < listpendientes.length; i++) {
    final notificacionModel = NotificacionesModel();
    notificacionModel.notificacionEstado = listpendientes[i].notificacionEstado;
    listNotificacionModel.add(notificacionModel);
  }
  return listNotificacionModel;
}
}
