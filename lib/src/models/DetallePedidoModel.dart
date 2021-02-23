import 'package:bufi/src/models/productoModel.dart';

class DetallePedidoModel {
  DetallePedidoModel(
      {this.idDetallePedido,
      this.idPedido,
      this.idProducto,
      this.cantidad,
      this.detallePedidoSubtotal, this.listProducto});

  String idDetallePedido;
  String idPedido;
  String idProducto;
  String cantidad;
  String detallePedidoSubtotal;
  List<ProductoModel> listProducto;

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) =>
      DetallePedidoModel(
        idDetallePedido: json["id_detalle_pedido"],
        idPedido: json["id_pedido"],
        idProducto: json["id_producto"],
        cantidad: json["cantidad"],
        detallePedidoSubtotal: json["delivery_detail_subtotal"],
      );
}
