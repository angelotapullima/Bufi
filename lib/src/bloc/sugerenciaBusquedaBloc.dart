

import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/sugerenciaBusqueda_db.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:rxdart/subjects.dart';

class SugerenciaBusquedaBloc {
  final productoDatabase = ProductoDatabase();
  final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();
  //final
  final _sugerenciaBusquedaController =
      BehaviorSubject<List<BienesServiciosModel>>();

  Stream<List<BienesServiciosModel>> get sugerenciaBusquedaStream =>
      _sugerenciaBusquedaController.stream;

  void dispose() {
    _sugerenciaBusquedaController?.close();
  }

  void listarSugerenciasXbusqueda() async {
    _sugerenciaBusquedaController.sink.add(await obtenerSugerencias());
  }

  Future<List<BienesServiciosModel>> obtenerSugerencias() async {
    final List<BienesServiciosModel>listGeneral=[];
    final sugerenciaDb = SugerenciaBusquedaDb();
    final listSugerencia = await sugerenciaDb.obtenerSugerencia();

    for (var i = 0; i < listSugerencia.length; i++) {
     

      if (listSugerencia[i].tipo == 'bien') {
        final listBien =
            await productoDatabase.obtenerProductoXIdItemSubcategoria(
                listSugerencia[i].idItemSubcategoria);

        for (var x = 0; x < listBien.length; x++) {
          BienesServiciosModel bienesServiciosModel = BienesServiciosModel();
          bienesServiciosModel.subsidiaryGoodImage =
              listBien[x].productoImage;
          bienesServiciosModel.idSubsidiarygood = listBien[x].idProducto;
          bienesServiciosModel.subsidiaryGoodName =
              listBien[x].productoName;
          bienesServiciosModel.subsidiaryGoodCurrency =
              listBien[x].productoCurrency;
          bienesServiciosModel.subsidiaryGoodPrice =
              listBien[x].productoPrice;
          bienesServiciosModel.subsidiaryGoodBrand =
              listBien[x].productoBrand;

          bienesServiciosModel.tipo ='bien';

          listGeneral.add(bienesServiciosModel);
        }
      } else {
         final listServicio =
            await subsidiaryServiceDatabase.obtenerServicioXIdItemSubcategoria(
                listSugerencia[i].idItemSubcategoria);

        for (var x = 0; x < listServicio.length; x++) {
          BienesServiciosModel bienesServiciosModel = BienesServiciosModel();
          bienesServiciosModel.subsidiaryServiceImage =listServicio[x].subsidiaryServiceImage;
          bienesServiciosModel.idSubsidiaryservice = listServicio[x].idSubsidiaryservice;
          bienesServiciosModel.subsidiaryServiceName = listServicio[x].subsidiaryServiceName;
          bienesServiciosModel.subsidiaryServiceCurrency =
              listServicio[x].subsidiaryServiceCurrency;
          bienesServiciosModel.subsidiaryServicePrice =
              listServicio[x].subsidiaryServicePrice;
          bienesServiciosModel.subsidiaryServiceDescription =
              listServicio[x].subsidiaryServiceDescription;
               bienesServiciosModel.tipo ='servicio';

          listGeneral.add(bienesServiciosModel);
        }
      }

      //listGeneral.add(sugBusquedaModel);
    }

    return listGeneral;
  }

  
}
