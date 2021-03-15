import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProductoFotoPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/Direccion/AgregarDireccionPAge.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/RatingPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/ValoracionPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/Direccion/direccionPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/perfilPage.dart';
import 'package:bufi/src/page/cuenta/agentesPage.dart';
import 'package:bufi/src/page/cuenta/puntosRecargaPage.dart';
import 'package:bufi/src/page/cuenta/subir_vaucher_recarga.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/Categorias/categoriasPage.dart';
import 'package:bufi/src/page/Tabs/Carrito/carritoTab.dart';
import 'package:bufi/src/page/Tabs/Carrito/carrito_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/inicio/detalleNegocio.dart';
import 'package:bufi/src/bloc/subsidiary/negocio_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/page/Tabs/Points/points_bloc.dart';
import 'package:bufi/src/page/Tabs/Principal/listarBienesAll.dart';
import 'package:bufi/src/page/Tabs/Principal/listarServiciosAll.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/PedidosPage.dart';
import 'package:bufi/src/page/cuenta/recargar_saldo.dart';
import 'package:bufi/src/page/home.dart';
import 'package:bufi/src/page/login_page.dart';
import 'package:bufi/src/page/cuenta/mis_movimientos_page.dart';
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
          ChangeNotifierProvider<CarritoBlocListener>(
            create: (_) => CarritoBlocListener(),
          ),
          ChangeNotifierProvider<ConfirmPedidoBloc>(
            create: (_) => ConfirmPedidoBloc(),
          ),
          ChangeNotifierProvider<NegociosBlocListener>(
            create: (_) => NegociosBlocListener(),
          ),
          //ChangeNotifierProvider<RegistroNegocioBlocListener>(create: (_) => RegistroNegocioBlocListener()),
          ChangeNotifierProvider<PointsBlocListener>(
            create: (_) => PointsBlocListener(),
          ),
          ChangeNotifierProvider<DetailSubsidiaryBloc>(
            create: (_) => DetailSubsidiaryBloc(),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
           
            theme: lightTheme,
            darkTheme:lightTheme, //darkTheme,
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
              //"registroNegocio": (BuildContext context) => RegistroNegocio(),
              "detalleNegocio": (BuildContext context) => DetalleNegocio(),



              //Producto
              //"listarProductoAll": (BuildContext context)=> ListarProductosPorSucursal(),
              //"detalleProducto": (BuildContext context)=> DetalleProductos(),
              "agregarAlCarrito": (BuildContext context) => CarritoPage(),
              "detalleProductoFoto": (BuildContext context)=> DetalleProductoFoto(),
              

              //Servicio
             // "detalleServicio": (BuildContext context) => DetalleServicio(),
              // "listarServiciosXsucursal": (BuildContext context) =>

              //Usuario
              
              //Direccion
              'perfil': (BuildContext context) =>PerfilPage(),
                
                //Direccion
              'direccion': (BuildContext context) =>DireccionDeliveryPage(),
              'agregarDireccion': (BuildContext context) =>AgregarDireccionPage(),
                //Pedidos
              'pedidos': (BuildContext context) =>PedidosPage(),
              'valoracion': (BuildContext context) =>PendientesValoracionPage(),
              'ratingProductos': (BuildContext context) =>RatingProductosPage(),
                //Bufis
              'misMovimientos': (BuildContext context) => MisMovimientosPage(),
              'recargarSaldo': (BuildContext context) => RecargarSaldo(),
              'subirVaucher': (BuildContext context) => SubirVaucher(),
              'puntosRecarga': (BuildContext context) => PuntosRecargaPage(),
              'agentes': (BuildContext context) => AgentesPage(),
            }),
      ),
    );
  }
}
