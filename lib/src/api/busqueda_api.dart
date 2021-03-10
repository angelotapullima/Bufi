import 'dart:convert';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;


class BusquedaApi{
  final prefs = Preferences();

  Future busqueda(String query) async {
    try {
      final res =
          await http.post("$apiBaseURL/api/Negocio/buscar_ws", body: {
        'buscar': '$query',
        // 'tn': prefs.token,
        // 'id_user': prefs.idUser,
        // 'app': 'true'
      });

      final decodedData = json.decode(res.body);
      final context=decodedData["context"];

      if (context=="good") {

        
        
      }

      final int code = decodedData["code"];

      if (code==1) {
        for (var i = 0; i < decodedData["result"]; i++) {
        
      }
      }

      

      return code;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}