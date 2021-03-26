import 'package:bufi/src/api/point_api.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/direccion_database.dart';
import 'package:bufi/src/database/marcaProducto_database.dart';
import 'package:bufi/src/database/modeloProducto_database.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/database/sugerenciaBusqueda_db.dart';
import 'package:bufi/src/database/tallaProducto_database.dart';
import 'package:bufi/src/database/tipo_pago_database.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/direccionModel.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:bufi/src/models/modeloProductoModel.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/sugerenciaBusquedaModel.dart';
import 'package:bufi/src/models/tallaProductoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart' as T;

void showToast(BuildContext context, String msg, {int duration, int gravity}) {
  T.Toast.show(msg, context, duration: duration, gravity: gravity);
}

void showToast1(String msg, int duration, ToastGravity gravity) {
  Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: duration,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

void guardarSubsidiaryFavorito(
    BuildContext context, SubsidiaryModel compSubModel) async {
  final subsidiaryBloc = ProviderBloc.sucursal(context);
  final pointsBloc = ProviderBloc.points(context);
  final savePointApi = PointApi();

  SubsidiaryModel companysubsidiaryModel = SubsidiaryModel();
  final sucursalDataBase = SubsidiaryDatabase();

  companysubsidiaryModel.idSubsidiary = compSubModel.idSubsidiary;
  companysubsidiaryModel.idCompany = compSubModel.idCompany;
  companysubsidiaryModel.subsidiaryName = compSubModel.subsidiaryName;
  companysubsidiaryModel.subsidiaryCellphone = compSubModel.subsidiaryCellphone;
  companysubsidiaryModel.subsidiaryCellphone2 =
      compSubModel.subsidiaryCellphone2;
  companysubsidiaryModel.subsidiaryEmail = compSubModel.subsidiaryEmail;
  companysubsidiaryModel.subsidiaryCoordX = compSubModel.subsidiaryCoordX;
  companysubsidiaryModel.subsidiaryCoordY = compSubModel.subsidiaryCoordY;
  companysubsidiaryModel.subsidiaryOpeningHours =
      compSubModel.subsidiaryOpeningHours;
  companysubsidiaryModel.subsidiaryPrincipal = compSubModel.subsidiaryPrincipal;
  companysubsidiaryModel.subsidiaryStatus = compSubModel.subsidiaryStatus;
  companysubsidiaryModel.subsidiaryFavourite = "1";

  await sucursalDataBase.updateSubsidiary(companysubsidiaryModel);

  subsidiaryBloc
      .obtenerSucursalporIdCompany(companysubsidiaryModel.idSubsidiary);
  pointsBloc.obtenerPoints();

  savePointApi.savePoint(companysubsidiaryModel.idSubsidiary);
}

void quitarSubsidiaryFavorito(
    BuildContext context, SubsidiaryModel subsidiaryModel) async {
  final sucursalBloc = ProviderBloc.sucursal(context);
  final pointsBloc = ProviderBloc.points(context);

  SubsidiaryModel companysubsidiaryModel = SubsidiaryModel();
  final sucursalDataBase = SubsidiaryDatabase();
  final deletePoint = PointApi();

  companysubsidiaryModel.idSubsidiary = subsidiaryModel.idSubsidiary;
  companysubsidiaryModel.idCompany = subsidiaryModel.idCompany;
  companysubsidiaryModel.subsidiaryName = subsidiaryModel.subsidiaryName;
  companysubsidiaryModel.subsidiaryCellphone =
      subsidiaryModel.subsidiaryCellphone;
  companysubsidiaryModel.subsidiaryCellphone2 =
      subsidiaryModel.subsidiaryCellphone2;
  companysubsidiaryModel.subsidiaryEmail = subsidiaryModel.subsidiaryEmail;
  companysubsidiaryModel.subsidiaryCoordX = subsidiaryModel.subsidiaryCoordX;
  companysubsidiaryModel.subsidiaryCoordY = subsidiaryModel.subsidiaryCoordY;
  companysubsidiaryModel.subsidiaryOpeningHours =
      subsidiaryModel.subsidiaryOpeningHours;
  companysubsidiaryModel.subsidiaryPrincipal =
      subsidiaryModel.subsidiaryPrincipal;
  companysubsidiaryModel.subsidiaryStatus = subsidiaryModel.subsidiaryStatus;
  companysubsidiaryModel.subsidiaryFavourite = "0";

  final res = await sucursalDataBase.updateSubsidiary(companysubsidiaryModel);
  print('update $res');

  sucursalBloc.obtenerSucursalporIdCompany(subsidiaryModel.idSubsidiary);
  pointsBloc.obtenerPoints();
  deletePoint.deletePoint(companysubsidiaryModel.idSubsidiary);
}


void quitarSubsidiaryFavoritodePointPage(
    BuildContext context, PointModel pointModel) async {
  final sucursalBloc = ProviderBloc.sucursal(context);
  final pointsBloc = ProviderBloc.points(context);
  final pointsProdBloc = ProviderBloc.points(context);

  SubsidiaryModel subsidiaryModel = SubsidiaryModel();
  final sucursalDataBase = SubsidiaryDatabase(); 

  subsidiaryModel.idSubsidiary = pointModel.idSubsidiary;
  subsidiaryModel.idCompany = pointModel.idCompany;
  subsidiaryModel.subsidiaryName = pointModel.subsidiaryName;
  subsidiaryModel.subsidiaryCellphone =
      pointModel.subsidiaryCellphone;
  subsidiaryModel.subsidiaryCellphone2 =
      pointModel.subsidiaryCellphone2;
  subsidiaryModel.subsidiaryEmail = pointModel.subsidiaryEmail;
  subsidiaryModel.subsidiaryCoordX = pointModel.subsidiaryCoordX;
  subsidiaryModel.subsidiaryCoordY = pointModel.subsidiaryCoordY;
  subsidiaryModel.subsidiaryOpeningHours =
      pointModel.subsidiaryOpeningHours;
  subsidiaryModel.subsidiaryPrincipal =
      pointModel.subsidiaryPrincipal;
  subsidiaryModel.subsidiaryStatus = pointModel.subsidiaryStatus;
  subsidiaryModel.subsidiaryFavourite = "0";

  final res = await sucursalDataBase.updateSubsidiary(subsidiaryModel);
  print('update $res');

  sucursalBloc.obtenerSucursalporIdCompany(pointModel.idSubsidiary);
  pointsBloc.obtenerPoints();
    pointsProdBloc.obtenerPointsProductosXSucursal();
  //deletePoint.deletePoint(subsidiaryModel.idSubsidiary);
}

Future<int> agregarAlCarrito(BuildContext context, String idSubsidiarygood,
    String talla, String modelo, String marca) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  final productCarrito =
      await carritoDb.obtenerProductoXCarritoPorIdProductoTalla(
          idSubsidiarygood, talla, modelo, marca);

  final producto = await productoDatabase
      .obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);
  CarritoModel c = CarritoModel();

  c.idSubsidiaryGood = producto[0].idProducto;
  c.idSubsidiary = producto[0].idSubsidiary;
  c.precio = producto[0].productoPrice;
  c.nombre = producto[0].productoName;
  c.marca = marca;
  c.modelo = modelo;
  c.talla = talla;
  c.image = producto[0].productoImage;
  c.moneda = producto[0].productoCurrency;
  c.size = producto[0].productoSize;
  c.stock = producto[0].productoStock;

  if (productCarrito.length > 0) {
    //await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
    await carritoDb.deleteCarritoPorIdProductoTalla(
        idSubsidiarygood, talla, modelo, marca);
    c.cantidad = (int.parse(productCarrito[0].cantidad) + 1).toString();

    c.estadoSeleccionado = productCarrito[0].estadoSeleccionado;
  } else {
    c.cantidad = '1';
    c.estadoSeleccionado = '0';
  }

  await carritoDb.insertarProducto(c);

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();

  return 0;
}

void agregarAlCarritoContador(BuildContext context, String idSubsidiarygood,
    String talla, String modelo, String marca, int cantidad) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  if (cantidad == 0) {
    //eliminar producto del carrito
    //await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
    await carritoDb.deleteCarritoPorIdProductoTalla(
        idSubsidiarygood, talla, modelo, marca);
  } else {
    final producto = await productoDatabase
        .obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);

    final carritoList =
        await carritoDb.obtenerProductoXCarritoPorIdProductoTalla(
            idSubsidiarygood, talla, modelo, marca);

    CarritoModel c = CarritoModel();

    c.idSubsidiaryGood = producto[0].idProducto;
    c.idSubsidiary = producto[0].idSubsidiary;
    c.precio = producto[0].productoPrice;
    c.nombre = producto[0].productoName;
    c.marca = marca;
    c.modelo = modelo;
    c.talla = talla;
    c.image = producto[0].productoImage;
    c.moneda = producto[0].productoCurrency;
    c.size = producto[0].productoSize;
    c.stock = producto[0].productoStock;
    c.estadoSeleccionado = carritoList[0].estadoSeleccionado;
    c.cantidad = cantidad.toString();

    await carritoDb.updateCarritoPorIdSudsidiaryGoodTalla(c);
  }

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarritoPorSucursal();
  carritoBloc.carritoPorSucursalSeleccionado();
}

void porcentaje(BuildContext context, double porcen) async {
  final porcentajeBloc = ProviderBloc.porcentaje(context);
  porcentajeBloc.changePorcentaje(porcen);
}

void agregarPSaSugerencia(
    BuildContext context, String idProduct, String tipo) async {
  final sugerenciaBusquedaDb = SugerenciaBusquedaDb();
  final productoDatabase = ProductoDatabase();
  final subsidiaryServiceDatabase = SubsidiaryServiceDatabase();

  final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);

  if (tipo == 'bien') {
    final bienList =
        await productoDatabase.obtenerProductoPorIdSubsidiaryGood(idProduct);

    SugerenciaBusquedaModel sugerenciaBusquedaModel = SugerenciaBusquedaModel();
    sugerenciaBusquedaModel.idItemSubcategoria = bienList[0].idItemsubcategory;
    sugerenciaBusquedaModel.nombreProducto = bienList[0].productoName;
    sugerenciaBusquedaModel.idProducto = bienList[0].idProducto;
    sugerenciaBusquedaModel.tipo = tipo;

    await sugerenciaBusquedaDb.insertarProducto(sugerenciaBusquedaModel);
  } else {
    final serviceList = await subsidiaryServiceDatabase
        .obtenerServiciosPorIdSucursalService(idProduct);

    SugerenciaBusquedaModel sugerenciaBusquedaModel = SugerenciaBusquedaModel();
    sugerenciaBusquedaModel.idItemSubcategoria =
        serviceList[0].idItemsubcategory;
    sugerenciaBusquedaModel.nombreProducto =
        serviceList[0].subsidiaryServiceName;
    sugerenciaBusquedaModel.idProducto = serviceList[0].idSubsidiaryservice;
    sugerenciaBusquedaModel.tipo = tipo;

    await sugerenciaBusquedaDb.insertarProducto(sugerenciaBusquedaModel);
  }

  sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
}

void irADetalleProducto(BienesServiciosModel model, BuildContext context) {
  ProductoModel productoModel = ProductoModel();
  productoModel.idProducto = model.idSubsidiarygood;
  productoModel.idSubsidiary = model.idSubsidiary;
  productoModel.idGood = model.idGood;
  productoModel.idItemsubcategory = model.idItemsubcategory;
  productoModel.productoName = model.subsidiaryGoodName;
  productoModel.productoPrice = model.subsidiaryGoodPrice;
  productoModel.productoCurrency = model.subsidiaryGoodCurrency;
  productoModel.productoImage = model.subsidiaryGoodImage;
  productoModel.productoCharacteristics = model.subsidiaryGoodCharacteristics;
  productoModel.productoBrand = model.subsidiaryGoodBrand;
  productoModel.productoModel = model.subsidiaryGoodModel;
  productoModel.productoType = model.subsidiaryGoodType;
  productoModel.productoSize = model.subsidiaryGoodSize;
  productoModel.productoStock = model.subsidiaryGoodStock;
  productoModel.productoMeasure = model.subsidiaryGoodMeasure;
  productoModel.productoRating = model.subsidiaryGoodRating;
  productoModel.productoUpdated = model.subsidiaryGoodUpdated;
  productoModel.productoStatus = model.subsidiaryGoodStatus;

  productoModel.productoFavourite = model.subsidiaryGoodFavourite;

  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) {
        return DetalleProductos(producto: productoModel);
        //return DetalleProductitos(productosData: productosData);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void cambiarEstadoCarrito(BuildContext context, String idProducto, String talla,
    String modelo, String marca, String estado) async {
  final carritoBloc = ProviderBloc.productosCarrito(context);
  final carritodb = CarritoDb();

  await carritodb.updateSeleccionado(idProducto, estado, talla, modelo, marca);

  carritoBloc.obtenerCarritoPorSucursal();
}

void deseleccionarTiposPago() async {
  final tiposPagoDatabase = TiposPagoDatabase();
  await tiposPagoDatabase.deseleccionarTiposPago();
}

void seleccionarTiposPago(BuildContext context, String idTiposPago) async {
  final tiposPagoBloc = ProviderBloc.tiPago(context);
  final tiposPagoDatabase = TiposPagoDatabase();
  await tiposPagoDatabase.deseleccionarTiposPago();
  await tiposPagoDatabase.updateSeleccionarTiposPago(idTiposPago);

  tiposPagoBloc.obtenerTipoPagoSeleccionado();
  tiposPagoBloc.obtenerTiposPago();
}

void agregarDireccion(BuildContext context, String direccion, String referencia,
    String distrito) async {
  final direccionDatabase = DireccionDatabase();

  DireccionModel direccionModel = DireccionModel();

  direccionModel.address = direccion;
  direccionModel.referencia = referencia;
  direccionModel.distrito = distrito;

  await direccionDatabase.insertarDireccion(direccionModel);

  Navigator.pop(context);
}

//Talla del producto
Future<int> cambiarEstadoTalla(
    BuildContext context, TallaProductoModel tallaModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final tallaProductoDatabase = TallaProductoDatabase();
//cambiar todos los estado de la tabla asignada a 0.
  await tallaProductoDatabase.updateEstadoa0();

  await tallaProductoDatabase.updateEstadoa1(tallaModel);

  datosProdBloc.listarDatosProducto(tallaModel.idProducto);
  return 1;
}

//Marca del producto
Future<int> cambiarEstadoMarca(
    BuildContext context, MarcaProductoModel marcaModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final marcaProductoDatabase = MarcaProductoDatabase();
//cambiar todos los estado de la tabla asignada a 0.
  await marcaProductoDatabase.updateEstadoa0();

  await marcaProductoDatabase.updateEstadoa1(marcaModel);

  datosProdBloc.listarDatosProducto(marcaModel.idProducto);

  return 1;
}

//Modelo del producto
Future<int> cambiarEstadoModelo(
    BuildContext context, ModeloProductoModel modeloModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final modeloProductoDatabase = ModeloProductoDatabase();

//cambiar todos los estado de la tabla asignada a 0.
  await modeloProductoDatabase.updateEstadoa0();

  await modeloProductoDatabase.updateEstadoa1(modeloModel);

  datosProdBloc.listarDatosProducto(modeloModel.idProducto);
  return 0;
}

Future<List<ProductoModel>> filtrarListaProductos(
    List<ProductoModel> lista) async {
  final listAlgo = List<ProductoModel>();

  final listString = List<String>();
  for (var a = 0; a < lista.length; a++) {
    listString.add(lista[a].idProducto);
  }
  var listString2 = listString.toSet().toList();

  for (var x = 0; x < listString2.length; x++) {
    for (var i = 0; i < lista.length; i++) {
      if (listString2[x] != lista[i].idProducto) {
        bool valor = false;

        for (var y = 0; y < listAlgo.length; y++) {
          if (lista[i].idProducto == listAlgo[y].idProducto) {
            valor = true;
          }
        }

        if (valor) {
          print('Contenido');
        } else {
          ProductoModel productoModel = ProductoModel();
          productoModel.idProducto = lista[i].idProducto;
          productoModel.idSubsidiary = lista[i].idSubsidiary;
          productoModel.idGood = lista[i].idGood;
          productoModel.idItemsubcategory = lista[i].idItemsubcategory;
          productoModel.productoName = lista[i].productoName;
          productoModel.productoPrice = lista[i].productoPrice;
          productoModel.productoCurrency = lista[i].productoCurrency;
          productoModel.productoImage = lista[i].productoImage;
          productoModel.productoCharacteristics =
              lista[i].productoCharacteristics;
          productoModel.productoBrand = lista[i].productoBrand;
          productoModel.productoModel = lista[i].productoModel;
          productoModel.productoType = lista[i].productoType;
          productoModel.productoSize = lista[i].productoSize;
          productoModel.productoStock = lista[i].productoStock;
          productoModel.productoStockStatus = lista[i].productoStockStatus;
          productoModel.productoMeasure = lista[i].productoMeasure;
          productoModel.productoRating = lista[i].productoRating;
          productoModel.productoUpdated = lista[i].productoUpdated;
          productoModel.productoStatus = lista[i].productoStatus;

          listAlgo.add(productoModel);
        }
      } else {
        print('entra arriba abajo $x');
      }
    }
  }

  return listAlgo;
}

Future<List<CompanyModel>> filtrarListaNegocios(
    List<CompanyModel> lista) async {
  final listAlgo = List<CompanyModel>();

  final listString = List<String>();
  for (var a = 0; a < lista.length; a++) {
    listString.add(lista[a].idCompany);
  }
  var listString2 = listString.toSet().toList();

  for (var x = 0; x < listString2.length; x++) {
    for (var i = 0; i < lista.length; i++) {
      if (listString2[x] != lista[i].idCompany) {
        bool valor = false;

        for (var y = 0; y < listAlgo.length; y++) {
          if (lista[i].idCompany == listAlgo[y].idCompany) {
            valor = true;
          }
        }

        if (valor) {
          print('Contenido');
        } else {
          CompanyModel companyModel = CompanyModel();
          companyModel.idCompany = lista[i].idCompany;
          companyModel.idUser = lista[i].idUser;
          companyModel.idCity = lista[i].idCity;
          companyModel.idCategory = lista[i].idCategory;
          companyModel.companyName =lista[i].companyName;
          companyModel.companyRuc = lista[i].companyRuc;
          companyModel.companyImage =lista[i].companyImage;
          companyModel.companyType =lista[i].companyType;
          companyModel.companyShortcode =lista[i].companyShortcode;
          companyModel.companyDelivery =lista[i].companyDelivery;
          companyModel.companyEntrega =lista[i].companyEntrega;
          companyModel.companyTarjeta =lista[i].companyTarjeta;
          companyModel.companyVerified =lista[i].companyVerified;
          companyModel.companyRating =lista[i].companyRating;
          companyModel.companyCreatedAt =lista[i].companyCreatedAt;
          companyModel.companyJoin =lista[i].companyJoin;
          companyModel.companyStatus =lista[i].companyStatus;
          companyModel.companyMt = lista[i].companyMt;
          companyModel.idCountry = lista[i].idCountry;
          companyModel.cityName = lista[i].cityName;
          companyModel.distancia = lista[i].distancia;

          listAlgo.add(companyModel);
        }
      } else {
        print('entra arriba abajo $x');
      }
    }
  }

  return listAlgo;
}
