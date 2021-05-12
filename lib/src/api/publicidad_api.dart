import 'dart:convert';

import 'package:bufi/src/database/publicidad_database.dart';
import 'package:bufi/src/models/publicidad_model.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PublicidadApi {
  final prefs = Preferences();

  final publicidadDatabase = PublicidadDatabase();

  //Guardar favorito
  Future<dynamic> obtenerPublicidad() async {
    try {
      final res = await http
          .post(Uri.parse("$apiBaseURL/api/Inicio/publicidad"), body: {
        'id_ciudad': '1',
      });

      final decodedData = json.decode(res.body);

      if (decodedData.length > 0) {
        for (var i = 0; i < decodedData.length; i++) {
          PublicidadModel publicidadModel = PublicidadModel();

          publicidadModel.idPublicidad = decodedData[i]['id_publicidad'];
          publicidadModel.idCity = decodedData[i]['id_city'];
          publicidadModel.idSubsidiary = decodedData[i]['id_subsidiary'];
          publicidadModel.publicidadImg = decodedData[i]['publicidad_img'];
          publicidadModel.publicidadOrden = decodedData[i]['publicidad_orden'];
          publicidadModel.publicidadEstado =
              decodedData[i]['publicidad_estado'];
          publicidadModel.publicidadDatetime =
              decodedData[i]['publicidad_datetime'];
          publicidadModel.idPago = decodedData[i]['id_pago'];

          await publicidadDatabase.insertarPublicidad(publicidadModel);
        }
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
    return 0;
  }
}
