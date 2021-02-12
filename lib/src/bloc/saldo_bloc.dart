



import 'package:bufi/src/api/Cuenta/saldo_api.dart';
import 'package:bufi/src/database/saldo_dabatabase.dart';
import 'package:bufi/src/models/saldoModel.dart';
import 'package:rxdart/rxdart.dart';

class SaldoBloc{


 final _saldoController = BehaviorSubject<List<SaldoModel>>();
  final saldoDatabase = SaldoDatabase();
  final saldoApi = SaldoApi();

  Stream<List<SaldoModel>> get saldoStream =>_saldoController.stream;

  void dispose() {
    _saldoController?.close();
  }

  void obtenerSaldo() async {
    _saldoController.sink.add( await saldoDatabase.obtenerSaldo());
    await saldoApi.obtenerSaldo();
    _saldoController.sink.add( await saldoDatabase.obtenerSaldo());
 
  }



}