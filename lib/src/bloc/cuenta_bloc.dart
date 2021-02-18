



import 'package:bufi/src/api/Cuenta/saldo_api.dart';
import 'package:bufi/src/database/cuenta_dabatabase.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:rxdart/rxdart.dart';

class CuentaBloc{

  final cuentaDatabase = CuentaDatabase();
  final cuentaApi = SaldoApi();
  

 final _saldoController = BehaviorSubject<List<CuentaModel>>();
 final _recargaController = BehaviorSubject<List<RecargaModel>>();

  Stream<List<CuentaModel>> get saldoStream =>_saldoController.stream;
  Stream<List<RecargaModel>> get recargaStream =>_recargaController.stream;

  void dispose() {
    _saldoController?.close();
    _recargaController?.close();
  }

  void obtenerSaldo() async {
    _saldoController.sink.add( await cuentaDatabase.obtenerSaldo());
    await cuentaApi.obtenerSaldo();
    _saldoController.sink.add( await cuentaDatabase.obtenerSaldo());
 
  }

  void obtenerRecargaPendiente()async{
    print('llamada pendiente');
    _recargaController.sink.add([]);
    _recargaController.sink.add(await cuentaApi.obtenerRecargaPendiente());


    
  }



}


class RecargaModel{



  String codigo;
  String expiracion;
  String monto;
  String result;
  String mensaje;
  String tipo;


RecargaModel({
  this.codigo,
  this.expiracion,
  this.monto,
  this.result,
  this.mensaje,
  this.tipo,
});
  
}