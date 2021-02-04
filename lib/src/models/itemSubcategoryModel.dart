class ItemSubCategoriaModel {
  ItemSubCategoriaModel({
    this.idItemsubcategory,
    this.idSubcategory,
    this.itemsubcategoryName,
  });

  String idItemsubcategory;
  String idSubcategory;
  String itemsubcategoryName;

  factory ItemSubCategoriaModel.fromJson(Map<String, dynamic> json) =>
      ItemSubCategoriaModel(
        idItemsubcategory: json["id_itemsubcategory"],
        idSubcategory: json["id_subcategory"],
        itemsubcategoryName: json["itemsubcategory_name"],
      );

  Map<String, dynamic> toJson() => {
        "id_itemsubcategory": idItemsubcategory,
        "id_subcategory": idSubcategory,
        "itemsubcategory_name": itemsubcategoryName,
      };
}
