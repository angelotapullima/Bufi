class DetallePedidoModel {
  DetallePedidoModel(
      {this.idDetallePedido,
      this.idPedido,
      this.idProducto,
      this.cantidad,
     this.detallePedidoSubtotal});
  String idDetallePedido;
  String idPedido;
  String idProducto;
  String cantidad;
  //String estado;
  String detallePedidoSubtotal;
  


  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) =>
      DetallePedidoModel(
          idDetallePedido: json["id_detalle_pedido"],
          idPedido: json["id_pedido"],
          idProducto: json["id_producto"],
          cantidad: json["cantidad"],
         // estado: json["estado"],
          detallePedidoSubtotal: json["delivery_detail_subtotal"],
          );
          
}
