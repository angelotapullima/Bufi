import 'package:bufi/src/models/companyModel.dart';

class AgenteModel {
  AgenteModel({
    this.idAgente,
    this.idUser,
    this.idCuenta,
    this.idCity,
    this.agenteTipo,
    this.agenteNombre,
    this.agenteCodigo,
    this.agenteDireccion,
    this.agenteTelefono,
    this.agenteImagen,
    this.agenteCoordX,
    this.agenteCoordY,
    this.agenteEstado,
    this.idCuentaEmpresa,
    this.cuentaeCodigo,
    this.cuentaeSaldo,
    this.cuentaeMoneda,
    this.cuentaeDate,
    this.cuentaeEstado,
    this.idCompany,
    this.listCompany,
    // this.idCategory,
    // this.companyName,
    // this.companyRuc,
    // this.companyImage,
    // this.companyType,
    // this.companyShortcode,
    // this.companyDeliveryPropio,
    // this.companyDelivery,
    // this.companyEntrega,
    // this.companyTarjeta,
    // this.companyVerified,
    // this.companyRating,
    // this.companyCreatedAt,
    // this.companyJoin,
    // this.companyStatus,
    // this.companyMt,
  });

  String idAgente;
  String idUser;
  String idCuenta;
  String idCity;
  String agenteTipo;
  String agenteNombre;
  String agenteCodigo;
  String agenteDireccion;
  String agenteTelefono;
  String agenteImagen;
  String agenteCoordX;
  String agenteCoordY;
  String agenteEstado;
  String idCuentaEmpresa;
  String cuentaeCodigo;
  String cuentaeSaldo;
  String cuentaeMoneda;
  String cuentaeDate;
  String cuentaeEstado;
  String idCompany;
  List<CompanyModel> listCompany;
  // String idCategory;
  // String companyName;
  // String companyRuc;
  // String companyImage;
  // String companyType;
  // String companyShortcode;
  // String companyDeliveryPropio;
  // String companyDelivery;
  // String companyEntrega;
  // String companyTarjeta;
  // String companyVerified;
  // dynamic companyRating;
  // String companyCreatedAt;
  // DateTime companyJoin;
  // String companyStatus;
  // String companyMt;

  factory AgenteModel.fromJson(Map<String, dynamic> json) => AgenteModel(
        idAgente: json["id_agente"],
        idUser: json["id_user"],
        idCuenta: json["id_cuenta"],
        idCity: json["id_city"],
        agenteTipo: json["agente_tipo"],
        agenteNombre: json["agente_nombre"],
        agenteCodigo: json["agente_codigo"],
        agenteDireccion: json["agente_direccion"],
        agenteTelefono: json["agente_telefono"],
        agenteImagen: json["agente_imagen"],
        agenteCoordX: json["agente_coord_x"],
        agenteCoordY: json["agente_coord_y"],
        agenteEstado: json["agente_estado"],
        idCuentaEmpresa: json["id_cuenta_empresa"],
        cuentaeCodigo: json["cuentae_codigo"],
        cuentaeSaldo: json["cuentae_saldo"],
        cuentaeMoneda: json["cuentae_moneda"],
        cuentaeDate: json["cuentae_date"],
        cuentaeEstado: json["cuentae_estado"],
        idCompany: json["id_company"],
        // idCategory: json["id_category"],
        // companyName: json["company_name"],
        // companyRuc: json["company_ruc"],
        // companyImage: json["company_image"],
        // companyType: json["company_type"],
        // companyShortcode: json["company_shortcode"],
        // companyDeliveryPropio: json["company_delivery_propio"],
        // companyDelivery: json["company_delivery"],
        // companyEntrega: json["company_entrega"],
        // companyTarjeta: json["company_tarjeta"],
        // companyVerified: json["company_verified"],
        // companyRating: json["company_rating"],
        // companyCreatedAt: json["company_created_at"],
        // companyJoin: DateTime.parse(json["company_join"]),
        // companyStatus: json["company_status"],
        // companyMt: json["company_mt"],
      );

  Map<String, dynamic> toJson() => {
        "id_agente": idAgente,
        "id_user": idUser,
        "id_cuenta": idCuenta,
        "id_city": idCity,
        "agente_tipo": agenteTipo,
        "agente_nombre": agenteNombre,
        "agente_codigo": agenteCodigo,
        "agente_direccion": agenteDireccion,
        "agente_telefono": agenteTelefono,
        "agente_coord_x": agenteCoordX,
        "agente_coord_y": agenteCoordY,
        "agente_estado": agenteEstado,
        "id_cuenta_empresa": idCuentaEmpresa,
        "cuentae_codigo": cuentaeCodigo,
        "cuentae_saldo": cuentaeSaldo,
        "cuentae_moneda": cuentaeMoneda,
        "cuentae_date": cuentaeDate,
        "cuentae_estado": cuentaeEstado,
        "id_company": idCompany,
      };
}
