


class TiposPagoModel{



  String idTipoPago;
  String tipoPagoNombre;
  String tipoPagoEstado;
  String tipoPagoMsj;
  String tipoPagoImg;
  String seleccionado;

  TiposPagoModel({
    this.idTipoPago,
    this.tipoPagoNombre,
    this.tipoPagoEstado,
    this.tipoPagoMsj,
    this.tipoPagoImg,
    this.seleccionado
  });


    factory TiposPagoModel.fromJson(Map<String, dynamic> json) =>
      TiposPagoModel(
          idTipoPago: json["id_tipo_pago"],
          tipoPagoNombre: json["tipo_pago_nombre"],
          tipoPagoEstado: json["tipo_pago_estado"],
          tipoPagoImg: json["tipo_pago_img"],
          tipoPagoMsj: json["tipo_pago_msj"],
          seleccionado: json["seleccionado"],
          );
}