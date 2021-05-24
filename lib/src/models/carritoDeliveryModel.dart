class CarritoDeliveryModel {
  String idSubsidiary;
  String tipoDeliverySeleccionado;

  CarritoDeliveryModel({this.idSubsidiary, this.tipoDeliverySeleccionado});

  factory CarritoDeliveryModel.fromJson(Map<String, dynamic> json) =>
      CarritoDeliveryModel(
        idSubsidiary: json["id_subsidiary"],
        tipoDeliverySeleccionado: json["tipo_delivery_seleccionado"],
      );
}
