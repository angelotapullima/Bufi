import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/notificacionModel.dart';

class NotificacionesDataBase {
  final dbprovider = DatabaseProvider.db;

  insertarNotificaciones(NotificacionesModel notificacionModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Notificaciones (id_notificacion,id_usuario,notificacion_tipo,notificacion_id_rel,notificacion_mensaje,notificacion_imagen,notificacion_datetime, notificacion_estado) "
          "VALUES('${notificacionModel.idNotificacion}','${notificacionModel.idUsuario}','${notificacionModel.notificacionTipo}',"
          "'${notificacionModel.notificacionIdRel}','${notificacionModel.notificacionMensaje}','${notificacionModel.notificacionImagen}','${notificacionModel.notificacionDatetime}',"
          "'${notificacionModel.notificacionEstado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateNotificaciones(NotificacionesModel notificacionModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate(
          "UPDATE Notificaciones SET id_usuario= '${notificacionModel.idUsuario}',"
          "notificacion_tipo='${notificacionModel.notificacionTipo}',"
          "notificacion_id_rel='${notificacionModel.notificacionIdRel}',"
          "notificacion_mensaje='${notificacionModel.notificacionMensaje}',"
          "notificacion_imagen='${notificacionModel.notificacionImagen}',"
          "notificacion_datetime='${notificacionModel.notificacionDatetime}',"
          "notificacion_estado='${notificacionModel.notificacionEstado}'"
          "WHERE id_notificacion='${notificacionModel.idNotificacion}' ");

      print('database $res');
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<NotificacionesModel>> obtenerNotificaciones() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Notificaciones ORDER BY notificacion_datetime DESC ");

      List<NotificacionesModel> list = res.isNotEmpty
          ? res.map((c) => NotificacionesModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<NotificacionesModel>>
      obtenerNotificacionesPendientesXIdNotificacion(
          String idNotificacion) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Notificaciones where id_notificacion= '$idNotificacion' and notificacion_estado='0'");

      List<NotificacionesModel> list = res.isNotEmpty
          ? res.map((c) => NotificacionesModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<NotificacionesModel>> obtenerNotificacionesPendientes() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Notificaciones where notificacion_estado='0'");

      List<NotificacionesModel> list = res.isNotEmpty
          ? res.map((c) => NotificacionesModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<NotificacionesModel>> obtenerNotificacionesLeidas() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM Notificaciones where notificacion_estado='1'");

      List<NotificacionesModel> list = res.isNotEmpty
          ? res.map((c) => NotificacionesModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }
}
