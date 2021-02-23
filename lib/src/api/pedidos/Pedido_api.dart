import 'dart:convert';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/detallePedido_database.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PedidoApi {
  final prefs = new Preferences();

  final pedidoDb = PedidosDatabase();
  final detallePedidoDb = DetallePedidoDatabase();

  Future<dynamic> obtenerPedidosEnviados() async {
    final response = await http
        .post("$apiBaseURL/api/Pedido/buscar_pedidos_enviados_ws", body: {
      'fecha_i': '2021-01-01',
      'fecha_f': '2021-02-23',
      'estado': '99',
      'tn': prefs.token,
      'app': 'true'
    });

    final decodedData = json.decode(response.body);

//recorremos la lista de pedidos
    for (var i = 0; i < decodedData["result"].length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = decodedData["result"][i]['id_delivery'];
      pedidosModel.idUser = decodedData["result"][i]['id_user'];
      pedidosModel.idCity = decodedData["result"][i]['id_city'];
      pedidosModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
       pedidosModel.idCompany = decodedData["result"][i]['id_company'];
      pedidosModel.deliveryNumber = decodedData["result"][i]['delivery_number'];
      pedidosModel.deliveryName = decodedData["result"][i]['delivery_name'];
      pedidosModel.deliveryEmail = decodedData["result"][i]['delivery_email'];
      pedidosModel.deliveryCel = decodedData["result"][i]['delivery_cel'];
      pedidosModel.deliveryAddress = decodedData["result"][i]['delivery_address'];
      pedidosModel.deliveryDescription = decodedData["result"][i]['delivery_description'];
      pedidosModel.deliveryCoordX = decodedData["result"][i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY = decodedData["result"][i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo = decodedData["result"][i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData["result"][i]['delivery_price'];
      pedidosModel.deliveryTotalOrden = decodedData["result"][i]['delivery_total_orden'];
      pedidosModel.deliveryPayment = decodedData["result"][i]['delivery_payment'];
      pedidosModel.deliveryEntrega = decodedData["result"][i]['delivery_entrega'];
      pedidosModel.deliveryDatetime = decodedData["result"][i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData["result"][i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData["result"][i]['delivery_mt'];
      //insertar a la tabla de Pedidos
      await pedidoDb.insertarPedido(pedidosModel);

      final sucursalModel = SubsidiaryModel();
      final sucursalDb = SubsidiaryDatabase();
      sucursalModel.subsidiaryName = decodedData["result"][i]['subsidiary_name'];
      sucursalModel.subsidiaryAddress = decodedData["result"][i]['subsidiary_address'];
      sucursalModel.subsidiaryCellphone =
          decodedData["result"][i]['subsidiary_cellphone'];
      sucursalModel.subsidiaryCellphone2 =
          decodedData["result"][i]['subsidiary_cellphone2'];
      sucursalModel.subsidiaryEmail = decodedData["result"][i]['subsidiary_email'];
      sucursalModel.subsidiaryCoordX = decodedData["result"][i]['subsidiary_coord_x'];
      sucursalModel.subsidiaryCoordY = decodedData["result"][i]['subsidiary_coord_y'];
      sucursalModel.subsidiaryOpeningHours =
          decodedData["result"][i]['subsidiary_opening_hours'];
      sucursalModel.subsidiaryPrincipal =
          decodedData["result"][i]['subsidiary_principal'];
      sucursalModel.subsidiaryStatus = decodedData["result"][i]['subsidiary_status'];
       //insertar a la tabla sucursal
      await sucursalDb.insertarSubsidiary(sucursalModel);

      final companyModel = CompanyModel();
      final companyDb = CompanyDatabase();
      companyModel.idCategory = decodedData["result"][i]['id_category'];
      companyModel.companyName = decodedData["result"][i]['company_name'];
      companyModel.companyRuc = decodedData["result"][i]['company_ruc'];
      companyModel.companyImage = decodedData["result"][i]['company_image'];
      companyModel.companyType = decodedData["result"][i]['company_type'];
      companyModel.companyShortcode = decodedData["result"][i]['company_shortcode'];
      companyModel.companyDeliveryPropio = decodedData["result"][i]['company_delivery_propio'];
      companyModel.companyDelivery = decodedData["result"][i]['company_delivery'];
      companyModel.companyEntrega = decodedData["result"][i]['company_entrega'];
      companyModel.companyTarjeta = decodedData["result"][i]['company_tarjeta'];
      companyModel.companyVerified = decodedData["result"][i]['company_verified'];
      companyModel.companyRating = decodedData["result"][i]['company_rating'];
      companyModel.companyCreatedAt = decodedData["result"][i]['company_created_at'];
      companyModel.companyJoin = decodedData["result"][i]['company_join'];
      companyModel.companyStatus = decodedData["result"][i]['company_status'];
      companyModel.companyMt = decodedData["result"][i]['company_mt'];
       //insertar a la tabla de Company
      await companyDb.insertarCompany(companyModel);

      final goodModel = BienesModel();
      final goodDb = GoodDatabase();
      goodModel.idGood = decodedData["result"][i]['id_good'];
      goodModel.goodName = decodedData["result"][i]['good_name'];
      goodModel.goodSynonyms = decodedData["result"][i]['good_synonyms'];
      //insertar a la tabla de Company
      await goodDb.insertarGood(goodModel);

      //recorremos la segunda lista de detalle de pedidos
      for (var j = 0; j < decodedData["result"][i]["detalle_pedido"].length; j++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido =decodedData["result"][i]["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =decodedData["result"][i]["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto =decodedData["result"][i]["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad =decodedData["result"][i]["detalle_pedido"][j]["delivery_detail_qty"];
        detallePedido.detallePedidoSubtotal =decodedData["result"][i]["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertar a la tabla de Detalle de Pedidos
        await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }
    //print(decodedData);
    return 0;
  }
}
