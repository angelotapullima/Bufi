class PantallaPrincipalModel {
  String nombre;
  String tipo;
  String idPantalla;

  List<ProductosPantallaModel> productos;

  PantallaPrincipalModel({
    this.nombre,
    this.tipo,
    this.idPantalla,
    this.productos,
  });
}

class ProductosPantallaModel {
  String idProducto;
  String idPantalla;
}
