import 'dart:convert';
import 'package:bufi/src/database/agentes_dabatabase.dart';
import 'package:http/http.dart' as http;
import 'package:bufi/src/models/agentesModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';

class AgentesApi {
  final prefs = Preferences();
  final agentesDb = AgentesDatabase();

  Future<int> obtenerAgentes() async {
    try {
      var response = await http.post(
          Uri.parse("$apiBaseURL/api/Inicio/agentes"),
          body: {'id_ciudad': '1'});

      final decodedData = json.decode(response.body);

      for (var i = 0; i < decodedData["agentes"].length; i++) {
        AgenteModel agenteModel = AgenteModel();

        agenteModel.idAgente = decodedData["agentes"][i]["id_agente"];
        agenteModel.idUser = decodedData["agentes"][i]["id_user"];
        agenteModel.idCuenta = decodedData["agentes"][i]["id_cuenta"];
        agenteModel.idCity = decodedData["agentes"][i]["id_city"];
        agenteModel.agenteTipo = decodedData["agentes"][i]["agente_tipo"];
        agenteModel.agenteNombre = decodedData["agentes"][i]["agente_nombre"];
        agenteModel.agenteCodigo = decodedData["agentes"][i]["agente_codigo"];
        agenteModel.agenteDireccion =
            decodedData["agentes"][i]["agente_direccion"];
        agenteModel.agenteTelefono =
            decodedData["agentes"][i]["agente_telefono"];
        agenteModel.agenteImagen = decodedData["agentes"][i]["agente_imagen"];
        agenteModel.agenteCoordX = decodedData["agentes"][i]["agente_coord_x"];
        agenteModel.agenteCoordY = decodedData["agentes"][i]["agente_coord_y"];
        agenteModel.agenteEstado = decodedData["agentes"][i]["agente_estado"];
        agenteModel.idCuentaEmpresa =
            decodedData["agentes"][i]["id_cuenta_empresa"];
        agenteModel.cuentaeCodigo = decodedData["agentes"][i]["cuentae_codigo"];
        agenteModel.cuentaeSaldo = decodedData["agentes"][i]["cuentae_saldo"];
        agenteModel.cuentaeMoneda = decodedData["agentes"][i]["cuentae_moneda"];
        agenteModel.cuentaeDate = decodedData["agentes"][i]["cuentae_date"];
        agenteModel.cuentaeEstado = decodedData["agentes"][i]["cuentae_estado"];
        agenteModel.idCompany = decodedData["agentes"][i]["id_company"];
        agenteModel.posicion = (i + 1).toString();

        await agentesDb.insertarAgentes(agenteModel);
      }

      return 1;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}
