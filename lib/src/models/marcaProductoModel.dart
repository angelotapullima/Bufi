
class MarcaProductoModel{
  MarcaProductoModel(
      {this.idMarcaProducto,
       this.idProducto,
      this.marcaProducto,
      this.marcaStatusProducto,
      this.estado});

  String idMarcaProducto;
  String idProducto;
  String marcaProducto;
  String marcaStatusProducto;
  String estado;
 

  factory MarcaProductoModel.fromJson(Map<String, dynamic> json) =>
      MarcaProductoModel(
        idMarcaProducto: json["id_marca_producto"],
        idProducto: json["id_producto"],
        marcaProducto: json["marca_producto"],
        marcaStatusProducto: json["marca_status_producto"],
        estado: json["estado"],
      );
}
