class CompanyModel {
  CompanyModel({
    this.idCompany,
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
  });

  String idCompany;
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

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        idCompany: json["id_company"],
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
        "id_company": idCompany,
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
