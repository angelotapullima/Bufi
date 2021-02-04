class BienesModel {
  BienesModel({
    this.idGood,
    this.goodName,
    this.goodSynonyms,
  });

  String idGood;
  String goodName;
  String goodSynonyms;

  factory BienesModel.fromJson(Map<String, dynamic> json) => BienesModel(
        idGood: json["id_good"],
        goodName: json["good_name"],
        goodSynonyms: json["good_synonyms"],
      );

  Map<String, dynamic> toJson() => {
        "id_good": idGood,
        "good_name": goodName,
        "good_synonyms": goodSynonyms,
      };
}
