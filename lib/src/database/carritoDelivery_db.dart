import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/carritoDeliveryModel.dart';

class CarritoDeliveryDB {
  final dbProvider = DatabaseProvider.db;

  insertarTipoDelivery(CarritoDeliveryModel carritoDeliveryModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO CarritoDelivery (id_subsidiary,"
          "tipo_delivery_seleccionado) "
          "VALUES('${carritoDeliveryModel.idSubsidiary}','${carritoDeliveryModel.tipoDeliverySeleccionado}')");
      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
    }
  }

  Future<List<CarritoDeliveryModel>> obtenerTipoDeliveryPorSucursal(String idSubsi) async {
    final db = await dbProvider.database;
    try {
      final res = await db.rawQuery("SELECT * FROM CarritoDelivery WHERE id_subsidiary = '$idSubsi'");

      List<CarritoDeliveryModel> list = res.isNotEmpty ? res.map((c) => CarritoDeliveryModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print("Error $e");
      return [];
    }
  }

  updateSeleccionado(String idSubsidiary, String seleccion) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE CarritoDelivery SET "
          "tipo_delivery_seleccionado='$seleccion' "
          "WHERE id_subsidiary = '$idSubsidiary'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }
}
