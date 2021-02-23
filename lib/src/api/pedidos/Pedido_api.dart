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
      //insertar a la tabla de Pedidos
      await pedidoDb.insertarPedido(pedidosModel);

      final sucursalModel = SubsidiaryModel();
      final sucursalDb = SubsidiaryDatabase();
      sucursalModel.subsidiaryName = decodedData[i]['subsidiary_name'];
      sucursalModel.subsidiaryAddress = decodedData[i]['subsidiary_address'];
      sucursalModel.subsidiaryCellphone =
          decodedData[i]['subsidiary_cellphone'];
      sucursalModel.subsidiaryCellphone2 =
          decodedData[i]['subsidiary_cellphone2'];
      sucursalModel.subsidiaryEmail = decodedData[i]['subsidiary_email'];
      sucursalModel.subsidiaryCoordX = decodedData[i]['subsidiary_coord_x'];
      sucursalModel.subsidiaryCoordY = decodedData[i]['subsidiary_coord_y'];
      sucursalModel.subsidiaryOpeningHours =
          decodedData[i]['subsidiary_opening_hours'];
      sucursalModel.subsidiaryPrincipal =
          decodedData[i]['subsidiary_principal'];
      sucursalModel.subsidiaryStatus = decodedData[i]['subsidiary_status'];
       //insertar a la tabla sucursal
      await sucursalDb.insertarSubsidiary(sucursalModel);

      final companyModel = CompanyModel();
      final companyDb = CompanyDatabase();
      companyModel.idCategory = decodedData[i]['id_category'];
      companyModel.companyName = decodedData[i]['company_name'];
      companyModel.companyRuc = decodedData[i]['company_ruc'];
      companyModel.companyImage = decodedData[i]['company_image'];
      companyModel.companyType = decodedData[i]['company_type'];
      companyModel.companyShortcode = decodedData[i]['company_shortcode'];
      companyModel.companyDeliveryPropio =
          decodedData[i]['company_delivery_propio'];
      companyModel.companyDelivery = decodedData[i]['company_delivery'];
      companyModel.companyEntrega = decodedData[i]['company_entrega'];
      companyModel.companyTarjeta = decodedData[i]['company_tarjeta'];
      companyModel.companyVerified = decodedData[i]['company_verified'];
      companyModel.companyRating = decodedData[i]['company_rating'];
      companyModel.companyCreatedAt = decodedData[i]['company_created_at'];
      companyModel.companyJoin = decodedData[i]['company_join'];
      companyModel.companyStatus = decodedData[i]['company_status'];
      companyModel.companyMt = decodedData[i]['company_mt'];
       //insertar a la tabla de Company
      await companyDb.insertarCompany(companyModel);

      final goodModel = BienesModel();
      final goodDb = GoodDatabase();
      goodModel.idGood = decodedData[i]['id_good'];
      goodModel.goodName = decodedData[i]['good_name'];
      goodModel.goodSynonyms = decodedData[i]['good_synonyms'];
      //insertar a la tabla de Company
      await goodDb.insertarGood(goodModel);

      //recorremos la segunda lista de detalle de pedidos
      for (var j = 0; j < decodedData[i]["detalle_pedido"].length; i++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido =decodedData[i]["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =decodedData[i]["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto =decodedData[i]["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad =decodedData[i]["detalle_pedido"][j]["delivery_detail_qty"];
        detallePedido.detallePedidoSubtotal =decodedData[i]["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertar a la tabla de Detalle de Pedidos
        await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }
    print(decodedData);
    return 0;
  }
}
