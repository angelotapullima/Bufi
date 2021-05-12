import 'dart:convert';

import 'package:bufi/src/database/notificaciones_database.dart';
import 'package:bufi/src/models/notificacionModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class NotificacionesApi {
  final prefs = Preferences();
  final notificacionDb = NotificacionesDataBase();

  Future<dynamic> listarNotificaciones() async {
    try {
      final res = await http.post(
          Uri.parse("$apiBaseURL/api/usuario/listar_notificaciones"),
          body: {
            'app': 'true',
            'tn': prefs.token
            //prefs.token,
          });

      final decodedData = json.decode(res.body);
      //print(res);

      for (var i = 0; i < decodedData.length; i++) {
        final notificacionModel = NotificacionesModel();

        notificacionModel.idNotificacion = decodedData[i]["id_notificacion"];
        notificacionModel.idUsuario = decodedData[i]["id_usuario"];
        notificacionModel.notificacionTipo =
            decodedData[i]["notificacion_tipo"];
        notificacionModel.notificacionIdRel =
            decodedData[i]["notificacion_id_rel"];
        notificacionModel.notificacionMensaje =
            decodedData[i]["notificacion_mensaje"];
        notificacionModel.notificacionImagen =
            decodedData[i]["notificacion_imagen"];
        notificacionModel.notificacionDatetime =
            decodedData[i]["notificacion_datetime"];
        notificacionModel.notificacionEstado =
            decodedData[i]["notificacion_estado"];

        await notificacionDb.insertarNotificaciones(notificacionModel);
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 0;
  }

  Future<dynamic> notificacionesVistas(String idNotificacion) async {
    try {
      final res = await http
          .post(Uri.parse("$apiBaseURL/api/usuario/notificacion_vista"), body: {
        'id': '$idNotificacion',
        'app': 'true',
        'tn': prefs.token,
        //'qz8Hsr/dx+cJFcG11tbm9xK50aHWqisJws7SvMUcIJ/c09XCHenZ3Mfk4TL0rtrE3sUm+rbB2cjm9xraotfarQkf3MLW4eEz/9Hdt+rdMuTQ2A=='
      });

      final decodedData = json.decode(res.body);
      //print(res);
      final code = decodedData['result']['code'];

      if (code == 1) {
        return 1;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 1;
  }
}
