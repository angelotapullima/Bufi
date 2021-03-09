import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class CarritoBloc {
  final carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();
  final _carritoGeneralController =
      BehaviorSubject<List<CarritoGeneralSuperior>>();
  final _carritoSeleccionaController =
      BehaviorSubject<List<CarritoGeneralSuperior>>();
  final _carritoListHorizontalController =
      BehaviorSubject<List<ProductoModel>>();

  final _carritoProductoController =
      BehaviorSubject<List<CarritoGeneralSuperior>>();

  Stream<List<CarritoGeneralSuperior>> get carritoGeneralStream =>
      _carritoGeneralController.stream;
  Stream<List<CarritoGeneralSuperior>> get carritoSeleccionadoStream =>
      _carritoSeleccionaController.stream;
  Stream<List<ProductoModel>> get carritoProductListHorizontalStream =>
      _carritoListHorizontalController.stream;

  Stream<List<CarritoGeneralSuperior>> get carritoProductoStream =>
      _carritoProductoController.stream;

  void dispose() {
    _carritoGeneralController?.close();
    _carritoSeleccionaController?.close();
    _carritoListHorizontalController?.close();
    _carritoProductoController?.close();
  }

  void obtenerCarritoPorSucursal() async {
    _carritoGeneralController.sink.add(await carritoPorSucursal());
  }

  void obtenerCarritoListHorizontalProducto() async {
    _carritoListHorizontalController.sink
        .add(await carritoProductListHorizontal());
  }

  void obtenerCarritoConfirmacion() async {
    _carritoSeleccionaController.sink
        .add(await carritoPorSucursalSeleccionado());
  }

  void confirmacionPedidoProducto(String idProducto) async {
    _carritoProductoController.sink
        .add(await carritoProductoSeleccionado(idProducto));
  }

  Future<List<CarritoGeneralSuperior>> carritoPorSucursal() async {
    final listaGeneralCarrito = List<CarritoGeneralSuperior>();
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
    final listCarrito = await carritoDb.obtenerCarrito();
    for (var x = 0; x < listaDeStringDeIds.length; x++) {
      //función para obtener los datos de la sucursal para despues usar el nombre
      final sucursal =
          await subsidiary.obtenerSubsidiaryPorId(listaDeStringDeIds[x]);

      final listCarritoModel = List<CarritoModel>();

      CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();

      //agregamos el nombre de la sucursal con los datos antes obtenidos (sucursal)
      carritoGeneralModel.nombreSucursal = sucursal[0].subsidiaryName;
      carritoGeneralModel.idSubsidiary = sucursal[0].idSubsidiary;
      for (var y = 0; y < listCarrito.length; y++) {
        //cuando hay coincidencia de id's procede a agregar los datos a la lista
        if (listaDeStringDeIds[x] == listCarrito[y].idSubsidiary) {
          if (listCarrito[y].estadoSeleccionado == '1') {
            double precio = double.parse(listCarrito[y].precio);
            int cant = int.parse(listCarrito[y].cantidad);

            cantidadTotal = cantidadTotal + (precio * cant);
          }

          CarritoModel c = CarritoModel();

          c.precio = listCarrito[y].precio;
          c.idSubsidiary = listCarrito[y].idSubsidiary;
          c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
          c.nombre = listCarrito[y].nombre;
          c.marca = listCarrito[y].marca;
          c.modelo = listCarrito[y].modelo;
          c.talla = listCarrito[y].talla;
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

    CarritoGeneralSuperior carritoGeneralSuperior = CarritoGeneralSuperior();
    carritoGeneralSuperior.car = listaGeneral;
    carritoGeneralSuperior.montoGeneral = cantidadTotal.toString();

    listaGeneralCarrito.add(carritoGeneralSuperior);

    return listaGeneralCarrito;
  }

  Future<List<ProductoModel>> carritoProductListHorizontal() async {
    final listaGeneral = List<ProductoModel>();
    final carritoDb = CarritoDb();
    final productoDatabase = ProductoDatabase();

    //obtenemos todos los elementos del carrito
    final listCarrito = await carritoDb.obtenerProductoXCarritoListHorizontal();

    for (var x = 0; x < listCarrito.length; x++) {
      final productoItem = await productoDatabase
          .obtenerProductoPorIdSubsidiaryGood(listCarrito[x].idSubsidiaryGood);
      if (productoItem.length > 0) {
        ProductoModel productoModel = ProductoModel();

        productoModel.idProducto = productoItem[0].idProducto;
        productoModel.idSubsidiary = productoItem[0].idSubsidiary;
        productoModel.idGood = productoItem[0].idGood;
        productoModel.idItemsubcategory = productoItem[0].idItemsubcategory;
        productoModel.productoName = productoItem[0].productoName;
        productoModel.productoPrice = productoItem[0].productoPrice;
        productoModel.productoCurrency = productoItem[0].productoCurrency;
        productoModel.productoImage = productoItem[0].productoImage;
        productoModel.productoCharacteristics =
            productoItem[0].productoCharacteristics;
        productoModel.productoBrand = productoItem[0].productoBrand;
        productoModel.productoModel = productoItem[0].productoModel;
        productoModel.productoType = productoItem[0].productoType;
        productoModel.productoSize = productoItem[0].productoSize;
        productoModel.productoStock = productoItem[0].productoStock;
        productoModel.productoMeasure = productoItem[0].productoMeasure;
        productoModel.productoRating = productoItem[0].productoRating;
        productoModel.productoUpdated = productoItem[0].productoUpdated;
        productoModel.productoStatus = productoItem[0].productoStatus;
        productoModel.productoFavourite = productoItem[0].productoFavourite;

        listaGeneral.add(productoModel);
      }
    }

    return listaGeneral;
  }

  Future<List<CarritoGeneralSuperior>> carritoPorSucursalSeleccionado() async {
    final listaGeneralCarrito = List<CarritoGeneralSuperior>();
    final listaGeneral = List<CarritoGeneralModel>();
    final carritoDb = CarritoDb();
    final listaDeStringDeIds = List<String>();
    final subsidiary = SubsidiaryDatabase();

    double cantidadTotal = 0;
    int cantidad = 0;

    //funcion que trae los datos del carrito agrupados por iDSubsidiary para que no se repitan los IDSubsidiary
    final listCarritoAgrupados =
        await carritoDb.obtenerProductosSeleccionadoAgrupados();

    //llenamos la lista de String(listaDeStringDeIds) con los datos agrupados que llegan (listCarritoAgrupados)
    for (var i = 0; i < listCarritoAgrupados.length; i++) {
      var id = listCarritoAgrupados[i].idSubsidiary;
      listaDeStringDeIds.add(id);
    }

    //obtenemos todos los elementos del carrito
    final listCarrito = await carritoDb.obtenerProductoXCarritoSeleccionado();
    for (var x = 0; x < listaDeStringDeIds.length; x++) {
      //función para obtener los datos de la sucursal para despues usar el nombre
      final sucursal =
          await subsidiary.obtenerSubsidiaryPorId(listaDeStringDeIds[x]);

      final listCarritoModel = List<CarritoModel>();

      CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();

      //agregamos el nombre de la sucursal con los datos antes obtenidos (sucursal)
      carritoGeneralModel.nombreSucursal = sucursal[0].subsidiaryName;
      carritoGeneralModel.idSubsidiary = sucursal[0].idSubsidiary;
      for (var y = 0; y < listCarrito.length; y++) {
        //cuando hay coincidencia de id's procede a agregar los datos a la lista
        if (listaDeStringDeIds[x] == listCarrito[y].idSubsidiary) {
          if (listCarrito[y].estadoSeleccionado == '1') {
            double precio = double.parse(listCarrito[y].precio);
            int cant = int.parse(listCarrito[y].cantidad);

            cantidadTotal = cantidadTotal + (precio * cant);
          }

          CarritoModel c = CarritoModel();

          c.precio = listCarrito[y].precio;
          c.idSubsidiary = listCarrito[y].idSubsidiary;
          c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
          c.nombre = listCarrito[y].nombre;
          c.marca = listCarrito[y].marca;
          c.modelo = listCarrito[y].modelo;
          c.talla = listCarrito[y].talla;
          c.image = listCarrito[y].image;
          c.moneda = listCarrito[y].moneda;
          c.size = listCarrito[y].size;
          c.caracteristicas = listCarrito[y].caracteristicas;
          c.estadoSeleccionado = listCarrito[y].estadoSeleccionado;
          c.cantidad = listCarrito[y].cantidad;

          listCarritoModel.add(c);
          cantidad++;
        }
      }

      carritoGeneralModel.carrito = listCarritoModel;
      carritoGeneralModel.monto = cantidadTotal.toString();

      listaGeneral.add(carritoGeneralModel);
    }

    CarritoGeneralSuperior carritoGeneralSuperior = CarritoGeneralSuperior();
    carritoGeneralSuperior.car = listaGeneral;
    carritoGeneralSuperior.cantidadArticulos = cantidad.toString();
    carritoGeneralSuperior.montoGeneral = cantidadTotal.toString();

    listaGeneralCarrito.add(carritoGeneralSuperior);

    return listaGeneralCarrito;
  }

  Future<List<CarritoGeneralSuperior>> carritoProductoSeleccionado(
      String idProducto) async {
    final listaGeneralCarrito = List<CarritoGeneralSuperior>();
    final listaGeneral = List<CarritoGeneralModel>();
    final listCarritoModel = List<CarritoModel>();
    final negociosApi = NegociosApi();

    final subsidiary = SubsidiaryDatabase();

    final listCarrito =  await carritoDb.obtenerProductoXCarritoPorId(idProducto);
    final sucursal =  await subsidiary.obtenerSubsidiaryPorId(listCarrito[0].idSubsidiary);

    if (listCarrito.length > 0) {
      if (sucursal.length > 0) {
        CarritoModel c = CarritoModel();

        c.precio = listCarrito[0].precio;
        c.idSubsidiary = listCarrito[0].idSubsidiary;
        c.idSubsidiaryGood = listCarrito[0].idSubsidiaryGood;
        c.nombre = listCarrito[0].nombre;
        c.marca = listCarrito[0].marca;
        c.modelo = listCarrito[0].modelo;
        c.talla = listCarrito[0].talla;
        c.image = listCarrito[0].image;
        c.moneda = listCarrito[0].moneda;
        c.size = listCarrito[0].size;
        c.caracteristicas = listCarrito[0].caracteristicas;
        c.estadoSeleccionado = listCarrito[0].estadoSeleccionado;
        c.cantidad = listCarrito[0].cantidad;

        listCarritoModel.add(c);

        CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();
        carritoGeneralModel.nombreSucursal = sucursal[0].subsidiaryName;
        carritoGeneralModel.idSubsidiary = sucursal[0].idSubsidiary;
        carritoGeneralModel.carrito = listCarritoModel;
        carritoGeneralModel.monto = (double.parse(listCarrito[0].cantidad) *
                double.parse(listCarrito[0].precio))
            .toString();

        listaGeneral.add(carritoGeneralModel);

        CarritoGeneralSuperior carritoGeneralSuperior =
            CarritoGeneralSuperior();
        carritoGeneralSuperior.car = listaGeneral;
        carritoGeneralSuperior.cantidadArticulos = listCarrito[0].cantidad;
        carritoGeneralSuperior.montoGeneral =
            (double.parse(listCarrito[0].cantidad) *
                    double.parse(listCarrito[0].precio))
                .toString();

        listaGeneralCarrito.add(carritoGeneralSuperior);
      } else {
        print('obteniendo sucursal');

        listaGeneralCarrito.clear();
        listaGeneral.clear();
        listCarritoModel.clear();

        await negociosApi.listarSubsidiaryPorId(listCarrito[0].idSubsidiary);

      
        final sucursal2 = await subsidiary.obtenerSubsidiaryPorId(listCarrito[0].idSubsidiary);

        if (listCarrito.length > 0) {
          if (sucursal2.length > 0) {
            CarritoModel c = CarritoModel();

            c.precio = listCarrito[0].precio;
            c.idSubsidiary = listCarrito[0].idSubsidiary;
            c.idSubsidiaryGood = listCarrito[0].idSubsidiaryGood;
            c.nombre = listCarrito[0].nombre;
            c.marca = listCarrito[0].marca;
            c.modelo = listCarrito[0].modelo;
            c.talla = listCarrito[0].talla;
            c.image = listCarrito[0].image;
            c.moneda = listCarrito[0].moneda;
            c.size = listCarrito[0].size;
            c.caracteristicas = listCarrito[0].caracteristicas;
            c.estadoSeleccionado = listCarrito[0].estadoSeleccionado;
            c.cantidad = listCarrito[0].cantidad;

            listCarritoModel.add(c);

            CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();
            carritoGeneralModel.nombreSucursal = sucursal2[0].subsidiaryName;
            carritoGeneralModel.idSubsidiary = sucursal2[0].idSubsidiary;
            carritoGeneralModel.carrito = listCarritoModel;
            carritoGeneralModel.monto = (double.parse(listCarrito[0].cantidad) * double.parse(listCarrito[0].precio)).toString();

            listaGeneral.add(carritoGeneralModel);

            CarritoGeneralSuperior carritoGeneralSuperior = CarritoGeneralSuperior();
            carritoGeneralSuperior.car = listaGeneral;
            carritoGeneralSuperior.cantidadArticulos = listCarrito[0].cantidad;
            carritoGeneralSuperior.montoGeneral = (double.parse(listCarrito[0].cantidad) *  double.parse(listCarrito[0].precio)).toString();

            listaGeneralCarrito.add(carritoGeneralSuperior);
          }
        }
      }
    }

    return listaGeneralCarrito;
  }
}
