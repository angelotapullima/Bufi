import 'dart:convert';

List<CategoriaModel> categoriaFromJson(String str) => List<CategoriaModel>.from(
    json.decode(str).map((x) => CategoriaModel.fromJson(x)));

String categoriaToJson(List<CategoriaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaModel {
  CategoriaModel({
    this.idCategory,
    this.categoryName,
    /* this.idSubcategory,
    this.subcategoryName, */
  });

  String idCategory;
  String categoryName;
  //String idSubcategory;
  //String subcategoryName;

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        idCategory: json["id_category"],
        categoryName: json["category_name"],
       /*  idSubcategory: json["id_subcategory"],
        subcategoryName: json["subcategory_name"] */
      );

  Map<String, dynamic> toJson() => {
        "id_category": idCategory,
        "category_name": categoryName,/* 
        "id_subcategory": idSubcategory,
        "subcategory_name": subcategoryName, */
      };
}
