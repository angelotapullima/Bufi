

class MisMovimientosModel{

  String nroOperacion;
  String concepto;
  String tipoPago;
  String monto;
  String comision;
  String fecha;
  String soloFecha;
  String ind;


  MisMovimientosModel({
    this.nroOperacion,
    this.concepto,
    this.tipoPago,
    this.monto,
    this.comision,
    this.fecha,
    this.soloFecha,
    this.ind, 
  });

  factory MisMovimientosModel.fromJson(Map<String, dynamic> json) => MisMovimientosModel( 
    nroOperacion: json["nroOperacion"],
    concepto: json["concepto"],
    tipoPago: json["tipoPago"],
    monto: json["monto"],
    comision: json["comision"],
    fecha: json["fecha"],
    soloFecha: json["soloFecha"],
    ind: json["ind"],
  );


}