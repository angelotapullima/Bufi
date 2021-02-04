class SubsidiaryModel {
  
  SubsidiaryModel({
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

  factory SubsidiaryModel.fromJson(Map<String, dynamic> json) =>
      SubsidiaryModel(
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
      };
}
