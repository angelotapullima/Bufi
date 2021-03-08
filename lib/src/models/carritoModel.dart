class CarritoModel {
  String idSubsidiaryGood;
  String idSubsidiary;
  String nombre;
  String precio;
  String marca;
  String modelo;
  String talla;
  String image;
  String caracteristicas;
  String stock;
  String cantidad;
  String estadoSeleccionado;
  String moneda;
  String size;

  //String tipo;

  CarritoModel({
    this.idSubsidiaryGood,
    this.idSubsidiary,
    this.nombre,
    this.precio,
    this.marca,
    this.modelo,
    this.talla,
    this.image,
    this.caracteristicas,
    this.stock,
    this.cantidad,
    this.estadoSeleccionado,
    this.moneda,
    this.size,
  });

  factory CarritoModel.fromJson(Map<String, dynamic> json) => CarritoModel(
      idSubsidiaryGood: json["id_subsidiarygood"],
      idSubsidiary: json["id_subsidiary"],
      nombre: json["nombre"],
      precio: json["precio"],
      marca: json["marca"],
      talla: json["talla"],
      modelo: json["modelo"],
      moneda: json["moneda"],
      image: json["image"],
      caracteristicas: json["caracteristicas"],
      stock: json["stock"],
      cantidad: json["cantidad"],
      estadoSeleccionado: json["estado_seleccionado"]
      //tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id_subsidiarygood": idSubsidiaryGood,
        "id_subsidiary": idSubsidiary,
        "nombre": nombre,
        "precio": precio,
        "marca": marca,
        "image": image,
        "caracteristicas": caracteristicas,
        "stock": stock,
        "cantidad": cantidad,
        "estado_seleccionado": estadoSeleccionado,
        //"tipo": tipo
      };
}
