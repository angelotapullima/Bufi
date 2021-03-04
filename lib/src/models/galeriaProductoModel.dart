
class GaleriaProductoModel{
  GaleriaProductoModel(
      {this.idGaleriaProducto,
       this.idProducto,
      this.galeriaFoto,
      this.estado});

  String idGaleriaProducto;
  String idProducto;
  String galeriaFoto;
  String estado;
 

  factory GaleriaProductoModel.fromJson(Map<String, dynamic> json) =>
      GaleriaProductoModel(
        idGaleriaProducto: json["id_producto_galeria"],
        idProducto: json["id_producto"],
        galeriaFoto: json["galeria_foto"],
        estado: json["estado"],
      );
}
