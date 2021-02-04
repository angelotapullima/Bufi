import 'dart:convert';

import 'package:bufi/src/models/usuario_model.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  
  final prefs = new Preferences();

  Future<int> login(String user, String pass) async {
    try {
      final url = '$apiBaseURL/api/Login/singIn';

      final resp = await http
          .post(url, body: {'user': '$user', 'pass': '$pass', 'app': 'true'});

      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        final prodTemp = Data.fromJson(decodedData['data']);

        //agrego los datos de usuario al sharePreferences
        prefs.idUser = decodedData['data']['c_u'];
        prefs.idCity = prodTemp.idCity;
        prefs.idPerson = prodTemp.idPerson;
        prefs.userNickname = prodTemp.userNickname;
        prefs.userEmail = prodTemp.userEmail;
        prefs.userImage = prodTemp.userImage;
        prefs.personName = prodTemp.personName;
        prefs.personSurname = prodTemp.personSurname;
        prefs.idRoleUser = prodTemp.idRoleUser;
        prefs.roleName = prodTemp.roleName;
        prefs.token =  decodedData['data']['tn'];

        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}
