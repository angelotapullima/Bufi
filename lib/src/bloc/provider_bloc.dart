import 'package:bufi/src/bloc/bienesServicios_bloc.dart';
import 'package:bufi/src/bloc/bottom_navigation_bloc.dart';
import 'package:bufi/src/bloc/busquedaBloc.dart';
import 'package:bufi/src/bloc/carrito_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/itemCategBloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/navegacionCategorias.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/subcategoriaGeneralBloc.dart';
import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/bloc/favoritos_bloc.dart';
import 'package:bufi/src/bloc/login_bloc.dart';
import 'package:bufi/src/bloc/mis_movimientos_bloc.dart';

import 'package:bufi/src/bloc/negocios_bloc.dart';

import 'package:bufi/src/bloc/porcentaje_splash.dart';
import 'package:bufi/src/bloc/principal_bloc.dart';
import 'package:bufi/src/bloc/producto/paginaActualBloc.dart';
import 'package:bufi/src/bloc/producto/producto_bloc.dart';
import 'package:bufi/src/bloc/servicios/servicios_bloc.dart';
import 'package:bufi/src/bloc/subsidiary/registrarSubsidiary_bloc.dart';
import 'package:bufi/src/bloc/subsidiary/sucursal_bloc.dart';
import 'package:bufi/src/bloc/sugerenciaBusquedaBloc.dart';
import 'package:bufi/src/bloc/tipos_pago_bloc.dart';
import 'package:flutter/material.dart';

class ProviderBloc extends InheritedWidget {
  static ProviderBloc _instancia;

  final loginBloc = LoginBloc();
  final categoriabloc = CategoriaBloc();
  final tabsNavigationbloc = TabNavigationBloc();
  final bienesServiciosBloc = BienesServiciosBloc();
  final negociosBloc = NegociosBloc();
  //final registroNegoc = RegistroNegocioBloc();
  final sucursalbloc = SucursalBloc();
  final pointsBloc = PointsBloc();
  final registrarSucursalBloc = RegistroSucursalBloc();
  //final actualizarNegBloc = ActualizarNegocioBloc();
  final productosBloc = ProductoBloc();
  final listarServiciosBloc = ListarServiciosBloc();
  final carritoBloc = CarritoBloc();
  final naviCategBloc = CategoriasNaviBloc();
  final bottomNaviBloc = BottomNaviBloc();
  final busquedaBloc = BusquedaBloc();
  //final itemSubcategoriaBloc = ItemSubcategoriaBloc();
  final subcategoriaGeneralBloc = SubCategoriaGeneralBloc();
  final itemSubcategBloc = ItemCategoriaBloc();
  final sugerenciaBusquedaBloc = SugerenciaBusquedaBloc();
  final porcentajesBloc = PorcentajesBloc();
  final cuentaBloc = CuentaBloc();
  final misMovimientosBloc = MisMovimientosBloc();
  final tiposPagoBloc = TiposPagoBloc();
  final contadorBloc = ContadorPaginaProductosBloc();

  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }

    return _instancia;
  }

  ProviderBloc._internal({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProviderBloc oldWidget) => true;

// Regresa el estado actual del widgetbloc

  static LoginBloc login(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .loginBloc;
  }

  //obtener las categorias
  static CategoriaBloc categoria(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .categoriabloc;
  }

//tab
  static TabNavigationBloc tabs(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .tabsNavigationbloc;
  }

//Bienes y Servicios
  static BienesServiciosBloc bienesServicios(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .bienesServiciosBloc;
  }

  static NegociosBloc negocios(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .negociosBloc;
  }

  // static RegistroNegocioBloc registroNegocio(BuildContext context) {
  //   return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
  //       .registroNegoc;
  // }

  static SucursalBloc sucursal(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .sucursalbloc;
  }

  static PointsBloc points(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pointsBloc;
  }

  static RegistroSucursalBloc registroSuc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .registrarSucursalBloc;
  }

  // static ActualizarNegocioBloc actualizarNeg(BuildContext context) {
  //   return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
  //       .actualizarNegBloc;
  // }

  static SucursalBloc listarsucursalPorId(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .sucursalbloc;
  }

  static ProductoBloc productos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .productosBloc;
  }

  static ListarServiciosBloc listarServicios(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .listarServiciosBloc;
  }

  static CarritoBloc productosCarrito(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .carritoBloc;
  }

  //Busqueda de bienes y servicios
  static BusquedaBloc busqueda(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .busquedaBloc;
  }

//NAvegacion entre las categorias de Bb y Ss
  static CategoriasNaviBloc naviCategoria(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .naviCategBloc;
  }

  static BottomNaviBloc bottom(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .bottomNaviBloc;
  }

  // static ItemSubcategoriaBloc itemSubcategoria(BuildContext context) {
  //   return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
  //       .itemSubcategoriaBloc;
  // }
  static SubCategoriaGeneralBloc subcategoriaGeneral(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .subcategoriaGeneralBloc;
  }

  static ItemCategoriaBloc itemSubcategoria(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .itemSubcategBloc;
  }

  //Muestra prodcutos o servicios relacionados a la busqueda del preferencias_usuario
  static SugerenciaBusquedaBloc sugerenciaXbusqueda(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .sugerenciaBusquedaBloc;
  }

  static PorcentajesBloc porcentaje(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .porcentajesBloc;
  }

  static CuentaBloc cuenta(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .cuentaBloc;
  }

  static MisMovimientosBloc misMov(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .misMovimientosBloc;
  }

  static TiposPagoBloc tiPago(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .tiposPagoBloc;
  }

  static ContadorPaginaProductosBloc contadorPagina(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .contadorBloc;
  }
}
