class ItemSubCategoriaModel {
  ItemSubCategoriaModel({
    this.idItemsubcategory,
    this.idSubcategory,
    this.itemsubcategoryName,
    this.itemsubcategoryImage,
    this.itemsubcategoryEstado,
  });

  String idItemsubcategory;
  String idSubcategory;
  String itemsubcategoryName;
  String itemsubcategoryImage;
  String itemsubcategoryEstado;

  factory ItemSubCategoriaModel.fromJson(Map<String, dynamic> json) =>
      ItemSubCategoriaModel(
        idItemsubcategory: json["id_itemsubcategory"],
        idSubcategory: json["id_subcategory"],
        itemsubcategoryName: json["itemsubcategory_name"],
        itemsubcategoryImage:json["itemsubcategory_img"],
        itemsubcategoryEstado:json["itemsubcategory_estado"],
        
      );

  Map<String, dynamic> toJson() => {
        "id_itemsubcategory": idItemsubcategory,
        "id_subcategory": idSubcategory,
        "itemsubcategory_name": itemsubcategoryName,
      };
}
