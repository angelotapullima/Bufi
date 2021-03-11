


import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/bloc/login_bloc.dart';

import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:rxdart/subjects.dart';

class RegistroSucursalBloc with Validators {
  //instanciar la bd
  final registroSucursalDataBase = SubsidiaryDatabase();
  final registroSucursalApi = NegociosApi();
  //final registroSucursalModel = SubsidiaryModel();

  final _nombreSucursalController = BehaviorSubject<String>();
  final _direccionSucursalController = BehaviorSubject<String>();
  final _celularSucursalController = BehaviorSubject<String>();
  final _celular2SucursalController = BehaviorSubject<String>();
  final _emailSucursalController = BehaviorSubject<String>();
  final _cargandoRegistroSucursalController = BehaviorSubject<bool>();

  Stream<String> get nombreSucursalStream =>
      _nombreSucursalController.stream.transform(validarname);
  Stream<String> get direccionSucursalStream =>
      _direccionSucursalController.stream.transform(validarsurname);
  Stream<String> get celularSucursalStream =>
      _celularSucursalController.stream.transform(validarcel);
  Stream<String> get celular2SucursalStream =>
      _celular2SucursalController.stream.transform(validarcel);
  Stream<String> get emailSucursalStream =>
      _emailSucursalController.stream.transform(validarEmail);
  Stream<bool> get cargandoSucursalStream =>
      _cargandoRegistroSucursalController.stream;

  String get nameEmpresa => _nombreSucursalController.value;
  String get direccion => _direccionSucursalController.value;
  String get cel => _celularSucursalController.value;
  String get cel2 => _celular2SucursalController.value;
  String get email => _emailSucursalController.value;

  dispose() {
    _nombreSucursalController?.close();
    _direccionSucursalController?.close();
    _celularSucursalController?.close();
    _celular2SucursalController?.close();
    _emailSucursalController?.close();
    _cargandoRegistroSucursalController?.close();
  }

  Function(String) get changenombreSucursal =>
      _nombreSucursalController.sink.add;

  Function(String) get changedireccionSucursal =>
      _direccionSucursalController.sink.add;

  Function(String) get changecelularSucursal =>
      _celularSucursalController.sink.add;

  Function(String) get changecelular2Sucursal =>
      _celular2SucursalController.sink.add;

  Function(String) get changeemailSucursal => _emailSucursalController.sink.add;

  /* Future<int> registroSucursal(SubsidiaryModel data) async {
    _cargandoRegistroSucursalController.sink.add(true);
    final resp = await registroSucursalApi.registrarSedes(data);
    _cargandoRegistroSucursalController.sink.add(false);
    return resp;
  } */

  void changeCargando() {
    _cargandoRegistroSucursalController.sink.add(false);
  }
}
