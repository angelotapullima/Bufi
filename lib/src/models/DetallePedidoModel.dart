class DetallePedidoModel {
  DetallePedidoModel(
      {this.idDetallePedido,
      this.idPedido,
      this.idProducto,
      this.idGood,
      this.cantidad,
      this.estado});
  String idDetallePedido;
  String idPedido;
  String idProducto;
   String idGood;
  String cantidad;
  String estado;

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) =>
      DetallePedidoModel(
          idDetallePedido: json["id_detalle_pedido"],
          idPedido: json["id_pedido"],
          idProducto: json["id_producto"],
          idGood: json["id_good"],
          cantidad: json["cantidad"],
          estado: json["estado"]);
}
