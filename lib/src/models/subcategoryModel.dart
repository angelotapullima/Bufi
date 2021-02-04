class SubcategoryModel {
  SubcategoryModel({
    this.idSubcategory,
    this.idCategory,
    this.subcategoryName,
  });

  String idSubcategory;
  String idCategory;
  String subcategoryName;

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
        idSubcategory: json["id_subcategory"],
        idCategory: json["id_category"],
        subcategoryName: json["subcategory_name"],
      );

  Map<String, dynamic> toJson() => {
        "id_subcategory": idSubcategory,
        "id_category": idCategory,
        "subcategory_name": subcategoryName,
      };
}
