class SearchHistoryModel {
  String idBusqueda; //Se refiere al id del producto o servicio
  String nombreBusqueda; //Nombre del servicio o producto
  String tipoBusqueda; // si es servicio o producto
  String img;
  String fecha;

  SearchHistoryModel(
      {this.idBusqueda,
      this.nombreBusqueda,
      this.tipoBusqueda,
      this.img,
      this.fecha});

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      SearchHistoryModel(
          idBusqueda: json["id_busqueda"],
          nombreBusqueda: json["nombre_busqueda"],
          tipoBusqueda: json["tipo_busqueda"],
          img: json['img'],
          fecha: json["fecha"]);
}
