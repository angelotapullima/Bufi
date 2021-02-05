import 'package:rxdart/rxdart.dart';
import '../../database/producto_bd.dart';
import '../../database/subsidiaryService_db.dart';
import '../../models/productoModel.dart';
import '../../models/subsidiaryService.dart';

class FavoritosProdServiciosBloc{
  final productoDatabase = ProductoDatabase();
  final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();

  final _productosFavoritosController = new BehaviorSubject<List<ProductoModel>>();
  final _subsidiaryServicesFavoritosController = new BehaviorSubject<List<SubsidiaryServiceModel>>();

  Stream<List<ProductoModel>> get productoFavoritoStream => _productosFavoritosController.stream;

   Stream<List<SubsidiaryServiceModel>> get subsidiaryserviceFavoritosStream =>_subsidiaryServicesFavoritosController.stream;

  dispose() {

     _productosFavoritosController?.close();
      _subsidiaryServicesFavoritosController?.close();

  }

  //Productos
  void obtenerProductosFav() async {
    _productosFavoritosController.sink.add(await productoDatabase.obtenerProductosFavoritos());
  }
  
  void deleteProductosFav(String id) async {
    await productoDatabase.obtenerProductosFavoritos();
    obtenerProductosFav();
  }

  //Servicios
  // void obtenerProductosFav() async {
  //   _productosFavoritosController.sink.add(await productoDatabase.obtenerProductosFavoritos());
  // }
  // void saveProductosFav(String id) async {
  //   await productoDatabase.obtenerProductosFavoritos();
  //   obtenerProductosFav();
  // }

  // void deleteProductosFav(String id) async {
  //   await productoDatabase.obtenerProductosFavoritos();
  //   obtenerProductosFav();
  // }
}