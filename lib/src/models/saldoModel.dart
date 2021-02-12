


class SaldoModel{



  String idUser;
  String saldo;

SaldoModel({this.idUser,this.saldo});

factory SaldoModel.fromJson(Map<String, dynamic> json) =>
      SaldoModel(
        idUser: json["idUser"],
        saldo: json["saldo"],

      );

  

}