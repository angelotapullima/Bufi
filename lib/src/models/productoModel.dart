class ProductoModel {
  ProductoModel({
    this.idProducto,
    this.idSubsidiary,
    this.idGood,
    this.idItemsubcategory,
    this.productoName,
    this.productoPrice,
    this.productoCurrency,
    this.productoImage,
    this.productoCharacteristics,
    this.productoBrand,
    this.productoModel,
    this.productoType,
    this.productoSize,
    this.productoStock,
    this.productoMeasure,
    this.productoRating,
    this.productoUpdated,
    this.productoStatus,
    this.productoFavourite,
  });

  String idProducto;
  String idSubsidiary;
  String idGood;
  String idItemsubcategory;
  String productoPrice;
  String productoName;
  String productoCurrency;
  String productoImage;
  String productoCharacteristics;
  String productoBrand;
  String productoModel;
  String productoType;
  String productoSize;
  String productoStock;
  String productoMeasure;
  String productoRating;
  String productoUpdated;
  String productoStatus;

  String productoFavourite;

  factory ProductoModel.fromJson(Map<String, dynamic> json) =>
      ProductoModel(
        idProducto: json["id_producto"],
        idSubsidiary: json["id_subsidiary"],
        idGood: json["id_good"],
        idItemsubcategory: json["id_itemsubcategory"],
        productoName: json["producto_name"],
        productoPrice: json["producto_price"],
        productoCurrency: json["producto_currency"],
        productoImage: json["producto_image"],
        productoCharacteristics: json["sproducto_characteristics"],
        productoBrand: json["producto_brand"],
        productoModel: json["producto_model"],
        productoType: json["producto_type"],
        productoSize: json["producto_size"],
        productoStock: json["producto_stock"],
        productoMeasure: json["producto_measure"],
        productoRating: json["producto_rating"],
        productoUpdated: json["producto_updated"],
        productoStatus: json["producto_status"],
        productoFavourite: json["producto_favourite"],

      );

  /* Map<String, dynamic> toJson() => {
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
      }; */
}
