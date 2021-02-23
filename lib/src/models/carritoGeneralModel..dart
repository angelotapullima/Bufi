

import 'package:bufi/src/models/carritoModel.dart';

class CarritoGeneralModel {
  String nombreSucursal;
  String idSubsidiary;
  List<CarritoModel> carrito;
  String monto;

  CarritoGeneralModel({this.nombreSucursal,this.idSubsidiary, this.carrito,this.monto});
}


class CarritoGeneralSuperior{



  String montoGeneral;
  String cantidadArticulos;
  List<CarritoGeneralModel> car;

CarritoGeneralSuperior({

  this.montoGeneral,
  this.cantidadArticulos,
  this.car
});

}