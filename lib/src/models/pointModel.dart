import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';

class PointModel {
  PointModel(
      {this.idPoint,
      this.idUser,
      this.idSubsidiary,
      this.idCompany,
      this.subsidiaryName,
      this.subsidiaryAddress,
      this.subsidiaryCellphone,
      this.subsidiaryCellphone2,
      this.subsidiaryEmail,
      this.subsidiaryCoordX,
      this.subsidiaryCoordY,
      this.subsidiaryOpeningHours,
      this.subsidiaryPrincipal,
      this.subsidiaryStatus,
      this.subsidiaryFavourite,
      this.idCity,
      this.idCategory,
      this.companyName,
      this.companyRuc,
      this.companyImage,
      this.companyType,
      this.companyShortcode,
      this.companyDelivery,
      this.companyEntrega,
      this.companyTarjeta,
      this.companyVerified,
      this.companyRating,
      this.companyCreatedAt,
      this.companyJoin,
      this.companyStatus,
      this.companyMt,
      this.categoryName,
      this.listProducto});

  String idPoint;
  String idUser;
  String idSubsidiary;
  String idCompany;
  String subsidiaryName;
  String subsidiaryAddress;
  String subsidiaryCellphone;
  String subsidiaryCellphone2;
  String subsidiaryEmail;
  String subsidiaryCoordX;
  String subsidiaryCoordY;
  String subsidiaryOpeningHours;
  String subsidiaryPrincipal;
  String subsidiaryStatus;
  String subsidiaryFavourite;
  String idCity;
  String idCategory;
  String companyName;
  String companyRuc;
  String companyImage;
  String companyType;
  String companyShortcode;
  String companyDelivery;
  String companyEntrega;
  String companyTarjeta;
  String companyVerified;
  dynamic companyRating;
  String companyCreatedAt;
  String companyJoin;
  String companyStatus;
  String companyMt;
  String categoryName;
  List<ProductoModel> listProducto;
  List<SubsidiaryServiceModel> listServicio;

  factory PointModel.fromJson(Map<String, dynamic> json) => PointModel(
        idPoint: json["id_point"],
        idUser: json["id_user"],
        idSubsidiary: json["id_subsidiary"],
        idCompany: json["id_company"],
        subsidiaryName: json["subsidiary_name"],
        subsidiaryAddress: json["subsidiary_address"],
        subsidiaryCellphone: json["subsidiary_cellphone"],
        subsidiaryCellphone2: json["subsidiary_cellphone_2"],
        subsidiaryEmail: json["subsidiary_email"],
        subsidiaryCoordX: json["subsidiary_coord_x"],
        subsidiaryCoordY: json["subsidiary_coord_y"],
        subsidiaryOpeningHours: json["subsidiary_opening_hours"],
        subsidiaryPrincipal: json["subsidiary_principal"],
        subsidiaryStatus: json["subsidiary_status"],
        idCity: json["id_city"],
        idCategory: json["id_category"],
        companyName: json["company_name"],
        companyRuc: json["company_ruc"],
        companyImage: json["company_image"],
        companyType: json["company_type"],
        companyShortcode: json["company_shortcode"],
        companyDelivery: json["company_delivery"],
        companyEntrega: json["company_entrega"],
        companyTarjeta: json["company_tarjeta"],
        companyVerified: json["company_verified"],
        companyRating: json["company_rating"],
        companyCreatedAt: json["company_created_at"],
        companyJoin: json["company_join"],
        companyStatus: json["company_status"],
        companyMt: json["company_mt"],
        categoryName: json["category_name"],
      );
}
