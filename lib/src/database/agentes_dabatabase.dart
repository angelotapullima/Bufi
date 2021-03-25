import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/agentesModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';

class AgentesDatabase {
  final dbProvider = DatabaseProvider.db;
  final pref = Preferences();

  insertarAgentes(AgenteModel agenteModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Agentes (id_agente,id_user,id_cuenta,id_city,agente_tipo,agente_nombre,agente_codigo,agente_direccion,agente_telefono,agente_imagen,agente_coord_x,agente_coord_y,agente_estado,id_cuenta_empresa,id_company,cuentae_codigo,cuentae_saldo,cuentae_moneda,cuentae_date,cuentae_estado) "
          "VALUES('${agenteModel.idAgente}','${agenteModel.idUser}','${agenteModel.idCuenta}','${agenteModel.idCity}','${agenteModel.agenteTipo}','${agenteModel.agenteNombre}','${agenteModel.agenteCodigo}','${agenteModel.agenteDireccion}','${agenteModel.agenteTelefono}','${agenteModel.agenteImagen}','${agenteModel.agenteCoordX}','${agenteModel.agenteCoordY}','${agenteModel.agenteEstado}','${agenteModel.idCuentaEmpresa}','${agenteModel.idCompany}','${agenteModel.cuentaeCodigo}','${agenteModel.cuentaeSaldo}','${agenteModel.cuentaeMoneda}','${agenteModel.cuentaeDate}','${agenteModel.cuentaeEstado}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos $e");
    }
  }

  Future<List<AgenteModel>> obtenerAgentes() async {
    try{
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Agentes");

    List<AgenteModel> list =
        res.isNotEmpty ? res.map((c) => AgenteModel.fromJson(c)).toList() : [];
    return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  }

  Future<List<AgenteModel>> obtenerAgentesXidcompany(String idCompany) async {
    try{
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Agentes where id_company= $idCompany");

    List<AgenteModel> list =
        res.isNotEmpty ? res.map((c) => AgenteModel.fromJson(c)).toList() : [];
    return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  }
}
