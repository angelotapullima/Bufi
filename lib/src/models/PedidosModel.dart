import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';

class PedidosModel {
  PedidosModel({
    this.idPedido,
    this.idUser,
    this.idCity,
    this.idSubsidiary,
    this.idCompany,
    this.deliveryNumber,
    this.deliveryName,
    this.deliveryEmail,
    this.deliveryCel,
    this.deliveryAddress,
    this.deliveryDescription,
    this.deliveryCoordX,
    this.deliveryCoordY,
    this.deliveryAddInfo,
    this.deliveryPrice,
    this.deliveryTotalOrden,
    this.deliveryPayment,
    this.deliveryEntrega,
    this.deliveryDatetime,
    this.deliveryStatus,
    this.deliveryMt,
    this.detallePedido,
    this.listCompanySubsidiary,
    // this.idCompany,
    // this.subsidiaryName,
    // this.subsidiaryAddress,
    // this.subsidiaryCellphone,
    // this.subsidiaryCellphone2,
    // this.subsidiaryEmail,
    // this.subsidiaryCoordX,
    // this.subsidiaryCoordY,
    // this.subsidiaryOpeningHours,
    // this.subsidiaryPrincipal,
    // this.subsidiaryStatus,
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
    // this.detallePedido,
  });

  String idPedido;
  String idUser;
  String idCity;
  String idSubsidiary;
  String idCompany;
  String deliveryNumber;
  String deliveryName;
  String deliveryEmail;
  String deliveryCel;
  String deliveryAddress;
  String deliveryDescription;
  String deliveryCoordX;
  String deliveryCoordY;
  String deliveryAddInfo;
  String deliveryPrice;
  String deliveryTotalOrden;
  String deliveryPayment;
  String deliveryEntrega;
  String deliveryDatetime;
  String deliveryStatus;
  String deliveryMt;
  List<DetallePedidoModel> detallePedido;
  List<CompanySubsidiaryModel> listCompanySubsidiary;
  // String idCompany;
  // String subsidiaryName;
  // String subsidiaryAddress;
  // String subsidiaryCellphone;
  // String subsidiaryCellphone2;
  // String subsidiaryEmail;
  // String subsidiaryCoordX;
  // String subsidiaryCoordY;
  // String subsidiaryOpeningHours;
  // String subsidiaryPrincipal;
  // String subsidiaryStatus;
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
  // List<Map<String, String>> detallePedido;

  factory PedidosModel.fromJson(Map<String, dynamic> json) => PedidosModel(
        idPedido: json["id_pedido"],
        idUser: json["id_user"],
        idCity: json["id_city"],
        idSubsidiary: json["id_subsidiary"],
        idCompany: json["id_company"],
        deliveryNumber: json["delivery_number"],
        deliveryName: json["delivery_name"],
        deliveryEmail: json["delivery_email"],
        deliveryCel: json["delivery_cel"],
        deliveryAddress: json["delivery_address"],
        deliveryDescription: json["delivery_description"],
        deliveryCoordX: json["delivery_coord_x"],
        deliveryCoordY: json["delivery_coord_y"],
        deliveryAddInfo: json["delivery_add_info"],
        deliveryPrice: json["delivery_price"],
        deliveryTotalOrden: json["delivery_total_orden"],
        deliveryPayment: json["delivery_payment"],
        deliveryEntrega: json["delivery_entrega"],
        deliveryDatetime: json["delivery_datetime"],
        deliveryStatus: json["delivery_status"],
        deliveryMt: json["delivery_mt"],
        // idCompany: json["id_company"],
        // subsidiaryName: json["subsidiary_name"],
        // subsidiaryAddress: json["subsidiary_address"],
        // subsidiaryCellphone: json["subsidiary_cellphone"],
        // subsidiaryCellphone2: json["subsidiary_cellphone_2"],
        // subsidiaryEmail: json["subsidiary_email"],
        // subsidiaryCoordX: json["subsidiary_coord_x"],
        // subsidiaryCoordY: json["subsidiary_coord_y"],
        // subsidiaryOpeningHours: json["subsidiary_opening_hours"],
        // subsidiaryPrincipal: json["subsidiary_principal"],
        // subsidiaryStatus: json["subsidiary_status"],
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
        // detallePedido: List<Map<String, String>>.from(json["detalle_pedido"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v == null ? null : v)))),
      );

  Map<String, dynamic> toJson() => {
        "id_delivery": idPedido,
        "id_user": idUser,
        "id_city": idCity,
        "id_subsidiary": idSubsidiary,
        "delivery_number": deliveryNumber,
        "delivery_name": deliveryName,
        "delivery_email": deliveryEmail,
        "delivery_cel": deliveryCel,
        "delivery_address": deliveryAddress,
        "delivery_description": deliveryDescription,
        "delivery_coord_x": deliveryCoordX,
        "delivery_coord_y": deliveryCoordY,
        "delivery_add_info": deliveryAddInfo,
        "delivery_price": deliveryPrice,
        "delivery_total_orden": deliveryTotalOrden,
        "delivery_payment": deliveryPayment,
        "delivery_entrega": deliveryEntrega,
        "delivery_datetime": deliveryDatetime,
        "delivery_status": deliveryStatus,
        "delivery_mt": deliveryMt,
        // "id_company": idCompany,
        // "subsidiary_name": subsidiaryName,
        // "subsidiary_address": subsidiaryAddress,
        // "subsidiary_cellphone": subsidiaryCellphone,
        // "subsidiary_cellphone_2": subsidiaryCellphone2,
        // "subsidiary_email": subsidiaryEmail,
        // "subsidiary_coord_x": subsidiaryCoordX,
        // "subsidiary_coord_y": subsidiaryCoordY,
        // "subsidiary_opening_hours": subsidiaryOpeningHours,
        // "subsidiary_principal": subsidiaryPrincipal,
        // "subsidiary_status": subsidiaryStatus,
        // "id_category": idCategory,
        // "company_name": companyName,
        // "company_ruc": companyRuc,
        // "company_image": companyImage,
        // "company_type": companyType,
        // "company_shortcode": companyShortcode,
        // "company_delivery_propio": companyDeliveryPropio,
        // "company_delivery": companyDelivery,
        // "company_entrega": companyEntrega,
        // "company_tarjeta": companyTarjeta,
        // "company_verified": companyVerified,
        // "company_rating": companyRating,
        // "company_created_at": companyCreatedAt,
        // "company_join": companyJoin.toIso8601String(),
        // "company_status": companyStatus,
        // "company_mt": companyMt,
        // "detalle_pedido": List<dynamic>.from(detallePedido.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
      };
}
