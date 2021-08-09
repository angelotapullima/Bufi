import 'package:bufi/src/api/PantallaPrincipal/pantalla_principal_api.dart';
import 'package:bufi/src/database/pantalla_principal_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/models/pantalla_principal_model.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class PantallaPrincipalBloc {
  final pantallaPrincipalApi = PantallaPrincipalApi();
  final pantallaPrincipalDatabase = PantallaPrincipalDatabase();
  final productoDatabase = ProductoDatabase();
  final pantallaController = BehaviorSubject<List<PantallaPrincipalModel>>();

  Stream<List<PantallaPrincipalModel>> get listarnotificacionesStream => pantallaController.stream;

  dispose() {
    pantallaController?.close();
  }

// notificaciones: 0:No leídas, 1:leídas
  void obtenerPantallaPrincipal() async {
    pantallaController.sink.add(await pantallex());
    await pantallaPrincipalApi.obtenerPantallaPrincipal();
    pantallaController.sink.add(await pantallex());
    //pantallaController.sink.add(await notificacionDb.obtenerNotificaciones());
  }

  Future<List<PantallaPrincipalModel>> pantallex() async {
    final List<PantallaPrincipalModel> listaFinal = [];
    final pantashas = await pantallaPrincipalDatabase.obtenerPantallaPrincipal();

    if (pantashas.length > 0) {
      for (var i = 0; i < pantashas.length; i++) {
        final List<ProductoModel> prosh = [];
        PantallaPrincipalModel pantallaPrincipalModel = PantallaPrincipalModel();

        pantallaPrincipalModel.nombre = pantashas[i].nombre;
        pantallaPrincipalModel.tipo = pantashas[i].tipo;
        pantallaPrincipalModel.idPantalla = pantashas[i].idPantalla;

        final productos = await productoDatabase.obtenerProductoXIdItemSubcategoria(pantashas[i].idPantalla);

        if (productos.length > 0) {
          for (var x = 0; x < productos.length; x++) {
            ProductoModel productoModel = ProductoModel();
            productoModel.idProducto = productos[x].idProducto;
            productoModel.idSubsidiary = productos[x].idSubsidiary;
            productoModel.idGood = productos[x].idGood;
            productoModel.idItemsubcategory = productos[x].idItemsubcategory;
            productoModel.productoName = productos[x].productoName;
            productoModel.productoPrice = productos[x].productoPrice;
            productoModel.productoCurrency = productos[x].productoCurrency;
            productoModel.productoImage = productos[x].productoImage;
            productoModel.productoCharacteristics = productos[x].productoCharacteristics;
            productoModel.productoBrand = productos[x].productoBrand;
            productoModel.productoModel = productos[x].productoModel;
            productoModel.productoType = productos[x].productoType;
            productoModel.productoSize = productos[x].productoSize;
            productoModel.productoMeasure = productos[x].productoMeasure;
            productoModel.productoStock = productos[x].productoStock;
            productoModel.productoRating = productos[x].productoRating;
            productoModel.productoUpdated = productos[x].productoUpdated;
            productoModel.productoStatus = productos[x].productoStatus;

            prosh.add(productoModel);
          }
        }

        pantallaPrincipalModel.productos = prosh;

        listaFinal.add(pantallaPrincipalModel);
      }
    }


    return listaFinal;
  }
}
