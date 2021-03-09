import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';

class DetallePedidoDatabase{

final dbprovider = DatabaseProvider.db;

  insertarDetallePedido(DetallePedidoModel detallePedidoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO DetallePedido (id_detalle_pedido,id_pedido,id_producto,"
          "cantidad,detalle_pedido_marca,detalle_pedido_modelo,detalle_pedido_talla,delivery_detail_subtotal) "
              "VALUES ('${detallePedidoModel.idDetallePedido}','${detallePedidoModel.idPedido}','${detallePedidoModel.idProducto}',"
              "'${detallePedidoModel.cantidad}','${detallePedidoModel.detallePedidoMarca}','${detallePedidoModel.detallePedidoModelo}','${detallePedidoModel.detallePedidoTalla}',"
              "'${detallePedidoModel.detallePedidoSubtotal}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<DetallePedidoModel>> obtenerDetallePedidoxIdPedido(String idPedido) async {
    try{
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM DetallePedido where id_pedido='$idPedido'");

    List<DetallePedidoModel> list = res.isNotEmpty
        ? res.map((c) => DetallePedidoModel.fromJson(c)).toList()
        : [];

    return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
      return [];
    }
  } 

 

}