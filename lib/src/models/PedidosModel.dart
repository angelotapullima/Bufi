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
       };
}
