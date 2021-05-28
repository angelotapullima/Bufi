import 'dart:convert';

import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class TokenApi {
  final prefs = Preferences();
  Future<bool> enviarToken() async {
    if (prefs.token != null) {
      final res = await http
          .post(Uri.parse("$apiBaseURL/api/Usuario/actualizar_token"), body: {
        'token': '${prefs.tokenFirebase}',
        'tn': '${prefs.token}',
        'app': 'true',
      });

      final decodedData = json.decode(res.body);
      final int code = decodedData['results'];
      if (code == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
