import 'package:bufi/src/models/productoModel.dart';

class DetallePedidoModel {
  DetallePedidoModel(
      {this.idDetallePedido,
      this.idPedido,
      this.idProducto,
      this.cantidad,
      this.detallePedidoMarca,
      this.detallePedidoModelo,
      this.detallePedidoTalla,
      this.detallePedidoValorado,
      this.detallePedidoSubtotal,
      this.listProducto});

  String idDetallePedido;
  String idPedido;
  String idProducto;
  String cantidad;
  String detallePedidoMarca;
  String detallePedidoModelo;
  String detallePedidoTalla;
  String detallePedidoValorado;
  String detallePedidoSubtotal;

  List<ProductoModel> listProducto;

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) =>
      DetallePedidoModel(
        idDetallePedido: json["id_detalle_pedido"],
        idPedido: json["id_pedido"],
        idProducto: json["id_producto"],
        cantidad: json["cantidad"],
        detallePedidoMarca: json["detalle_pedido_marca"],
        detallePedidoModelo: json["detalle_pedido_modelo"],
        detallePedidoTalla: json["detalle_pedido_talla"],
        detallePedidoValorado:json["detalle_pedido_valorado"],
        detallePedidoSubtotal: json["delivery_detail_subtotal"],
      );
}
