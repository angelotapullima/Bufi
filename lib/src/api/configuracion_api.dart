import 'dart:convert';

import 'package:bufi/src/database/tipo_pago_database.dart';
import 'package:bufi/src/models/tipos_pago_model.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConfiguracionApi {
  final tiposPagoDatabase = TiposPagoDatabase();

  Future<bool> obtenerConfiguracion() async {
    try {
      final url = '$apiBaseURL/api/Inicio/configuracion';

      final resp = await http.post(Uri.parse(url));

      final decodedData = json.decode(resp.body);

      if (decodedData['tipos_pago'].length > 0) {
        for (var i = 0; i < decodedData['tipos_pago'].length; i++) {
          TiposPagoModel tiposPagoModel = TiposPagoModel();
          tiposPagoModel.idTipoPago =
              decodedData['tipos_pago'][i]['id_tipo_pago'];
          tiposPagoModel.tipoPagoNombre =
              decodedData['tipos_pago'][i]['tipo_pago_nombre'];
          tiposPagoModel.tipoPagoEstado =
              decodedData['tipos_pago'][i]['tipo_pago_estado'];
          tiposPagoModel.tipoPagoImg =
              decodedData['tipos_pago'][i]['tipo_pago_img'];
          tiposPagoModel.tipoPagoMsj =
              decodedData['tipos_pago'][i]['tipo_pago_msj'];

          await tiposPagoDatabase.insertarTiposPago(tiposPagoModel);
        }

        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
