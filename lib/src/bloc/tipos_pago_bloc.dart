

import 'package:bufi/src/database/tipo_pago_database.dart';
import 'package:bufi/src/models/tipos_pago_model.dart';
import 'package:rxdart/rxdart.dart';

class TiposPagoBloc{

final tiposPagoDatabase = TiposPagoDatabase();
 final _tiposPagoController = BehaviorSubject<List<TiposPagoModel>>();
 final _mensajeTiposPagoController = BehaviorSubject<List<TiposPagoModel>>();

  Stream<List<TiposPagoModel>> get tiposPagoStream => _tiposPagoController.stream;
  Stream<List<TiposPagoModel>> get mensajeTipoPagoSeleccionadoStream => _mensajeTiposPagoController.stream;

  void dispose() {
    _tiposPagoController?.close();
    _mensajeTiposPagoController?.close();
  }

  void obtenerTiposPago() async {
    _tiposPagoController.sink.add( await tiposPagoDatabase.obtenerTiposPago());
 
  }

  void obtenerTipoPagoSeleccionado() async {
    _mensajeTiposPagoController.sink.add( await tiposPagoDatabase.obtenerTiposPagoSeleccionado());
 
  }

}