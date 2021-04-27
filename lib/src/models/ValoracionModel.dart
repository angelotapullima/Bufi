class ValoracionModel {
  ValoracionModel({
    this.idValoracion,
    this.idPedido,
    this.idProducto,
    this.valoracionRating,
    this.comentario,
    this.imagen,
    this.valoracionDatetime,
  });

  String idValoracion;
  String idPedido;
  String idProducto;
  String valoracionRating;
  String comentario;
  String imagen;
  String valoracionDatetime;

  factory ValoracionModel.fromJson(Map<String, dynamic> json) =>
      ValoracionModel(
        idValoracion: json["id_valoracion"],
        idPedido: json["id_pedido"],
        idProducto: json["id_producto"],
        valoracionRating: json["valoracion_rating"],
        comentario: json["valoracion_comentario"],
        imagen: json["valoracion_imagen"],
        valoracionDatetime: json["valoracion_valoracionDatetime"],
      );
}
