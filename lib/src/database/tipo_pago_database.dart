import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/tipos_pago_model.dart';

class TiposPagoDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarTiposPago(TiposPagoModel tiposPagoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO TiposPago (id_tipo_pago,tipo_pago_nombre,tipo_pago_img,tipo_pago_msj,seleccionado,tipo_pago_estado) "
          "VALUES('${tiposPagoModel.idTipoPago}','${tiposPagoModel.tipoPagoNombre}','${tiposPagoModel.tipoPagoImg}',"
          "'${tiposPagoModel.tipoPagoMsj}','${tiposPagoModel.seleccionado}','${tiposPagoModel.tipoPagoEstado}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
    }
  }

  Future<List<TiposPagoModel>> obtenerTiposPago() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM TiposPago where tipo_pago_estado = '1'");

      List<TiposPagoModel> list = res.isNotEmpty ? res.map((c) => TiposPagoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<TiposPagoModel>> obtenerTiposPagoSeleccionado() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM TiposPago where seleccionado = '1'");

      List<TiposPagoModel> list = res.isNotEmpty ? res.map((c) => TiposPagoModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deseleccionarTiposPago() async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE TiposPago SET seleccionado='0'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateSeleccionarTiposPago(String idTiposPago) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE TiposPago SET "
          "seleccionado='1' "
          "WHERE id_tipo_pago = '$idTiposPago'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }
}
