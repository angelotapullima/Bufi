import 'dart:convert';

import 'package:bufi/src/database/saldo_dabatabase.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class SaldoApi {
  final saldoDatabase = SaldoDatabase();
  final prefs = Preferences();

  Future<int> obtenerSaldo() async {
    try {
      var response =
          await http.post("$apiBaseURL/api/Cuenta/obtener_saldo_actual", body: {
        'id_usuario': prefs.idUser,
      });

      final decodedData = json.decode(response.body);

      return 1;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}