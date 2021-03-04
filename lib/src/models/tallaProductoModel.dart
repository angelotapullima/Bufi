
class TallaProductoModel{
  TallaProductoModel(
      {this.idTallaProducto,
       this.idProducto,
      this.tallaProducto,
      this.tallaProductoStatus,
      this.estado});

  String idTallaProducto;
  String idProducto;
  String tallaProducto;
  String tallaProductoStatus;
  String estado;
 

  factory TallaProductoModel.fromJson(Map<String, dynamic> json) =>
      TallaProductoModel(
        idTallaProducto: json["id_talla_producto"],
        idProducto: json["id_producto"],
        tallaProducto: json["talla_producto"],
        tallaProductoStatus: json["talla_status_producto"],
        estado: json["estado"],
      );
}
