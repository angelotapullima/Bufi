
import 'package:bufi/src/api/Cuenta/mis_movimientos_api.dart';
import 'package:bufi/src/database/mis_movimientos_database.dart';
import 'package:bufi/src/models/mis_movimientos_model.dart';
import 'package:rxdart/subjects.dart';

class MisMovimientosBloc {
  final misMovimientosDatabase = MisMovimientosDatabase();
  final misMovimientosApi = MisMovimientosApi();



  final misMovimientosController = BehaviorSubject<List<MovimientosPorFecha>>();
  final movimientosPorPorNoperacionController = BehaviorSubject<List<MisMovimientosModel>>();
  final cargandoApiMovimientosController = BehaviorSubject<bool>();

  Stream<List<MovimientosPorFecha>> get misMovimientosBlocstream => misMovimientosController.stream;
  Stream<List<MisMovimientosModel>> get movimientosPorPorNoperacionBlocstream => movimientosPorPorNoperacionController.stream;
  Stream<bool> get cargadoApiMovimientos => cargandoApiMovimientosController.stream;

  dispose() {
    misMovimientosController?.close();
    movimientosPorPorNoperacionController?.close();
    cargandoApiMovimientosController?.close();
  }

  void cargandoMovimientosFalse() {
    cargandoApiMovimientosController.sink.add(false);
  }

  void obtenerMisMovimientos() async {
    misMovimientosController.sink.add(await movimientosPorFecha());
    cargandoApiMovimientosController.add(true);
    await misMovimientosApi.obtenerMisMovimientos();
    cargandoApiMovimientosController.add(false);
    misMovimientosController.sink.add(await movimientosPorFecha());
  }

  void movimientosPorNoperacion(String id)async{
    movimientosPorPorNoperacionController.sink.add(await misMovimientosDatabase.obtenerMisMovimientosPorNoperacion(id));

  }

  Future<List<MovimientosPorFecha>> movimientosPorFecha() async {
    var listFechas = List<String>();
    final listMovement = await misMovimientosDatabase.obtenerMisMovimientos();
    final listFechasModel =
        await misMovimientosDatabase.obtenerMisMovimientosSoloFecha();

    final listAlgo = List<MovimientosPorFecha>();
    if (listFechasModel.length > 0) {
      for (var i = 0; i < listFechasModel.length; i++) {
        listFechas.add(listFechasModel[i].soloFecha);
      }
      List<String> reversedAnimals = listFechas.reversed.toList();

       for (var x = 0; x < reversedAnimals.length; x++) {
         print('${listFechas[x]}');
        MovimientosPorFecha movimientosPorFecha = MovimientosPorFecha();
        final listPrevio = List<MisMovimientosModel>();
        for (var y = 0; y < listMovement.length; y++) {
          
          if (reversedAnimals[x] == listMovement[y].soloFecha) {
            MisMovimientosModel misMovimientosModel = MisMovimientosModel();
            misMovimientosModel.nroOperacion = listMovement[y].nroOperacion;
            misMovimientosModel.soloFecha = listMovement[y].soloFecha;
            misMovimientosModel.tipoPago = listMovement[y].tipoPago;
            misMovimientosModel.monto = listMovement[y].monto;
            misMovimientosModel.ind = listMovement[y].ind;
            misMovimientosModel.fecha = listMovement[y].fecha;
            misMovimientosModel.concepto = listMovement[y].concepto;
            misMovimientosModel.comision = listMovement[y].comision;

            listPrevio.add(misMovimientosModel);
          }
         
        }
         movimientosPorFecha.listMovimientos = listPrevio;
          movimientosPorFecha.fecha = reversedAnimals[x];
        listAlgo.add(movimientosPorFecha);
      }
    }

    return listAlgo;
  }
}

class MovimientosPorFecha {
  String fecha;
  List<MisMovimientosModel> listMovimientos;

  MovimientosPorFecha({
    this.fecha,
    this.listMovimientos,
  });
}
