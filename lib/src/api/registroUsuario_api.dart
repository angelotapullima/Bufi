import 'dart:convert';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class RegisterUser {
  Future<int> registro(String name, String surname, String nickName, String cel,
      String email, String pass) async {
    try {
      final url = '$apiBaseURL/api/Inicio/new';

      final resp = await http.post(Uri.parse(url), body: {
        'name': '$name',
        'surname': '$surname',
        'user_nickname': '$nickName',
        'email': '$email',
        'cel': '$cel',
        'ciudad': '1',
        'pass': '$pass'
      });

      //print(json.decode(resp.body));

      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        return 1;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}
