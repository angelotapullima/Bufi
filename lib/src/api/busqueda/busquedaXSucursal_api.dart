import 'dart:convert';

import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class BusquedaPorSucursalApi {
  final prefs = Preferences();
  final productoDatabase = ProductoDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future<List<BusquedaProductoPorSucursalModel>> busquedaProductoXSucursal(
      String query, String idSucursal) async {
    final listGeneral = List<BusquedaProductoPorSucursalModel>();

    final res = await http
        .post("$apiBaseURL/api/Negocio/buscar_bs_por_sucursal", body: {
      'buscar': '$query',
      'id': '$idSucursal',
      // 'tn': prefs.token,
      // 'id_user': prefs.idUser,
      // 'app': 'true'
    });
    final decodedData = json.decode(res.body);
  }
}
