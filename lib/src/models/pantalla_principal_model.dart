import 'package:bufi/src/models/productoModel.dart';

class PantallaPrincipalModel {
  String nombre;
  String tipo;
  String idPantalla;

  List<ProductoModel> productos;

  PantallaPrincipalModel({
    this.nombre,
    this.tipo,
    this.idPantalla,
    this.productos,
  });

  factory PantallaPrincipalModel.fromJson(Map<String, dynamic> json) => PantallaPrincipalModel(
        idPantalla: json["idPantalla"],
        tipo: json["tipo"],
        nombre: json["nombre"],
      );
}

class ProductosPantallaModel {
  String idProducto;
  String idPantalla;

  ProductosPantallaModel({
    this.idProducto,
    this.idPantalla,
  });

  factory ProductosPantallaModel.fromJson(Map<String, dynamic> json) => ProductosPantallaModel(
        idPantalla: json["idPantalla"],
        idProducto: json["idProducto"],
      );
}
