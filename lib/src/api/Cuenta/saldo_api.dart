import 'dart:convert';

import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/database/cuenta_dabatabase.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class SaldoApi {
  final cuentaDatabase = CuentaDatabase();
  final prefs = Preferences();

  Future<int> obtenerSaldo() async {
    try {
      var response = await http.post(
          "$apiBaseURL/api/Cuenta/obtener_saldo_actual",
          body: {'tn': prefs.token, 'app': 'true', 'id_usuario': prefs.idUser});

      final decodedData = json.decode(response.body);

      CuentaModel cuentaModel = CuentaModel();

      cuentaModel.idCuenta = decodedData['result']['id_cuenta'];
      cuentaModel.idUser = decodedData['result']['id_user'];
      cuentaModel.cuentaCodigo = decodedData['result']['cuenta_codigo'];
      cuentaModel.cuentaSaldo = decodedData['result']['cuenta_saldo'];
      cuentaModel.cuentaMoneda = decodedData['result']['cuenta_moneda'];
      cuentaModel.cuentaDate = decodedData['result']['cuenta_date'];
      cuentaModel.cuentaEstado = decodedData['result']['cuenta_estado'];

      await cuentaDatabase.insertarCuenta(cuentaModel);

      return 1;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<List<RecargaModel>> obtenerRecargaPendiente() async {
    final listGeneral = List<RecargaModel>();

    var response = await http.post(
        "$apiBaseURL/api/Cuenta/listar_recarga_pendiente",
        body: {'tn': prefs.token, 'app': 'true'});

    final decodedData = json.decode(response.body);

    RecargaModel recargaModel = RecargaModel();
    recargaModel.codigo = decodedData['codigo'];
    recargaModel.expiracion = decodedData['expiracion'];
    recargaModel.monto = decodedData['monto'];
    recargaModel.result = decodedData['result'].toString();
    recargaModel.mensaje = decodedData['mensaje'];
    recargaModel.tipo = decodedData['tipo'];

    listGeneral.add(recargaModel);
 
    return listGeneral;
  }
}
