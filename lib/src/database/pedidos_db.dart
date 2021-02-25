import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/PedidosModel.dart';

class PedidosDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarPedido(PedidosModel pedidosModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Pedidos (id_pedido,id_user,id_city,id_subsidiary,id_company,delivery_number,delivery_name, delivery_email, delivery_cel,delivery_address,delivery_description,delivery_coord_x,delivery_coord_y,delivery_add_info,delivery_price,delivery_total_orden,delivery_payment,delivery_entrega,delivery_datetime,delivery_status,delivery_mt) "
          "VALUES('${pedidosModel.idPedido}','${pedidosModel.idUser}','${pedidosModel.idCity}',"
          "'${pedidosModel.idSubsidiary}','${pedidosModel.idCompany}','${pedidosModel.deliveryNumber}','${pedidosModel.deliveryName}','${pedidosModel.deliveryEmail}',"
          "'${pedidosModel.deliveryCel}','${pedidosModel.deliveryAddress}','${pedidosModel.deliveryDescription}',"
          "'${pedidosModel.deliveryCoordX}','${pedidosModel.deliveryCoordY}','${pedidosModel.deliveryAddInfo}',"
          "'${pedidosModel.deliveryPrice}','${pedidosModel.deliveryTotalOrden}','${pedidosModel.deliveryPayment}',"
          "'${pedidosModel.deliveryEntrega}','${pedidosModel.deliveryDatetime}','${pedidosModel.deliveryStatus}',"
          "'${pedidosModel.deliveryMt}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Pedidos");
      print(e);
    }
  }

 
  Future<List<PedidosModel>> obtenerPedidos() async {
    final db = await dbProvider.database;
    final res =
        await db.rawQuery("SELECT * FROM Pedidos");

    List<PedidosModel> list =
        res.isNotEmpty ? res.map((c) => PedidosModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PedidosModel>> obtenerPedidosXidPedido(String idPedido) async {
    final db = await dbProvider.database;
    final res =
        await db.rawQuery("SELECT * FROM Pedidos WHERE id_pedido= '$idPedido'");

    List<PedidosModel> list =
        res.isNotEmpty ? res.map((c) => PedidosModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PedidosModel>> obtenerPedidosXidEstado(String idEstado) async {
    final db = await dbProvider.database;
    final res =
        await db.rawQuery("SELECT * FROM Pedidos WHERE delivery_status= '$idEstado'");

    List<PedidosModel> list =
        res.isNotEmpty ? res.map((c) => PedidosModel.fromJson(c)).toList() : [];
    return list;
  }
}
