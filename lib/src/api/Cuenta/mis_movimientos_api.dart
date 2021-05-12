import 'dart:convert';

import 'package:bufi/src/database/mis_movimientos_database.dart';
import 'package:bufi/src/models/mis_movimientos_model.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class MisMovimientosApi {
  final misMovimientosDatabase = MisMovimientosDatabase();
  final prefs = new Preferences();

  Future<bool> obtenerMisMovimientos() async {
    try {
      final url = '$apiBaseURL/api/Cuenta/listar_pagos_por_id_usuario';

      final resp = await http.post(Uri.parse(url),
          body: {'id_user': prefs.idUser, 'app': 'true', 'tn': prefs.token});

      final decodedData = json.decode(resp.body);

      if (decodedData['results'].length > 0) {
        for (int i = 0; i < decodedData['results'].length; i++) {
          MisMovimientosModel misMovimientosModel = MisMovimientosModel();
          misMovimientosModel.nroOperacion =
              decodedData['results'][i]['nro_operacion'];
          misMovimientosModel.concepto = decodedData['results'][i]['concepto'];
          misMovimientosModel.tipoPago = decodedData['results'][i]['tipo_pago'];
          misMovimientosModel.monto = decodedData['results'][i]['monto'];
          misMovimientosModel.comision =
              decodedData['results'][i]['comision'].toString();
          misMovimientosModel.fecha = decodedData['results'][i]['fecha'];
          misMovimientosModel.soloFecha =
              decodedData['results'][i]['solo_fecha'];
          misMovimientosModel.ind = decodedData['results'][i]['ind'].toString();

          await misMovimientosDatabase
              .insertarMisMovimientos(misMovimientosModel);
        }

        return true;
      }

      return false;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
