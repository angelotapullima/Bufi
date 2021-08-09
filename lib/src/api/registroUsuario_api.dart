import 'dart:convert';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class RegisterUser {
  Future<int> registro(
    String name,
    String surname,
    String surname2,
    String birth,
    String cel,
    String genre,
    String ubigeo,
    String nickName,
    String email,
    String pass,
  ) async {
    try {
      final url = '$apiBaseURL/api/Inicio/new';

      final resp = await http.post(Uri.parse(url), body: {
        'person_name': '$name',
        'person_surname': '$surname',
        'person_surname2': '$surname2',
        'person_birth': '$birth',
        'person_number_phone': '$cel',
        'person_genre': '$genre',
        'ubigeo_id': '$ubigeo',
        'user_nickname': '$nickName',
        'user_email': '$email',
        'user_password': '$pass',
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
