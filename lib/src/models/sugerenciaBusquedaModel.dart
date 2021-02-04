class SugerenciaBusquedaModel {
  SugerenciaBusquedaModel(
      {this.idBusqueda,
      this.idItemSubcategoria,
      this.nombreProducto,
      this.idProducto,
      this.tipo});

  String idBusqueda;
  String idItemSubcategoria;
  String nombreProducto;
  String idProducto;
  String tipo;

  factory SugerenciaBusquedaModel.fromJson(Map<String, dynamic> json) =>
      SugerenciaBusquedaModel(
          idItemSubcategoria: json["id_itemsubcategory"],
          nombreProducto: json["nombre_producto"],
          idProducto: json["id_producto"],
          tipo: json["tipo"]);
}
