

import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:rxdart/rxdart.dart';

class CarritoBloc {
  final carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();
  final _carritoGeneralController =
      BehaviorSubject<List<CarritoGeneralModel>>();

  Stream<List<CarritoGeneralModel>> get carritoGeneralStream =>
      _carritoGeneralController.stream;

  void dispose() {
    _carritoGeneralController?.close();
  }

  void obtenerCarrito() async {
    _carritoGeneralController.sink.add(await carritoPorSucursal());
  }

  Future<List<CarritoGeneralModel>> carritoPorSucursal() async {
    final listaGeneral = List<CarritoGeneralModel>();
    final carritoDb = CarritoDb();
    final listaDeStringDeIds = List<String>();
    final subsidiary = SubsidiaryDatabase();

    double cantidadTotal = 0;

    //funcion que trae los datos del carrito agrupados por iDSubsidiary para que no se repitan los IDSubsidiary
    final listCarritoAgrupados = await carritoDb.obtenerProductosAgrupados();

    //llenamos la lista de String(listaDeStringDeIds) con los datos agrupados que llegan (listCarritoAgrupados)
    for (var i = 0; i < listCarritoAgrupados.length; i++) {
      var id = listCarritoAgrupados[i].idSubsidiary;
      listaDeStringDeIds.add(id);
    }

  //obtenemos todos los elementos del carrito
    final listCarrito = await carritoDb.obtenerProductoXCarrito();
    for (var x = 0; x < listaDeStringDeIds.length; x++) {

      //función para obtener los datos de la sucursal para despues usar el nombre 
      final sucursal = await subsidiary.obtenerSubsidiaryPorId(listaDeStringDeIds[x]);

      final listCarritoModel = List<CarritoModel>();

      CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();

      //agregamos el nombre de la sucursal con los datos antes obtenidos (sucursal)
      carritoGeneralModel.nombre = sucursal[0].subsidiaryName;
      for (var y = 0; y < listCarrito.length; y++) {

        //cuando hay coincidencia de id's procede a agregar los datos a la lista 
        if (listaDeStringDeIds[x] == listCarrito[y].idSubsidiary) {

          if(listCarrito[y].estadoSeleccionado =='1'){
            var jdjdjd = double.parse(listCarrito[y].precio) * int.parse(listCarrito[y].cantidad);
            print(jdjdjd);
            double precio = double.parse(listCarrito[y].precio) ;
            int cant = int.parse(listCarrito[y].cantidad);

            cantidadTotal = cantidadTotal + (precio * cant );

            print('tamare $cantidadTotal');

          }
          CarritoModel c = CarritoModel();

          c.precio = listCarrito[y].precio;
          c.idSubsidiary = listCarrito[y].idSubsidiary;
          c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
          c.nombre = listCarrito[y].nombre;
          c.marca = listCarrito[y].marca;
          c.image = listCarrito[y].image;
          c.moneda = listCarrito[y].moneda;
          c.size = listCarrito[y].size;
          c.caracteristicas = listCarrito[y].caracteristicas;
          c.estadoSeleccionado = listCarrito[y].estadoSeleccionado;
          c.cantidad = listCarrito[y].cantidad;

          listCarritoModel.add(c);


        }
      }

      carritoGeneralModel.carrito = listCarritoModel;
      carritoGeneralModel.monto = cantidadTotal.toString();

      listaGeneral.add(carritoGeneralModel);
    }
    
    return listaGeneral;
  }

}
