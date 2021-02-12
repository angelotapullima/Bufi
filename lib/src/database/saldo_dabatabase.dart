import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/saldoModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';

class SaldoDatabase {
  final dbProvider = DatabaseProvider.db;
  final pref = Preferences();

  insertarCompany(SaldoModel saldo) async {
    try {
      final db = await dbProvider.database;
      final res =
          await db.rawInsert("INSERT OR REPLACE INTO Cuenta (idUser,saldo) "
              "VALUES('${saldo.idUser}', '${saldo.saldo}')");

      return res;
    } catch (e) {
      print("Error en la base de datos $e");
    }
  }


  Future<List<SaldoModel>> obtenerSaldo() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Cuenta");

    List<SaldoModel> list =
        res.isNotEmpty ? res.map((c) => SaldoModel.fromJson(c)).toList() : [];
    return list;
  } 
}
