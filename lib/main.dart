import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/Categorias/categoriasPage.dart';
import 'package:bufi/src/page/Tabs/Carrito/carritoTab.dart';
import 'package:bufi/src/page/Tabs/Carrito/carrito_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detalleSubsidiary.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/registrarSubsidiaryPage.dart';
import 'package:bufi/src/page/Tabs/Negocios/actualizarNegocio_page.dart';
import 'package:bufi/src/page/Tabs/Negocios/detalleNegocio/detalleNegocio.dart';
import 'package:bufi/src/page/Tabs/Negocios/inicio/negocio_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/negocioActualizado.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/registrarProducto.dart';
import 'package:bufi/src/page/Tabs/Negocios/registroNegocio/registrarNegocioPage.dart';
import 'package:bufi/src/page/Tabs/Negocios/registroNegocio/registro_negocio_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/ListarServiciosXsucursal.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/registrarSerivicio.dart';
import 'package:bufi/src/page/Tabs/Points/points_bloc.dart';
import 'package:bufi/src/page/Tabs/Principal/listarBienesAll.dart';
import 'package:bufi/src/page/Tabs/Principal/listarServiciosAll.dart';
import 'package:bufi/src/page/home.dart';
import 'package:bufi/src/page/login_page.dart';
import 'package:bufi/src/page/mis_movimientos_page.dart';
import 'package:bufi/src/page/registro_usuarioTab.dart';
import 'package:bufi/src/page/splash.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new Preferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CarritoBlocListener>(create: (_) => CarritoBlocListener()),
          ChangeNotifierProvider<ConfirmPedidoBloc>(create: (_) => ConfirmPedidoBloc()),
          ChangeNotifierProvider<NegociosBlocListener>(create: (_) => NegociosBlocListener()),
          ChangeNotifierProvider<RegistroNegocioBlocListener>(create: (_) => RegistroNegocioBlocListener()),
          ChangeNotifierProvider<PointsBlocListener>(create: (_) => PointsBlocListener()),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme:lightTheme, //darkTheme,
            //themeMode: ThemeMode.system,
            home: Splash(),
            //initialRoute:(prefs.idUser=="" || prefs.idUser==null)?'login':'home',
            routes: {
              "login": (BuildContext context) => LoginPage(),
              "home": (BuildContext context) => HomePage(),
              "registroUsuario": (BuildContext context) => RegistroUsuario(),
              "splash": (BuildContext context) => Splash(),

              //Pagina Principal
              "listaCategoriasAll": (BuildContext context) => ListaCategoria(),

              //Bienes
              "listarBienesAll": (BuildContext context) => ListarBienesAll(),
              //Servicios
              "listarServiciosAll": (BuildContext context) =>
                  ListarServiciosAll(),

              //Negocio
              "registroNegocio": (BuildContext context) => RegistroNegocio(),
              "detalleNegocio": (BuildContext context) => DetalleNegocio(),
              "actualizarNegocio": (BuildContext context) =>
                  ActualizarNegocio(),
              // "negocioActualizado": (BuildContext context) =>
              //     NegocioActualizado(),

              //Sucursal
              "detalleSubsidiary": (BuildContext context) =>
                  DetalleSubsidiary(),
              "registroSubsidiary": (BuildContext context) =>
                  RegistroSubsidiary(),

              //Producto
              "guardarProducto": (BuildContext context) => GuardarProducto(),

              //"listarProductoAll": (BuildContext context)=> ListarProductosPorSucursal(),

              //"detalleProducto": (BuildContext context)=> DetalleProductos(),
              "agregarAlCarrito": (BuildContext context) => CarritoPage(),

              //Servicio
              "guardarServicio": (BuildContext context) => GuardarServicio(),
              "detalleServicio": (BuildContext context) => DetalleServicio(),
              // "listarServiciosXsucursal": (BuildContext context) =>

              'misMovimientos': (BuildContext context) => MisMovimientosPage(),
              
              //     ListarServiciosXSucursal()
            }),
      ),
    );
  }
}
