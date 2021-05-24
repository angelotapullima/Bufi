import 'package:bufi/src/models/carritoModel.dart';

class CarritoGeneralModel {
  String nombreSucursal;
  String idSubsidiary;
  List<CarritoModel> carrito;
  String monto;
  String tipoDeliverySeleccionado;
  String seleccion;

  CarritoGeneralModel(
      {this.nombreSucursal,
      this.idSubsidiary,
      this.carrito,
      this.monto,
      this.tipoDeliverySeleccionado,
      this.seleccion});
}

class CarritoGeneralSuperior {
  String montoGeneral;
  String cantidadArticulos;
  List<CarritoGeneralModel> car;

  CarritoGeneralSuperior({this.montoGeneral, this.cantidadArticulos, this.car});
}
