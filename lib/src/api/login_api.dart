import 'dart:convert';

import 'package:bufi/src/api/token_api.dart';
import 'package:bufi/src/models/usuario_model.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  final prefs = new Preferences();

  Future<int> login(String user, String pass) async {
    try {
      final url = '$apiBaseURL/api/Login/validar_sesion';

      final resp = await http.post(Uri.parse(url), body: {'usuario_nickname': '$user', 'usuario_contrasenha': '$pass', 'app': 'true'});

      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        final prodTemp = Data.fromJson(decodedData['data']);
        //agrego los datos de usuario al sharePreferences
        prefs.idUser = decodedData['data']['c_u'];
        prefs.idPerson = prodTemp.idPerson;
        prefs.userNickname = prodTemp.userNickname;
        prefs.userEmail = prodTemp.userEmail;
        prefs.userImage = prodTemp.userImage;
        prefs.personName = prodTemp.personName;
        prefs.personSurname = prodTemp.personSurname;
        prefs.idRoleUser = prodTemp.idRoleUser;
        prefs.roleName = prodTemp.roleName;
        prefs.token = decodedData['data']['tn'];

        final tokenApi = TokenApi();
        tokenApi.enviarToken();

        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<int> cambiarPass(String pass) async {
    try {
      final url = '$apiBaseURL/api/datos/guardar_contrasenha_app';
      final resp = await http.post(Uri.parse(url), body: {'tn': prefs.token, 'contrasenha': '$pass', 'app': 'true'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        // final prodTemp = Data.fromJson(decodedData['data']);

        // //agrego los datos de usuario al sharePreferences
        // prefs.idUser = decodedData['data']['c_u'];
        // prefs.idCity = prodTemp.idCity;
        // prefs.idPerson = prodTemp.idPerson;
        // prefs.userNickname = prodTemp.userNickname;
        // prefs.userEmail = prodTemp.userEmail;
        // prefs.userImage = prodTemp.userImage;
        // prefs.personName = prodTemp.personName;
        // prefs.personSurname = prodTemp.personSurname;
        // prefs.idRoleUser = prodTemp.idRoleUser;
        // prefs.roleName = prodTemp.roleName;
        prefs.token = decodedData['data']['tn'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  // ------------ Restablecer Contraseña ----------------

  //Envio de email para verificar si existe usuario
  Future<int> restablecerPass(String email) async {
    try {
      final url = '$apiBaseURL/api/Login/restaurar_clave';
      final resp = await http.post(Uri.parse(url), body: {'email': '$email'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  //Envío del codigo de verificación
  Future<int> restablecerPass1(String param) async {
    try {
      final url = '$apiBaseURL/api/Login/restaurar_clave';
      final resp = await http.post(Uri.parse(url), body: {'id': '${prefs.idUser}', 'param': '$param'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        prefs.idUser = decodedData['result']['data']['id_usuario'];
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  //Envío de la nueva contraseña
  Future<int> restablecerPassOk(String pass) async {
    try {
      final url = '$apiBaseURL/api/Login/restaurar_clave';
      final resp = await http.post(Uri.parse(url), body: {'id': '${prefs.idUser}', 'pass': '$pass'});
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        //prefs.idUser = decodedData['result']['data']['id_usuario'];
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
