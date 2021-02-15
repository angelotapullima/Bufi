



import 'package:bufi/src/api/Cuenta/saldo_api.dart';
import 'package:bufi/src/database/cuenta_dabatabase.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:rxdart/rxdart.dart';

class CuentaBloc{


 final _saldoController = BehaviorSubject<List<CuentaModel>>();
  final cuentaDatabase = CuentaDatabase();
  final cuentaApi = SaldoApi();

  Stream<List<CuentaModel>> get saldoStream =>_saldoController.stream;

  void dispose() {
    _saldoController?.close();
  }

  void obtenerSaldo() async {
    _saldoController.sink.add( await cuentaDatabase.obtenerSaldo());
    await cuentaApi.obtenerSaldo();
    _saldoController.sink.add( await cuentaDatabase.obtenerSaldo());
 
  }



}