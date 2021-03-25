import 'package:bufi/src/api/notificaciones_api.dart';
import 'package:bufi/src/database/notificaciones_database.dart';
import 'package:bufi/src/models/notificacionModel.dart';
import 'package:rxdart/rxdart.dart';

class NotificacionesBloc {
  final notificacionApi = NotificacionesApi();
  final notificacionDb = NotificacionesDataBase();

  final listarNotificacionesController =
      BehaviorSubject<List<NotificacionesModel>>();

  Stream<List<NotificacionesModel>> get listarnotificacionesStream =>
      listarNotificacionesController.stream;

  dispose() {
    listarNotificacionesController?.close();
  }

  void listarNotificaciones() async {
    listarNotificacionesController.sink
        .add(await notificacionDb.obtenerNotificaciones());
    await notificacionApi.listarNotificaciones();
  listarNotificacionesController.sink
        .add(await notificacionDb.obtenerNotificaciones());
  }
}