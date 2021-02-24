class CompanySubsidiaryModel {
  CompanySubsidiaryModel({
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
    this.idUser,
    this.idCity,
    this.idCategory,
    this.companyName,
    this.companyRuc,
    this.companyImage,
    this.companyType,
    this.companyShortcode,
    this.companyDeliveryPropio,
    this.companyDelivery,
    this.companyEntrega,
    this.companyTarjeta,
    this.companyVerified,
    this.companyRating,
    this.companyCreatedAt,
    this.companyJoin,
    this.companyStatus,
    this.companyMt,
    this.miNegocio,
    this.cell,
    this.direccion,
    this.favourite,
    this.categoriaName,
  });

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

  String idUser;
  String idCity;
  String idCategory;
  String companyName;
  dynamic companyRuc;
  String companyImage;
  String companyType;
  String companyShortcode;
  String companyDeliveryPropio;
  String companyDelivery;
  String companyEntrega;
  String companyTarjeta;
  String companyVerified;
  dynamic companyRating;
  String companyCreatedAt;
  String companyJoin;
  String companyStatus;
  String companyMt;
  String miNegocio;
  String favourite;

  String cell;
  String direccion;
  String categoriaName;

  factory CompanySubsidiaryModel.fromJson(Map<String, dynamic> json) =>
      CompanySubsidiaryModel(
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
        subsidiaryFavourite: json["subsidiary_favourite"],
        idUser: json["id_user"],
        idCity: json["id_city"],
        idCategory: json["id_category"],
        companyName: json["company_name"],
        companyRuc: json["company_ruc"],
        companyImage: json["company_image"],
        companyType: json["company_type"],
        companyShortcode: json["company_shortcode"],
        companyDeliveryPropio: json["company_delivery_propio"],
        companyDelivery: json["company_delivery"],
        companyEntrega: json["company_entrega"],
        companyTarjeta: json["company_tarjeta"],
        companyVerified: json["company_verified"],
        companyRating: json["company_rating"],
        companyCreatedAt: json["company_created_at"],
        companyJoin: json["company_join"],
        companyStatus: json["company_status"],
        companyMt: json["company_mt"],
        miNegocio: json["mi_negocio"],
      );

  Map<String, dynamic> toJson() => {
        "id_subsidiary": idSubsidiary,
        "id_company": idCompany,
        "subsidiary_name": subsidiaryName,
        "subsidiary_address": subsidiaryAddress,
        "subsidiary_cellphone": subsidiaryCellphone,
        "subsidiary_cellphone_2": subsidiaryCellphone2,
        "subsidiary_email": subsidiaryEmail,
        "subsidiary_coord_x": subsidiaryCoordX,
        "subsidiary_coord_y": subsidiaryCoordY,
        "subsidiary_opening_hours": subsidiaryOpeningHours,
        "subsidiary_principal": subsidiaryPrincipal,
        "subsidiary_status": subsidiaryStatus,
        "subsidiary_favourite": subsidiaryFavourite,
        "id_user": idUser,
        "id_city": idCity,
        "id_category": idCategory,
        "company_name": companyName,
        "company_ruc": companyRuc,
        "company_image": companyImage,
        "company_type": companyType,
        "company_shortcode": companyShortcode,
        "company_delivery": companyDelivery,
        "company_entrega": companyEntrega,
        "company_tarjeta": companyTarjeta,
        "company_verified": companyVerified,
        "company_rating": companyRating,
        "company_created_at": companyCreatedAt,
        "company_join": companyJoin,
        "company_status": companyStatus,
        "company_mt": companyMt,
        "mi_negocio": miNegocio,
      };
}
