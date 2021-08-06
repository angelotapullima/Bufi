import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';

class CuentaDatabase {
  final dbProvider = DatabaseProvider.db;
  final pref = Preferences();

  insertarCuenta(CuentaModel saldo) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO Cuenta (id_cuenta,id_user,cuenta_codigo,cuenta_saldo,cuenta_moneda,cuenta_date,cuenta_estado) "
          "VALUES('${saldo.idCuenta}', '${saldo.idUser}','${saldo.cuentaCodigo}','${saldo.cuentaSaldo}','${saldo.cuentaMoneda}','${saldo.cuentaDate}','${saldo.cuentaEstado}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos $e");
    }
  }

  Future<List<CuentaModel>> obtenerSaldo() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Cuenta");

      List<CuentaModel> list = res.isNotEmpty ? res.map((c) => CuentaModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
