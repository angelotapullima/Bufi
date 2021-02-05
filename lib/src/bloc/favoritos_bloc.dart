import 'package:bufi/src/api/point_api.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/PointGeneralModel.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class PointsBloc {
  final pointApi = PointApi();
  final subsidiaryDatabase = SubsidiaryDatabase();
  final _listPoints = BehaviorSubject<List<SubsidiaryModel>>();

  Stream<List<SubsidiaryModel>> get pointsStrema => _listPoints.stream;

  List<SubsidiaryModel> get page => _listPoints.value;

  dispose() {
    _listPoints?.close();
  }

  void obtenerPoints() async {
    _listPoints.sink.add(await subsidiaryDatabase.obtenerSubsidiaryFavoritas());
  }

  void savePoints(String id) async {
    await subsidiaryDatabase.obtenerSubsidiaryFavoritas();
    await pointApi.savePoint(id);
    obtenerPoints();
  }

  void deletePoints(String id) async {
    await subsidiaryDatabase.obtenerSubsidiaryFavoritas();
    await pointApi.deletePoint(id);
    obtenerPoints();
  }
}

Future<List<PointGeneralModel>> favoritoPorSucursal() async {
  final listIdsucursalFav = List();
  final sucursalDb = SubsidiaryDatabase();
  final listSucursalFav =await sucursalDb.obtenerSubsidiarysFavoritasAgrupadas();
  for (var i = 0; i < listSucursalFav.length; i++) {
    final id = listSucursalFav[i].idSubsidiary;
    listIdsucursalFav.add(id);
  }

//obtner la lista de sucursales
   for (var j = 0; j < listSucursalFav.length; j++) {
     final sucursal = await sucursalDb.obtenerSubsidiaryPorId(listIdsucursalFav[j]);
    final favoritoGeneralModel = PointGeneralModel();

    favoritoGeneralModel.idSucursal = sucursal[j].idSubsidiary;
    favoritoGeneralModel.nombreSucursal = sucursal[j].subsidiaryName;

    //Obtener lista de sucursales favoritas
    final listsucursal = await sucursalDb.obtenerSubsidiaryFavoritas();
    //final listPoint = List<PointModel>();

    for (var k = 0; k < listsucursal.length; k++) {
      // if (listIdsucursalFav[j] == ) {

      // }

      final pointModel = PointModel();
      pointModel.idSubsidiary = listsucursal[k].idSubsidiary;
      pointModel.idCompany = listsucursal[k].idCompany;
      pointModel.subsidiaryName = listsucursal[k].subsidiaryName;
      pointModel.subsidiaryCellphone = listsucursal[k].subsidiaryCellphone;
      pointModel.subsidiaryCellphone2 = listsucursal[k].subsidiaryCellphone2;
      pointModel.subsidiaryEmail = listsucursal[k].subsidiaryEmail;
      pointModel.subsidiaryCoordX = listsucursal[k].subsidiaryCoordX;
      pointModel.subsidiaryCoordY = listsucursal[k].subsidiaryCoordY;
      pointModel.subsidiaryOpeningHours =
          listsucursal[k].subsidiaryOpeningHours;
      pointModel.subsidiaryPrincipal = listsucursal[k].subsidiaryPrincipal;
      pointModel.subsidiaryStatus = listsucursal[k].subsidiaryStatus;
      pointModel.subsidiaryAddress = listsucursal[k].subsidiaryAddress;
    }
  }
}

// Future<List<PointGeneralModel>> favoritoPorSucursal() async {
//     final listaGeneral = List<PointGeneralModel>();

//     final listaDeIdsPoints = List<String>();
//     final subsidiaryDb = SubsidiaryDatabase();

//     //funcion que trae los datos del carrito agrupados por iDSubsidiary para que no se repitan los IDSubsidiary
//     final listPointsAgrupados = await subsidiaryDb.obtenerSubsidiarysFavoritasAgrupadas();

//     //llenamos la lista de String(listaDeStringDeIds) con los datos agrupados que llegan (listCarritoAgrupados)
//     for (var i = 0; i < listPointsAgrupados.length; i++) {
//       var id = listPointsAgrupados[i].idSubsidiary;
//       listaDeIdsPoints.add(id);
//     }

//   //obtenemos todos los elementos del carrito
//     final listsucursales = await subsidiaryDb.obtenerSubsidiary();
//     for (var x = 0; x < listaDeIdsPoints.length; x++) {

//       //función para obtener los datos de la sucursal para despues usar el nombre
//       final sucursal = await subsidiaryDb.obtenerSubsidiaryPorId(listaDeIdsPoints[x]);

//       final listPointModel = List<PointModel>();

//       PointGeneralModel pointGeneralModel = PointGeneralModel();

//       //agregamos el nombre de la sucursal con los datos antes obtenidos (sucursal)
//       pointGeneralModel.nombreSucursal = sucursal[0].subsidiaryName;
//       for (var y = 0; y < listsucursales.length; y++) {

//         //cuando hay coincidencia de id's procede a agregar los datos a la lista
//         if (listPointsAgrupados[x] == listsucursales[y].idSubsidiary) {
//           final p = PointModel();

//           c.precio = listCarrito[y].precio;
//           c.idSubsidiary = listCarrito[y].idSubsidiary;
//           c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
//           c.nombre = listCarrito[y].nombre;
//           c.marca = listCarrito[y].marca;
//           c.image = listCarrito[y].image;
//           c.moneda = listCarrito[y].moneda;
//           c.size = listCarrito[y].size;
//           c.caracteristicas = listCarrito[y].caracteristicas;
//           c.cantidad = listCarrito[y].cantidad;

//           listCarritoModel.add(c);

//           //print('ptmr');
//         }
//       }

//       carritoGeneralModel.carrito = listCarritoModel;

//       listaGeneral.add(carritoGeneralModel);
//     }
//     //print('ctm');
//     return listaGeneral;
//   }

// class FavoritosPointBloc {

//   final subsidiaryGoodDatabase = SubisdiaryGoodDatabase();
//   final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();

//   final _subsidiaryGoodsFavoritosController = new BehaviorSubject<List<SubsidiaryGoodModel>>();
//   final _subsidiaryServicesFavoritosController = new BehaviorSubject<List<SubsidiaryServiceModel>>();

//   Stream<List<SubsidiaryGoodModel>> get subsidiarygoodFavoritosStream =>
//       _subsidiaryGoodsFavoritosController.stream;

//    Stream<List<SubsidiaryServiceModel>> get subsidiaryserviceFavoritosStream =>
//       _subsidiaryServicesFavoritosController.stream;

//   dispose() {

//      _subsidiaryGoodsFavoritosController?.close();
//       _subsidiaryServicesFavoritosController?.close();

//   }

//   void obtenerSucursalBienesFavoritos() async {
//     _subsidiaryGoodsFavoritosController.sink
//         .add(await subsidiaryGoodDatabase.obtenerSubsidiarysGoodsFavoritos());
//   }

//   void obtenerSucursalServiciosFavoritos() async {
//     _subsidiaryServicesFavoritosController.sink
//         .add(await subsidiaryServiceDatabase.obtenerSubsidiarysServicesFavoritos());
//   }

// }
