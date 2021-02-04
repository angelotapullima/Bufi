class ServiciosModel {
  ServiciosModel({
    this.idService,
    this.serviceName,
    this.serviceSynonyms,
  });

  String idService;
  String serviceName;
  String serviceSynonyms;

  factory ServiciosModel.fromJson(Map<String, dynamic> json) =>
      ServiciosModel(
        idService: json["id_service"],
        serviceName: json["service_name"],
        serviceSynonyms: json["service_synonyms"],
      );

  Map<String, dynamic> toJson() => {
        "id_service": idService,
        "service_name": serviceName,
        "service_synonyms": serviceSynonyms,
      };
}