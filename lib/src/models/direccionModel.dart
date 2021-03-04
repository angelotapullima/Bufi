class DireccionModel {
  String address;
  String referencia;
  String distrito;
  String coordx;
  String coordy;
  String estado;

  DireccionModel({
    this.address,
    this.referencia,
    this.distrito,
    this.coordx,
    this.coordy,
    this.estado,
  });

  factory DireccionModel.fromJson(Map<String, dynamic> json) => DireccionModel(
        address: json["address"],
        referencia: json["referencia"],
        distrito: json["distrito"],
        coordx: json["coord_x"],
        coordy: json["coord_y"],
        estado: json["estado"],
      );

 
}
