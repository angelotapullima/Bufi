
class ModeloProductoModel{
  ModeloProductoModel(
      {this.idModeloProducto,
       this.idProducto,
      this.modeloProducto,
      this.modeloStatusProducto,
      this.estado});

  String idModeloProducto;
  String idProducto;
  String modeloProducto;
  String modeloStatusProducto;
  String estado;
 

  factory ModeloProductoModel.fromJson(Map<String, dynamic> json) =>
      ModeloProductoModel(
        idModeloProducto: json["id_modelo_producto"],
        idProducto: json["id_producto"],
        modeloProducto: json["modelo_producto"],
        modeloStatusProducto: json["modelo_status_producto"],
        estado: json["estado"],
      );
}
