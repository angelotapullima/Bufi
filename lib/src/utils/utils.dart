import 'package:bufi/src/api/point_api.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/database/sugerenciaBusqueda_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/sugerenciaBusquedaModel.dart';
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

void agregarAlCarrito(BuildContext context, String idSubsidiarygood) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();
  final producto = await productoDatabase
      .obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);
  CarritoModel c = CarritoModel();

  c.idSubsidiaryGood = producto[0].idProducto;
  c.idSubsidiary = producto[0].idSubsidiary;
  c.precio = producto[0].productoPrice;
  c.nombre = producto[0].productoName;
  c.marca = producto[0].productoBrand;
  c.image = producto[0].productoImage;
  c.moneda = producto[0].productoCurrency;
  c.size = producto[0].productoSize;
  c.stock = producto[0].productoStock;
  c.estadoSeleccionado = '0';
  c.cantidad = '1';

  await carritoDb.insertarProducto(c);

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarrito();
}

void agregarAlCarritoContador(
    BuildContext context, String idSubsidiarygood, int cantidad) async {
  CarritoDb carritoDb = CarritoDb();
  final productoDatabase = ProductoDatabase();

  if (cantidad == 0) {
    //eliminar producto del carrito
    await carritoDb.deleteCarritoPorIdSudsidiaryGood(idSubsidiarygood);
  } else {
    final producto = await productoDatabase
        .obtenerProductoPorIdSubsidiaryGood(idSubsidiarygood);

    final carritoList =
        await carritoDb.obtenerProductoXCarritoPorId(idSubsidiarygood);

    CarritoModel c = CarritoModel();

    c.idSubsidiaryGood = producto[0].idProducto;
    c.idSubsidiary = producto[0].idSubsidiary;
    c.precio = producto[0].productoPrice;
    c.nombre = producto[0].productoName;
    c.marca = producto[0].productoBrand;
    c.image = producto[0].productoImage;
    c.moneda = producto[0].productoCurrency;
    c.size = producto[0].productoSize;
    c.stock = producto[0].productoStock;
    c.estadoSeleccionado = carritoList[0].estadoSeleccionado;
    c.cantidad = cantidad.toString();

    await carritoDb.updateCarritoPorIdSudsidiaryGood(c);
  }

  final carritoBloc = ProviderBloc.productosCarrito(context);
  carritoBloc.obtenerCarrito();
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

void cambiarEstadoCarrito(
    BuildContext context, String idProducto, String estado) async {
  final carritoBloc = ProviderBloc.productosCarrito(context);
  final carritodb = CarritoDb();

  await carritodb.updateSeleccionado(idProducto, estado);

  carritoBloc.obtenerCarrito();
}

//Actualizar Negocio
void actualizarNegocio(BuildContext context,CompanySubsidiaryModel model) async {
  final detallenegocio = ProviderBloc.negocios(context);
  //final actualizarNeg = ProviderBloc.actualizarNeg(context);
    
  final sucursalDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
  final sucursalModel = SubsidiaryModel();
  final companyModel = CompanyModel();

//datos que se reciben desde los controllers
  sucursalModel.idSubsidiary = model.idSubsidiary;
  sucursalModel.subsidiaryCellphone = model.subsidiaryCellphone;
  sucursalModel.subsidiaryCellphone2 = model.subsidiaryCellphone2;
  sucursalModel.subsidiaryCoordX = model.subsidiaryCoordX;
  sucursalModel.subsidiaryCoordY = model.subsidiaryCoordY;
  sucursalModel.subsidiaryOpeningHours = model.subsidiaryOpeningHours;
  sucursalModel.subsidiaryAddress = model.subsidiaryAddress;

//obtener todos los datos de la sucursal para pasar como argumento en update
  final listSucursales =
      await sucursalDb.obtenerSubsidiaryPorId(model.idSubsidiary);

  sucursalModel.idCompany = listSucursales[0].idCompany;
  sucursalModel.subsidiaryName = listSucursales[0].subsidiaryName;
  sucursalModel.subsidiaryEmail = listSucursales[0].subsidiaryEmail;
  sucursalModel.subsidiaryPrincipal = listSucursales[0].subsidiaryPrincipal;
  sucursalModel.subsidiaryStatus = listSucursales[0].subsidiaryStatus;

  await sucursalDb.updateSubsidiary(sucursalModel);

//Obtener datos de company
  companyModel.idCompany = model.idCompany;
  companyModel.idCategory = model.idCategory;
  companyModel.companyName = model.companyName;
  companyModel.companyRuc = model.companyRuc;
  companyModel.companyImage = model.companyImage;
  companyModel.companyType = model.companyType;
  companyModel.companyShortcode = model.companyShortcode;
  companyModel.companyDelivery = model.companyDelivery;
  companyModel.companyEntrega = model.companyEntrega;
  companyModel.companyTarjeta = model.companyTarjeta;

  final listCompany = await companyDb.obtenerCompanyPorId(model.idCompany);

  companyModel.idCompany = listCompany[0].idCompany;
  companyModel.idUser = listCompany[0].idUser;
  companyModel.idCity = listCompany[0].idCity;
  companyModel.idCategory = listCompany[0].idCategory;
  companyModel.companyVerified = listCompany[0].companyVerified;
  companyModel.companyRating = listCompany[0].companyRating;
  companyModel.companyCreatedAt = listCompany[0].companyCreatedAt;
  companyModel.companyJoin = listCompany[0].companyJoin;
  companyModel.companyStatus = listCompany[0].companyStatus;
  companyModel.companyMt = listCompany[0].companyMt;
  companyModel.miNegocio = listCompany[0].miNegocio;

  await companyDb.updateCompany(companyModel);
  //actualizarNeg.updateNegocio(id)
  detallenegocio.obtenernegociosporID(model.idCompany);
}
