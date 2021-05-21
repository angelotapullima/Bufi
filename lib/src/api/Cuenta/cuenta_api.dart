import 'dart:convert';
import 'dart:io';

import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/database/cuenta_dabatabase.dart';
import 'package:path/path.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class CuentaApi {
  final cuentaDatabase = CuentaDatabase();
  final prefs = Preferences();

  Future<int> obtenerSaldo() async {
    try {
      var response = await http.post(
          Uri.parse("$apiBaseURL/api/Cuenta/obtener_saldo_actual"),
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
    final List<RecargaModel> listGeneral = [];

    var response = await http.post(
        Uri.parse("$apiBaseURL/api/Cuenta/listar_recarga_pendiente"),
        body: {'tn': prefs.token, 'app': 'true'});

    final decodedData = json.decode(response.body);

    RecargaModel recargaModel = RecargaModel();
    recargaModel.codigo = decodedData['codigo'];
    recargaModel.expiracion = decodedData['expiracion'];
    recargaModel.monto = decodedData['monto'].toString();
    recargaModel.result = decodedData['result'].toString();
    recargaModel.mensaje = decodedData['mensaje'];
    recargaModel.tipo = decodedData['tipo'].toString();

    listGeneral.add(recargaModel);

    return listGeneral;
  }

  Future<List<RecargaModel>> recargarCuenta(String monto, String tipo) async {
    final List<RecargaModel> listGeneral = [];

    var response = await http.post(
        Uri.parse("$apiBaseURL/api/Cuenta/save_recargar_mi_cuenta"),
        body: {
          'tn': prefs.token,
          'app': 'true',
          'monto': monto,
          'tipo': tipo,
        });

    final decodedData = json.decode(response.body);

    RecargaModel recargaModel = RecargaModel();
    recargaModel.codigo = decodedData['result']['codigo'];
    recargaModel.expiracion = decodedData['result']['expiracion'];
    recargaModel.monto = decodedData['result']['monto'].toString();
    recargaModel.result = decodedData['result']['code'].toString();
    recargaModel.mensaje = decodedData['result']['mensaje'];
    recargaModel.tipo = decodedData['result']['tipo'].toString();

    listGeneral.add(recargaModel);

    return listGeneral;
  }

  Future<int> subirVoucher(File _image) async {
    int devuelto = 0;
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Cuenta/subir_voucher");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('voucher', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // print(value);

        final decodedData = json.decode(value);
        final int code = decodedData['result']['code'];

        if (decodedData['result']['code'] == 1) {
          devuelto = 1;
        } else if (code == 2) {
          devuelto = 2;
        } else {
          devuelto = code;
        }
      });
    }).catchError((e) {
      print(e);
      return 0;
    });

    return devuelto;
  }
}
