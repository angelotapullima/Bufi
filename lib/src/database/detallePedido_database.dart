import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';

class DetallePedidoDatabase{

final dbprovider = DatabaseProvider.db;

  insertarDetallePedido(DetallePedidoModel detallePedidoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO DetallePedido (id_detalle_pedido,id_pedido,id_producto,"
          "cantidad,delivery_detail_subtotal) "
              "VALUES ('${detallePedidoModel.idDetallePedido}','${detallePedidoModel.idPedido}','${detallePedidoModel.idProducto}',"
              "'${detallePedidoModel.cantidad}',"
              "'${detallePedidoModel.detallePedidoSubtotal}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<DetallePedidoModel>> obtenerDetallePedido() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM DetallePedido ");

    List<DetallePedidoModel> list = res.isNotEmpty
        ? res.map((c) => DetallePedidoModel.fromJson(c)).toList()
        : [];

    return list;
  } 


}