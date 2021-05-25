class HistorialModel {
  String historial;
  String fecha;
  String pageBusqueda;

  HistorialModel({
    this.historial,
    this.fecha,
    this.pageBusqueda,
  });

  factory HistorialModel.fromJson(Map<String, dynamic> json) => HistorialModel(
        historial: json["text"],
        fecha: json["fecha"],
        pageBusqueda: json["page_busqueda"],
      );
}
