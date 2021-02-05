

import 'package:bufi/src/models/carritoModel.dart';

class CarritoGeneralModel {
  String nombre;
  String idSubsidiary;
  List<CarritoModel> carrito;
  String monto;

  CarritoGeneralModel({this.nombre,this.idSubsidiary, this.carrito,this.monto});
}