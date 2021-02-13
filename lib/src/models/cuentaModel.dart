class CuentaModel {
  String idCuenta;
  String idUser;
  String cuentaCodigo;
  String cuentaSaldo;
  String cuentaMoneda;
  String cuentaDate;
  String cuentaEstado;

  CuentaModel(
      {this.idCuenta,
      this.idUser,
      this.cuentaCodigo,
      this.cuentaSaldo,
      this.cuentaMoneda,
      this.cuentaDate,
      this.cuentaEstado});

  factory CuentaModel.fromJson(Map<String, dynamic> json) => CuentaModel(
        idCuenta: json["id_cuenta"],
        idUser: json["idUser"],
        cuentaCodigo: json["cuenta_codigo"],
        cuentaSaldo: json["cuenta_saldo"],
        cuentaMoneda: json["cuenta_moneda"],
        cuentaDate: json["cuenta_date"],
        cuentaEstado: json["cuenta_estado"],
      );
}
