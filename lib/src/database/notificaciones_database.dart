import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/notificacionModel.dart';

class NotificacionesDataBase{
final dbprovider = DatabaseProvider.db;

  insertarNotificaciones(NotificacionesModel notificacionModel) async{
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
    Future<List<NotificacionesModel>> obtenerNotificaciones() async {
    try{
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Notificaciones ");

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
    try{
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Notificaciones where notificacion_estado='0'");

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


  
  

  
 

