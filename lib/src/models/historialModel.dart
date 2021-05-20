class HistorialModel {
  String historial;
  String fecha;

  HistorialModel({
    this.historial,
    this.fecha,
  });

  factory HistorialModel.fromJson(Map<String, dynamic> json) =>
      HistorialModel(historial: json["text"], fecha: json["fecha"]);
}
