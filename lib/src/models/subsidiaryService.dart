import 'package:bufi/src/models/subsidiaryModel.dart';

class SubsidiaryServiceModel {
  SubsidiaryServiceModel({
    this.idSubsidiaryservice,
    this.idSubsidiary,
    this.idService,
    this.idItemsubcategory,
    this.subsidiaryServiceName,
    this.subsidiaryServiceDescription,
    this.subsidiaryServicePrice,
    this.subsidiaryServiceCurrency,
    this.subsidiaryServiceImage,
    this.subsidiaryServiceRating,
    this.subsidiaryServiceUpdated,
    this.subsidiaryServiceStatus,
    this.subsidiaryServiceFavourite,
    this.listSubsidiary,
  });

  String idSubsidiaryservice;
  String idSubsidiary;
  String idService;
  String idItemsubcategory;
  String subsidiaryServiceName;
  String subsidiaryServiceDescription;
  String subsidiaryServicePrice;
  String subsidiaryServiceCurrency;
  String subsidiaryServiceImage;
  String subsidiaryServiceRating;
  String subsidiaryServiceUpdated;
  String subsidiaryServiceStatus;
  String subsidiaryServiceFavourite;
  List<SubsidiaryModel> listSubsidiary;

  factory SubsidiaryServiceModel.fromJson(Map<String, dynamic> json) =>
      SubsidiaryServiceModel(
        idSubsidiaryservice: json["id_subsidiaryservice"],
        idSubsidiary: json["id_subsidiary"],
        idService: json["id_service"],
        idItemsubcategory: json["id_itemsubcategory"],
        subsidiaryServiceName: json["subsidiary_service_name"],
        subsidiaryServiceDescription: json["subsidiary_service_description"],
        subsidiaryServicePrice: json["subsidiary_service_price"],
        subsidiaryServiceCurrency: json["subsidiary_service_currency"],
        subsidiaryServiceImage: json["subsidiary_service_image"],
        subsidiaryServiceRating: json["subsidiary_service_rating"],
        subsidiaryServiceUpdated: json["subsidiary_service_updated"],
        subsidiaryServiceStatus: json["subsidiary_service_status"],
        subsidiaryServiceFavourite: json["subsidiary_service_favourite"],
      );

  Map<String, dynamic> toJson() => {
        "id_subsidiaryservice": idSubsidiaryservice,
        "id_subsidiary": idSubsidiary,
        "id_service": idService,
        "id_itemsubcategory": idItemsubcategory,
        "subsidiary_service_name": subsidiaryServiceName,
        "subsidiary_service_description": subsidiaryServiceDescription,
        "subsidiary_service_price": subsidiaryServicePrice,
        "subsidiary_service_currency": subsidiaryServiceCurrency,
        "subsidiary_service_image": subsidiaryServiceImage,
        "subsidiary_service_rating": subsidiaryServiceRating,
        "subsidiary_service_updated": subsidiaryServiceUpdated,
        "subsidiary_service_status": subsidiaryServiceStatus,
        "subsidiary_service_favourite": subsidiaryServiceFavourite,
      };
}
