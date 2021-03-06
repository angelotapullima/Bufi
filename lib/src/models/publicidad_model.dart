



class PublicidadModel{



  String idPublicidad;
  String idCity;
  String idSubsidiary;
  String publicidadImg;
  String publicidadOrden;
  String publicidadEstado;
  String publicidadDatetime;
  String idPago;

PublicidadModel({

  this.idPublicidad,
  this.idCity,
  this.idSubsidiary,
  this.publicidadImg,
  this.publicidadOrden,
  this.publicidadEstado,
  this.publicidadDatetime,
  this.idPago
});


factory PublicidadModel.fromJson(Map<String, dynamic> json) => PublicidadModel(
        idPublicidad: json["id_publicidad"],
        idCity: json["id_city"],
        idSubsidiary: json["id_subsidiary"],
        publicidadImg: json["publicidad_img"],
        publicidadOrden: json["publicidad_orden"],
        publicidadEstado: json["publicidad_estado"],
        publicidadDatetime: json["publicidad_datetime"],
        idPago: json["id_pago"],
      );


}