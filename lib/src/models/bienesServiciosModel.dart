class BienesServiciosModel {
  BienesServiciosModel({
    this.idSubsidiarygood,
    this.idSubsidiary,
    this.idGood,
    this.idItemsubcategory,
    this.subsidiaryGoodName,
    this.subsidiaryGoodPrice,
    this.subsidiaryGoodCurrency,
    this.subsidiaryGoodImage,
    this.subsidiaryGoodCharacteristics,
    this.subsidiaryGoodBrand,
    this.subsidiaryGoodModel,
    this.subsidiaryGoodType,
    this.subsidiaryGoodSize,
    this.subsidiaryGoodStock,
    this.subsidiaryGoodMeasure,
    this.subsidiaryGoodRating,
    this.subsidiaryGoodUpdated,
    this.subsidiaryGoodStatus,
    this.subsidiaryGoodFavourite,
    //services
    this.idSubsidiaryservice,
    this.idService,
    this.subsidiaryServiceName,
    this.subsidiaryServiceDescription,
    this.subsidiaryServicePrice,
    this.subsidiaryServiceCurrency,
    this.subsidiaryServiceImage,
    this.subsidiaryServiceRating,
    this.subsidiaryServiceUpdated,
    this.subsidiaryServiceStatus,
    this.subsidiaryServiceFavourite,
    this.tipo,
  });

  String idSubsidiarygood;
  String idSubsidiary;
  String idGood;
  String idItemsubcategory;
  String subsidiaryGoodPrice;
  String subsidiaryGoodName;
  String subsidiaryGoodCurrency;
  String subsidiaryGoodImage;
  String subsidiaryGoodCharacteristics;
  String subsidiaryGoodBrand;
  String subsidiaryGoodModel;
  String subsidiaryGoodType;
  String subsidiaryGoodSize;
  String subsidiaryGoodStock;
  String subsidiaryGoodMeasure;
  String subsidiaryGoodRating;
  String subsidiaryGoodUpdated;
  String subsidiaryGoodStatus;
  String subsidiaryGoodFavourite;

  //Service
  String idSubsidiaryservice;
  String idService;
  String subsidiaryServiceName;
  String subsidiaryServiceDescription;
  String subsidiaryServicePrice;
  String subsidiaryServiceCurrency;
  String subsidiaryServiceImage;
  String subsidiaryServiceRating;
  String subsidiaryServiceUpdated;
  String subsidiaryServiceStatus;
  String subsidiaryServiceFavourite;

  String tipo;

  factory BienesServiciosModel.fromJson(Map<String, dynamic> json) =>
      BienesServiciosModel(
        idSubsidiarygood: json["id_subsidiarygood"],
        idSubsidiary: json["id_subsidiary"],
        idGood: json["id_good"],
        idItemsubcategory: json["id_itemsubcategory"],
        subsidiaryGoodName: json["subsidiary_good_name"],
        subsidiaryGoodPrice: json["subsidiary_good_price"],
        subsidiaryGoodCurrency: json["subsidiary_good_currency"],
        subsidiaryGoodImage: json["subsidiary_good_image"],
        subsidiaryGoodCharacteristics: json["subsidiary_good_characteristics"],
        subsidiaryGoodBrand: json["subsidiary_good_brand"],
        subsidiaryGoodModel: json["subsidiary_good_model"],
        subsidiaryGoodType: json["subsidiary_good_type"],
        subsidiaryGoodSize: json["subsidiary_good_size"],
        subsidiaryGoodStock: json["subsidiary_good_stock"],
        subsidiaryGoodMeasure: json["subsidiary_good_measure"],
        subsidiaryGoodRating: json["subsidiary_good_rating"],
        subsidiaryGoodUpdated: json["subsidiary_good_updated"],
        subsidiaryGoodStatus: json["subsidiary_good_status"],
        subsidiaryGoodFavourite: json["subsidiary_good_favourite"],
        //Service
        idSubsidiaryservice: json["id_subsidiaryservice"],
        idService: json["id_service"],
        subsidiaryServiceName: json["subsidiary_service_name"],
        subsidiaryServiceDescription: json["subsidiary_service_description"],
        subsidiaryServicePrice: json["subsidiary_service_price"],
        subsidiaryServiceCurrency: json["subsidiary_service_currency"],
        subsidiaryServiceImage: json["subsidiary_service_image"],
        subsidiaryServiceRating: json["subsidiary_service_rating"],
        subsidiaryServiceUpdated: json["subsidiary_service_updated"],
        subsidiaryServiceStatus: json["subsidiary_service_status"],
        subsidiaryServiceFavourite: json["subsidiary_service_favourite"],

        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id_subsidiarygood": idSubsidiarygood,
        "id_subsidiary": idSubsidiary,
        "id_good": idGood,
        "id_itemsubcategory": idItemsubcategory,
        "subsidiary_good_name": subsidiaryGoodName,
        "subsidiary_good_price": subsidiaryGoodPrice,
        "subsidiary_good_currency": subsidiaryGoodCurrency,
        "subsidiary_good_image": subsidiaryGoodImage,
        "subsidiary_good_characteristics": subsidiaryGoodCharacteristics,
        "subsidiary_good_brand": subsidiaryGoodBrand,
        "subsidiary_good_model": subsidiaryGoodModel,
        "subsidiary_good_type": subsidiaryGoodType,
        "subsidiary_good_size": subsidiaryGoodSize,
        "subsidiary_good_stock": subsidiaryGoodStock,
        "subsidiary_good_measure": subsidiaryGoodMeasure,
        "subsidiary_good_rating": subsidiaryGoodRating,
        "subsidiary_good_updated": subsidiaryGoodUpdated,
        "subsidiary_good_status": subsidiaryGoodStatus,
        "subsidiary_good_favourite": subsidiaryGoodFavourite,

        //Service
        "id_subsidiaryservice": idSubsidiaryservice,
        "id_service": idService,
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
