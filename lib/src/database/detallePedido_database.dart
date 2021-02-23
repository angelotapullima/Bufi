import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';

class DetallePedidoDatabase{

final dbprovider = DatabaseProvider.db;

  insertarDetallePedido(DetallePedidoModel detallePedidoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO DetallePedido (id_pedido,id_producto,id_good,"
          "cantidad,estado) "
              "VALUES ('${detallePedidoModel.idPedido}','${detallePedidoModel.idProducto}',"
              "'${detallePedidoModel.idGood}','${detallePedidoModel.cantidad}',"
              "'${detallePedidoModel.estado}')");

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