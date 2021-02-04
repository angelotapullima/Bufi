import 'dart:convert';

UsuarioModel usuarioFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  Result result;
  Data data;

  UsuarioModel({
    this.result,
    this.data,
  });

  //recibe un json y lo transforma a un Modelo
  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        result: Result.fromJson(json["result"]),
        data: Data.fromJson(json["data"]),
      );

  //recibe un modelo y lo transforma a un JSON
  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String idUser;
  String idCity;
  String idPerson;
  String userNickname;
  String userEmail;
  String userImage;
  String personName;
  String personSurname;
  String idRoleUser;
  String roleName;
  String token;

  Data({
    this.idUser,
    this.idCity,
    this.idPerson,
    this.userNickname,
    this.userEmail,
    this.userImage,
    this.personName,
    this.personSurname,
    this.idRoleUser,
    this.roleName,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["c_u"],
        idCity: json["c_c"],
        idPerson: json["c_p"],
        userNickname: json["_n"],
        userEmail: json["u_e"],
        userImage: json["u_i"],
        personName: json["p_n"],
        personSurname: json["p_s"],
        idRoleUser: json["ru"],
        roleName: json["rn"],
        token: json["tn"],
      );

  Map<String, dynamic> toJson() => {
        "c_u": idUser,
        "c_c": idCity,
        "c_p": idPerson,
        "_n": userNickname,
        "u_e": userEmail,
        "u_i": userImage,
        "p_n": personName,
        "p_s": personSurname,
        "ru": idRoleUser,
        "rn": roleName,
        "tn": token,
      };
}

class Result {
  int code;
  String message;

  Result({
    this.code,
    this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
