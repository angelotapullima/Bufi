import 'dart:convert';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PedidoApi {
  final prefs = new Preferences();

  final pedidoDb = PedidosDatabase();

  Future<dynamic> obtenerPedidosEnviados(
      String fechaInicial, String fechaFinal) async {
    final response = await http
        .post("$apiBaseURL/api/Pedido/buscar_pedidos_enviados_ws", body: {
      'fecha_i': '$fechaInicial',
      'fecha_f': '$fechaFinal',
      'estado': '99',
      'tn': prefs.token,
      'app': 'true'
    });

    final decodedData = json.decode(response.body);

    for (var i = 0; i < decodedData["result"]; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = decodedData[i]['id_delivery'];
      pedidosModel.idUser = decodedData[i]['id_user'];
      pedidosModel.idCity = decodedData[i]['id_city'];
      pedidosModel.idSubsidiary = decodedData[i]['id_subsidiary'];
      pedidosModel.deliveryNumber = decodedData[i]['delivery_number'];
      pedidosModel.deliveryName = decodedData[i]['delivery_name'];
      pedidosModel.deliveryEmail = decodedData[i]['delivery_email'];
      pedidosModel.deliveryCel = decodedData[i]['delivery_cel'];
      pedidosModel.deliveryAddress = decodedData[i]['delivery_address'];
      pedidosModel.deliveryDescription = decodedData[i]['delivery_description'];
      pedidosModel.deliveryCoordX = decodedData[i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY = decodedData[i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo = decodedData[i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData[i]['delivery_price'];
      pedidosModel.deliveryTotalOrden = decodedData[i]['delivery_total_orden'];
      pedidosModel.deliveryPayment = decodedData[i]['delivery_payment'];
      pedidosModel.deliveryEntrega = decodedData[i]['delivery_entrega'];
      pedidosModel.deliveryDatetime = decodedData[i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData[i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData[i]['delivery_mt'];

      await pedidoDb.insertarPedido(pedidosModel);
    }
    return 0;
  }
}
